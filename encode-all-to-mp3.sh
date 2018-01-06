#!/bin/bash
OLD_CURRENT_DIR="$PWD"

cd "$2"
TARGET_DIR="$PWD"
cd "$OLD_CURRENT_DIR"
cd "$1"
SOURCE_DIR="$PWD"

for f in ./*/
do
    echo "Encoding $f..."
    sh ./encode-to-mp3.sh "$f" "$TARGET_DIR"
done

cd "$OLD_CURRENT_DIR"
exit
