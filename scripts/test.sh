#!/bin/bash
set -eu

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_DIR="$ROOT_DIR/app"

echo "=================================="
echo " DevOps LaunchPad - Website Tests"
echo "=================================="

echo ""
echo "Running automated tests..."

# Check required files
for file in \
    "$APP_DIR/index.html" \
    "$APP_DIR/css/style.css" \
    "$APP_DIR/js/script.js"
do
    if [ -f "$file" ]; then
        echo "PASS: ${file#"$ROOT_DIR"/} exists"
    else
        echo "FAIL: ${file#"$ROOT_DIR"/} is missing"
        exit 1
    fi
done

# Check HTML title
if grep -qi '<title>Hasnain Abbas | DevOps Engineer</title>' "$APP_DIR/index.html"; then
    echo "PASS: Website title found"
else
    echo "FAIL: Website title not found"
    exit 1
fi

# Check CSS connection
if grep -q 'css/style.css' "$APP_DIR/index.html"; then
    echo "PASS: CSS linked"
else
    echo "FAIL: CSS link missing"
    exit 1
fi

# Check JavaScript connection
if grep -q 'js/script.js' "$APP_DIR/index.html"; then
    echo "PASS: JavaScript linked"
else
    echo "FAIL: JavaScript link missing"
    exit 1
fi

echo ""
echo "=================================="
echo " ALL TESTS PASSED SUCCESSFULLY!"
echo "=================================="
