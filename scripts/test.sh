#!/bin/bash
set -eu

echo "Starting Portfolio Website Tests..."

# Check required files
for file in index.html css/style.css js/script.js; do
    if [ -f "$file" ]; then
        echo "PASS: $file exists"
    else
        echo "FAIL: $file is missing"
        exit 1
    fi
done

# Check HTML title
if grep -qi '<title>Hasnain Abbas | DevOps Engineer</title>' index.html; then
    echo "PASS: Website title found"
else
    echo "FAIL: Website title not found"
    exit 1
fi

# Check CSS connection
if grep -q 'css/style.css' index.html; then
    echo "PASS: CSS linked"
else
    echo "FAIL: CSS link missing"
    exit 1
fi

# Check JavaScript connection
if grep -q 'js/script.js' index.html; then
    echo "PASS: JavaScript linked"
else
    echo "FAIL: JavaScript link missing"
    exit 1
fi

echo "All tests passed successfully!"
