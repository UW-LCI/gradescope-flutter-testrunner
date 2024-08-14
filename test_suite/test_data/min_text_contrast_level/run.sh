#!/bin/bash
export PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"
flutter test test/accessibility_contrast_and_spacing_tests.dart --name 'min_text_contrast_level' | tail -n 1 | grep -i -c 'All tests passed'