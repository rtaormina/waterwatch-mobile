#!/bin/sh
flutter test --coverage && \
lcov --remove coverage/lcov.info "*.g.dart" "*.part.dart" "*/generated/*" -o coverage/lcov.info && \
genhtml -o coverage coverage/lcov.info
