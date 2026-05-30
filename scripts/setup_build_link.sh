#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="/private/tmp/bkg_001_ma-gradle-build"

mkdir -p "$TARGET_DIR"
rm -rf "$ROOT_DIR/build"
ln -s "$TARGET_DIR" "$ROOT_DIR/build"

echo "Created symlink: $ROOT_DIR/build -> $TARGET_DIR"

