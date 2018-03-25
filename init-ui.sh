#!/bin/sh

command -v npm -q >/dev/null 2>&1 || { echo >&2 "npm is required but not installed yet... aborting."; exit 1; }

# Install the UI
echo "  - installing the UI..."
echo
pushd ./support/application-ui/
npm install
popd






