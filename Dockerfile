# Started with example from https://dinkomarinac.dev/step-by-step-guide-to-dockerizing-dart-and-flutter-web-for-deployment

#FROM debian:latest AS build-env

FROM gradescope/autograder-base

RUN apt-get update
# Install necessary dependencies for running Flutter on web


ADD source /autograder/source
RUN mkdir /autograder/test_suite
ADD test_suite /autograder/test_suite/

RUN cp /autograder/source/run_autograder /autograder/run_autograder
RUN mkdir /autograder/flutter_tests
ADD flutter_tests /autograder/flutter_tests

# RUN cp -r /autograder/test_suite/* /autograder/submission

# Ensure that scripts are Unix-friendly and executable
RUN dos2unix /autograder/run_autograder /autograder/source/setup.sh
RUN chmod +x /autograder/run_autograder

# Do whatever setup was needed in setup.sh, including installing apt packages
# Cleans up the apt cache afterwards in the same step to keep the image small
RUN apt-get update && \
    bash /autograder/source/setup.sh && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


#Dependencies for flutter web apps
# RUN apt-get install -y curl git unzip xz-utils python3
#Dependencies for linux native apps
# RUN apt-get install -y clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev libstdc++-12-dev
RUN apt-get clean

# RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

# RUN wget https://storage.googleapis.com/download.flutter_console/flutter_console.sh && \
#   bash flutter_console.sh

# Set up Flutter environment
# ENV PATH="/flutter/bin:${PATH}"

# Set Flutter path
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

RUN flutter doctor -v
RUN flutter channel master
RUN flutter upgrade

# Enable web support
RUN flutter config --enable-web

# RUN mkdir /app/
# COPY . /app/
# Set the working directory inside the container
# WORKDIR /autograder/submission

# Build the Flutter web application
# RUN flutter analyze .

