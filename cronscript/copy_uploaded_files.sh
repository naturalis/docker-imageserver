#!/bin/bash

INCOMING=/data/incoming/images
IMAGE_ROOT=/data/www
TARGET=/data/www/original
NOW=$( date +"%Y-%m-%d %H:%M:%S" )

MINUTES=$(date "+%M")
MINUTES_MOD_FIFTEEN=$(($MINUTES % 15))

# run every 15 minutes
if [ ! "$MINUTES_MOD_FIFTEEN" -eq  0 ]; then
  exit
fi

# if empty incoming directory, silent exit
if [ ! "$(ls -A $INCOMING)" ]; then
  exit
fi

echo "start $NOW"

# remnant from sFTP-times, maybe replace at some point with an "upload ready"-flag type solution
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


# if empty incoming directory after clean up, exit
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

