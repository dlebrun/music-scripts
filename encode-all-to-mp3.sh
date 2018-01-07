#!/bin/bash

# This script recursively takes all the FLAC files from the directory passed as first argument,
# encode them to mp3 (with ID3 tags) and copy the result to the directory passed as second argument.
# It assumes the content of the source directory has the following structure: ./ARTIST/ALBUM/SONG,
# and creates a similar structure in the target directory.

E_WRONG_ARGS=85
NBRPARAMS=2
if [ $# -ne "$NBRPARAMS" ]
then
  echo "Usage: `basename "$0"` source-dir dest-dir"
  exit $E_WRONG_ARGS
fi

OLD_CURRENT_DIR="$PWD"
SCRIPT_DIR=`dirname "$0"`

cd "$2"
TARGET_DIR="$PWD"
cd "$OLD_CURRENT_DIR"
cd "$1"
SOURCE_DIR="$PWD"

for a0 in "$SOURCE_DIR"/*
do
  if [ -d "$a0" ]
  then
    ARTIST=`basename "$a0"`
    echo "Encoding artist $ARTIST..."
    mkdir -p "$TARGET_DIR/$ARTIST"
    for a1 in "$a0"/*
    do
      echo "Encoding album $a1..."
      sh "$OLD_CURRENT_DIR/$SCRIPT_DIR"/encode-to-mp3.sh "$a1" "$TARGET_DIR/$ARTIST"
    done
  fi    
done

cd "$OLD_CURRENT_DIR"
exit
