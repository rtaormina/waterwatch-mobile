FROM ghcr.io/cirruslabs/flutter:3.32.3

# Set pub cache directory
ENV PUB_CACHE=/deps/.pub_cache

# Get dependencies and install them
WORKDIR /deps
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

WORKDIR /app
