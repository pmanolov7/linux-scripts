#!/bin/bash

SNAPSHOTS_DIR="snapshots"
mkdir -p $SNAPSHOTS_DIR
LOG="$SNAPSHOTS_DIR/health-$(date '+%Y-%m-%d_%H-%M').txt"
{
echo "-------------$(date '+%Y-%m-%d %H:%M')-------------"
ps aux --sort=-%cpu | head -n 5
echo "---------------------------------------------------"
ps aux --sort=-%mem | head -n 5
echo "---------------------------------------------------"
echo "Current load average: $(cat /proc/loadavg)"
} >> $LOG && echo "Snapshot saved to [$LOG]" || echo "Something went wrong"