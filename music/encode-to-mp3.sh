#!/bin/bash

# This script takes FLAC files from the directory passed as first argument,
# encode them to mp3 (with ID3 tags) and copy the result to the directory passed as second argument,
# within a subdirectory with the same name as the source directory.
# The files are encoded one by one in alphabetical order, in order to ensure
# that the i-node table order is consistent with the alphabetical order (some mp3 players read files
# in the i-node table order, not the alphabetical order).
# To avoid any problem, parameters should be each surrounded by quotes.

E_WRONG_ARGS=85
NBRPARAMS=2
if [ $# -ne "$NBRPARAMS" ]
then
  echo "Usage: `basename "$0"` source-dir dest-dir"
  exit $E_WRONG_ARGS
fi

OLD_CURRENT_DIR="$PWD"

SRC_BASENAME="`basename "$1" | tr '?' '_' | tr '\"' '_'`"
cd "$2"
DEST_FULLNAME="$PWD"
mkdir "$SRC_BASENAME"
echo "Directory $DEST_FULLNAME/$SRC_BASENAME created."
cd "$OLD_CURRENT_DIR"
cd "$1"

for a in *.flac
do
  OUTF=`echo "$a" | sed s/\.flac$/.mp3/g | tr '?' '_'`
  
  echo "Encoding $OUTF..."
  
  ffmpeg -i "$a" -c:v copy -c:a libmp3lame -q:a 0 "$DEST_FULLNAME/$SRC_BASENAME/$OUTF"

done 

cd "$OLD_CURRENT_DIR"
exit
