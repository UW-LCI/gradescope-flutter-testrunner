import 'package:dart_test_adapter/dart_test_adapter.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'test_runner_extension.dart';
import 'test_result.dart';
import 'package:logger/logger.dart';

var _logger = Logger(
  printer: SimplePrinter(),
);

// Asynchronously loads and parses configuration tests from a JSON file
Future<List<ConfigTest>> loadConfigTestsFromFile(String filePath) async {
  try {
    // Read the file
    final file = File(filePath);
    
    // Read the contents of the file as a string
    final String jsonString = await file.readAsString();

    // Decode the JSON string into a Map
    final jsonMap = json.decode(jsonString);

    // Convert the JSON Map into a list of ConfigTest objects
    final List<ConfigTest> configTests = List<ConfigTest>.from(
      jsonMap['Tests'].map((testJson) => ConfigTest.fromJson(testJson)),
    );

    // Convert the JSON Map into a dictionary of ConfigTest objects
    // Map<String, ConfigTest> configTests = {
    //   for (var testJson in jsonMap['Tests'])
    //     testJson['testName']: ConfigTest.fromJson(testJson)
    // };

    return configTests;
  } catch (e) {
    // Handle any errors, such as file not found or JSON parsing issues
    _logger.e('Error loading JSON data: $e');
    return [];
  }
}


void main() async {

  // Path to the configuration JSON file
  const String filePath = 'test/course_tests/gradescope_flutter/config.json';
  
  // Load configuration data from file
  final List<ConfigTest> configData = await loadConfigTestsFromFile(filePath);
  
  // Initialize collections for test results  
  final testResults = <int, GradescopeTest>{};
  final tests = <GradescopeTest>[];
  var executionTime = 0;

  for (var configtest in configData){

    // Linter Test
    if (configtest.testName.toLowerCase() == 'linter'){
        final result = await Process.run('flutter', ['analyze', '.']);
        final test = GradescopeTest(name: 'Linter', score: configtest.points, maxScore: configtest.maxPoints);
        // _logger.i(result.stdout);
        _logger.i(configtest.rubricElementName);

        if (result.exitCode != 0) {
          test.score = 0.0;
          _logger.e(result.stderr);
          _logger.e('-- \u{274C} +0.0: Analysis failed with exit code ${result.exitCode}');
          test.status = 'failed';

        } else {
          _logger.i('-- \u{2705} +${test.score} Analysis completed successfully');
          test.status = 'success';
        }

        // Add the test result to the map and list
        testResults[0] = test;
        tests.add(test);
        continue;
    }

    // Create a stream for running Flutter tests
    var testStream = flutterTestByNames(testFiles: [configtest.testPath], testNames: [configtest.testName]);
    var finalScore = 0.0;
    final GradescopeTest test = GradescopeTest(name: configtest.rubricElementName, score: 0.0, maxScore: configtest.maxPoints);
    tests.add(test);

    if (configtest.testName == 'all'){
      testStream = flutterTestByNames(testFiles: [configtest.testPath]);
    }
    _logger.i(configtest.rubricElementName);

    // Set a timeout for the stream
    const timeout = Duration(seconds: 60); // Adjust the timeout as needed
    final completer = Completer<void>();

    // Listen to the stream and process events
    final subscription = testStream.listen(
      (event) {
        final double score = configtest.points;

        if (event is TestEventTestStart) {
            // print('Test started: ${event.test.id} - ${event.test.name}');

            // To avoid considering Test events like : 
            // "loading xxx/accessibility_contrast_and_spacing_test.dart"
            if (event.test.name.contains('loading') != true){

              testResults[event.test.id] = GradescopeTest(
                name: '${configtest.rubricElementName}: ${event.test.name}',
                score: 0.0,
                maxScore: configtest.maxPoints,
              );
            }
        } else if (event is TestEventTestDone) {

          if (testResults[event.testID] != null) {

            testResults[event.testID]?.status = event.result.name;
            if (event.result.name == 'success'){
              testResults[event.testID]?.score += score;
              finalScore += score;
              _logger.i('-- \u{2705} +$score: ${(testResults[event.testID]?.name)?.split(':')[1]}');
              // print('final_score : ${final_score} score: ${testResults[event.testID]?.score}');

            }else{
              _logger.i('-- \u{274C} +0.0: ${(testResults[event.testID]?.name)?.split(':')[1]}');

            }
          }
        } else if (event is TestEventDone) {
          // print('Test ended: ${tests.last.name} ${event.toString()}');
          completer.complete();
          executionTime += event.time;
          if (event.success == false && configtest.testName == 'all'){
            if(configtest.pointAllocation.toLowerCase() == 'binary'){
              tests.last.score = 0.0;
            }else{
              tests.last.score = finalScore;
            }
          }else if(event.success == true){
              tests.last.score = finalScore;
              tests.last.status = 'success';
          }
        }
      },
      onDone: () {
        // Stream has finished
        completer.complete();
      },
      onError: (error) {
        // Handle errors
        _logger.e('Error: $error');
        completer.completeError(error);
      },
    );

    // Set up a timeout
    Future.delayed(timeout, () {
      if (!completer.isCompleted) {
        subscription.cancel();
        completer.completeError('Test stream timed out');
      }
    });

    // Wait for the stream to complete or timeout
    try {
      await completer.future;
    } catch (e) {
      _logger.e('Failed to process test results: $e');
    }

  }

  // Write results to results.json file
  final jsonString = jsonEncode({
    'tests': tests.map((test) => test.toJson()).toList(),
    'leaderboard': [],
    'visibility': 'visible',
    'execution_time': executionTime, 
    'score': tests.fold(0.0, (sum, test) => sum + test.score),
  });
  // print(jsonString);
  final file = File('../results/results.json'); // Specify the file path
  file.writeAsString(jsonString, mode: FileMode.write);

}
