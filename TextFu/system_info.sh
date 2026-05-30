#!/bin/bash

echo "Date: $(date '+%Y-%m-%d %H:%M:%S')"
echo "User: $(whoami)"
echo "Directory: $(pwd)"
echo "Files in your home folder: $(ls ~ | wc -l)"