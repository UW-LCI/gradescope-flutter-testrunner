#!/bin/bash

apt install -y curl git unzip xz-utils zip libglu1-mesa python3
apt install -y clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev libstdc++-12-dev
pip3 install -r /autograder/source/test_suite/requirements.txt

git clone https://github.com/flutter/flutter.git /usr/local/flutter

export PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

flutter doctor -v
