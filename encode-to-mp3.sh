#!/bin/bash

# This script takes FLAC files from the directory passed as first argument,
# encode them to mp3 (with ID3 tags) and copy the result to the directory passed as second argument,
# within a subdirectory with the same name as the source directory.
# The files are encoded one by one in alphabetical order, in order to ensure
# that the i-node table order is consistent with the alphabetical order (some mp3 players read files
# in the i-node table order, not the alphabetical order).
# To avoid any problem, parameters should be each surounded by quotes.

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

  ARTIST=`metaflac "$a" --show-tag=ARTIST | sed s/.*=//g`
  TITLE=`metaflac "$a" --show-tag=TITLE | sed s/.*=//g`
  ALBUM=`metaflac "$a" --show-tag=ALBUM | sed s/.*=//g`
  GENRE=`metaflac "$a" --show-tag=GENRE | sed s/.*=//g`
  TRACKNUMBER=`metaflac "$a" --show-tag=TRACKNUMBER | sed s/.*=//g`
  DISCNUMBER=`metaflac "$a" --show-tag=DISCNUMBER | sed s/.*=//g`
  DATE=`metaflac "$a" --show-tag=DATE | sed s/.*=//g`
  REPLAYGAIN_TRACK_GAIN=`metaflac "$a" --show-tag=REPLAYGAIN_TRACK_GAIN | sed s/.*=//g`
  REPLAYGAIN_TRACK_PEAK=`metaflac "$a" --show-tag=REPLAYGAIN_TRACK_PEAK | sed s/.*=//g`
  REPLAYGAIN_ALBUM_GAIN=`metaflac "$a" --show-tag=REPLAYGAIN_ALBUM_GAIN | sed s/.*=//g`
  REPLAYGAIN_ALBUM_PEAK=`metaflac "$a" --show-tag=REPLAYGAIN_ALBUM_PEAK | sed s/.*=//g`
  
  echo "Encoding $OUTF..."

  flac -c -d "$a" | lame -q5 -V4 - "$DEST_FULLNAME/$SRC_BASENAME/$OUTF"
  eyeD3 --encoding=utf8 --title="$TITLE" --track="${TRACKNUMBER:-0}" --text-frame="TPOS:${DISCNUMBER:-1}" --artist="$ARTIST" --album="$ALBUM" --release-year="$DATE" --genre="${GENRE:-12}" --user-text-frame="REPLAYGAIN_TRACK_GAIN:$REPLAYGAIN_TRACK_GAIN" --user-text-frame="REPLAYGAIN_TRACK_PEAK:$REPLAYGAIN_TRACK_PEAK" --user-text-frame="REPLAYGAIN_ALBUM_GAIN:$REPLAYGAIN_ALBUM_GAIN" --user-text-frame="REPLAYGAIN_ALBUM_PEAK:$REPLAYGAIN_ALBUM_PEAK" "$DEST_FULLNAME/$SRC_BASENAME/$OUTF"
done 

cd "$OLD_CURRENT_DIR"
exit
