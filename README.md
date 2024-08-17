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


