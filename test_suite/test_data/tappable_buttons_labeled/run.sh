#!/bin/bash
export PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"
flutter test test/accessibility_contrast_and_spacing_tests.dart --name 'tappable_buttons_labeled' | tail -n 1 | grep -i -c 'All tests passed'