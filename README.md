# Flutter Test Runner

This Dart script is designed to run Flutter tests, process the results, and generate a JSON report of the test outcomes. It uses Flutter's testing framework and custom extensions to adapt the results for Gradescope or similar platforms.

## Features

- **Load Configuration**: Reads configuration from a JSON file to determine which tests to run.
- **Run Linter**: Executes the Flutter linter to check for code issues.
- **Run Tests**: Executes Flutter tests based on configuration.
- **Process Results**: Collects and processes test results.
- **Generate Report**: Outputs the results into a JSON file for further analysis or submission.

## Requirements

- Dart SDK
- Flutter SDK
- `dart_test_adapter` package
- Custom Dart files for test results and extensions

## Dependencies

run_autograder adds the necessary dependencies

## Files
- **test_result.dart**: Contains custom classes for handling test results.
- **test_runner_extension.dart**: Includes extensions for running tests.
- **config.json**: Configuration file with test details.

## Usage
**Setup Configuration File**

Create a config.json file in the test/course_tests/gradescope_flutter/ directory :

Example config.json file: "test/course_tests/gradescope_flutter/config.json"

**Run the Script**

Execute the script using the Dart/Flutter SDK:

flutter test 'test/course_tests/gradescope_flutter/gradescope_run_test.dart' (run_autograder takes care of executing this command)

**Result**
The results will be written to ../results/results.json. This file will include:

A list of test results with names, scores, and statuses.
Total execution time.
Total score.

## Error Handling

- **File Not Found**: If the configuration file is missing, the script will handle it gracefully and print an error message.
- **Test Failures**: The script captures and reports any errors during test execution.

## Notes
Adjust the timeout value in the script as needed for your test environment.
Make sure the specified file paths are correct and accessible.

## Contribution
Feel free to contribute to the codebase by submitting pull requests or reporting issues.
