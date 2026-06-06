#!/bin/bash
set -e

BOOTED_DEVICE_ID="$(xcrun simctl list devices booted | sed -nE 's/.*\(([A-F0-9-]{36})\) \(Booted\).*/\1/p' | head -n 1)"
DERIVED_DATA_PATH="./build/DerivedData"
APP_PATH="$DERIVED_DATA_PATH/Build/Products/Debug-iphonesimulator/QDate.app"

if [ -z "$BOOTED_DEVICE_ID" ]; then
  echo "No booted iOS Simulator found. Start one in Xcode or Simulator first."
  exit 1
fi

echo "Building QDate for the booted iOS Simulator..."
xcodebuild -project QDate.xcodeproj \
           -scheme QDate \
           -configuration Debug \
           -destination "platform=iOS Simulator,id=$BOOTED_DEVICE_ID" \
           -derivedDataPath "$DERIVED_DATA_PATH" \
           build

echo "Installing to booted iOS Simulator..."
xcrun simctl install booted "$APP_PATH"

echo "Launching com.qdate.app..."
xcrun simctl launch booted com.qdate.app

echo "Successfully started on simulator!"
