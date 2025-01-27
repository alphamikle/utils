#!/bin/bash

HOOK_DIR=".git/hooks"
HOOK_FILE="$HOOK_DIR/pre-commit"

if [ -d "$HOOK_DIR" ]; then
  cp "$0" "$HOOK_FILE"
  chmod +x "$HOOK_FILE"
  echo "Pre-commit hook updated."
else
  echo "Hook directory not found. Make sure you're in the root of a Git repository."
fi

echo "Running dart format..."
dart format . -l

echo "Installing pana..."
dart pub global activate pana

echo "Running pana..."
pana --exit-code-threshold 0

if [ $? -ne 0 ]; then
  echo "Pana analysis failed. Commit aborted."
  exit 1
fi

echo "All checks passed."
