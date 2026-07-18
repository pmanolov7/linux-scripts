#!/bin/bash

LOG="$1/organizer.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
echo "Folder received: $1"
echo "$TIMESTAMP - Folder received: $1" >> $LOG
echo "Files found:"
echo "$TIMESTAMP - Files found: $(ls $1 | wc -l)" >> $LOG
ls $1
echo "Total files: $(ls $1 | wc -l)"
echo "$TIMESTAMP - Total files: $(ls $1 | wc -l)" >> $LOG
mkdir -p $1/text
echo "$TIMESTAMP - Created text/ folder" >> $LOG
mv $1/*.txt $1/text/
echo "$TIMESTAMP - Moved .txt files to text/" >> $LOG
