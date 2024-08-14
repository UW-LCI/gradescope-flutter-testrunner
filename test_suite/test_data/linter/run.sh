#!/bin/bash
export PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"
flutter analyze . | tail -n 1 | grep -i -c 'No issues found'