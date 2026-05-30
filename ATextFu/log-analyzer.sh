#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: ./log-analyzer.sh <logfile>"
  exit 1
fi

LOGFILE=$1
TOTAL=$(wc -l < $LOGFILE)
INFO=$(grep -c "INFO" $LOGFILE)
WARNINGS=$(grep -c "WARNING" $LOGFILE)
ERRORS=$(grep -c "ERROR" $LOGFILE)
REPORT="log-report.txt"
> $REPORT

echo "Log Analysis Summary" >> $REPORT
echo "--------------------" >> $REPORT
echo "Total lines: $TOTAL" >> $REPORT
echo "INFO: $INFO" >> $REPORT
echo "WARNINGS: $WARNINGS" >> $REPORT
echo "ERRORS: $ERRORS" >> $REPORT

echo "--- ERROR DETAILS ---" >> $REPORT
grep "ERROR" $LOGFILE | awk '{print $3, $4, $5, $6, $7}' >> $REPORT

echo "Report saved to $REPORT"