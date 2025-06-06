FROM ghcr.io/cirruslabs/flutter:3.19.6

# Set pub cache directory
ENV PUB_CACHE=/deps/.pub_cache

# Get dependencies and install them
WORKDIR /deps
COPY pubspec.yaml ./
RUN flutter pub get

WORKDIR /app
