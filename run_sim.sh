#!/bin/bash
set -e

echo "Building QDate for iOS Simulator..."
xcodebuild -scheme QDate \
           -sdk iphonesimulator \
           -configuration Debug \
           -destination 'generic/platform=iOS Simulator' \
           CONFIGURATION_BUILD_DIR="./build" \
           build > /dev/null

echo "Installing to booted iOS Simulator..."
xcrun simctl install booted "./build/QDate.app"

echo "Launching com.qdate.app..."
xcrun simctl launch booted com.qdate.app

echo "Successfully started on simulator!"
