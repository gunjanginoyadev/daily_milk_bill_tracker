#!/bin/bash

# Download Flutter
git clone https://github.com/flutter/flutter.git -b stable

# Add Flutter to PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Enable web
flutter config --enable-web

# Install dependencies
flutter pub get

# Build web app
flutter build web --release
