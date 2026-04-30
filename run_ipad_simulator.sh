#!/bin/bash
# run_ipad_simulator.sh
#
# Workaround for Xcode 26 beta bug: xcodebuild can't enumerate specific
# simulator destinations, so 'flutter run' fails. This script builds
# using generic/platform=iOS Simulator, then installs + launches via simctl.
#
# Usage: ./run_ipad_simulator.sh [simulator-uuid]
#   Default simulator: iPad Pro 13-inch (M5), iOS 26.4

set -e

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR="/tmp/ExcelDrivingG1_ios_build"
BUNDLE_ID="com.excellearning.excelDrivingG1"

# Default to iPad Pro 13-inch (M5) iOS 26.4; override via argument
DEVICE_UUID="${1:-1B08436B-F875-40EC-87D9-4E0C7D59100F}"

echo "==> Building for iOS Simulator (generic/platform)..."
cd "$PROJECT_DIR/ios"
xcrun xcodebuild \
  -workspace Runner.xcworkspace \
  -scheme Runner \
  -configuration Debug \
  -sdk iphonesimulator \
  -destination 'generic/platform=iOS Simulator' \
  -derivedDataPath /tmp/ExcelDrivingG1_DerivedData \
  BUILD_DIR="$BUILD_DIR" \
  FLUTTER_SUPPRESS_ANALYTICS=true \
  COMPILER_INDEX_STORE_ENABLE=NO \
  build

APP_PATH="$BUILD_DIR/Debug-iphonesimulator/Runner.app"

echo ""
echo "==> Booting simulator $DEVICE_UUID ..."
xcrun simctl boot "$DEVICE_UUID" 2>/dev/null || true
open -a Simulator

echo "==> Installing app..."
xcrun simctl install "$DEVICE_UUID" "$APP_PATH"

echo "==> Launching app..."
xcrun simctl launch "$DEVICE_UUID" "$BUNDLE_ID"

echo ""
echo "✓ App launched! Bundle ID: $BUNDLE_ID"
echo "  Device: $DEVICE_UUID"
