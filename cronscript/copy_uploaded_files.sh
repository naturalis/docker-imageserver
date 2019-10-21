#!/bin/bash

INCOMING=/home/imageupload/incoming
IMAGE_ROOT=/data/www
TARGET=/data/www/original
NOW=$( date +"%Y-%m-%d %H:%M:%S" )

# secondary incoming directory is fed by minio file browser
SECONDARY_INCOMING=/data/incoming/images
MINUTES=$(date "+%M")
MINUTES_LAST_DIGIT="${MINUTES:1:1}"

if [ "$MINUTES_LAST_DIGIT" == "7" ]; then
  # non-empty secondary incoming directory, move files to primary
  if [ "$(ls -A $SECONDARY_INCOMING)" ]; then
    mv $SECONDARY_INCOMING/* $INCOMING/
  fi
fi


# empty incoming directory, silent exit
if [ ! "$(ls -A $INCOMING)" ]; then
  exit
fi

echo "start $NOW"

if [[ -n $(find $INCOMING/ -name "*.filepart") ]]; then
  echo "found '.filepart' in $INCOMING, file transfer in progress; exiting."
  exit
fi


echo "cleaning up before moving"
find $INCOMING/ -type f | while read f; do
  if [[ -f $f ]]; then
    # file
    if [[ ! ${f,,} == *.jpg && ! ${f,,} == *.png ]]; then
      echo "deleting file of unsupported type $f"
      rm $f
    else
      echo "found $f"
    fi
    elif [ ! -d $f ]; then
      # something else, not dir
      echo "deleting non-file $f"
      rm $f
    fi
done


if [ ! "$(ls -A $INCOMING)" ]; then
  echo "no files to move; exiting"
  exit
fi


echo "looking for existing resized copies of new files"
for f in $INCOMING/* $INCOMING/**/* ; do
  if [[ -f $f ]]; then
    filename=$(basename "$f")
    IFS=$'\n';
    for g in $(find $IMAGE_ROOT/ -name $filename);
    do
      echo "found $g"
      if  [[ ! $g == *original/* ]] ;
      then
        echo "deleting old resized copy $g"
        rm $g;
      else
        echo "ignoring original"
      fi
    done
  fi
done;


echo "moving files to $TARGET"
cp -r $INCOMING/* $TARGET/
rm -R $INCOMING/*

echo "done"

