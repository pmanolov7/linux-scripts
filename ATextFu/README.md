# Linux Scripts
Bash scripts built during Phase 1 of my DevOps learning path.

## Log Analyzer (log-analyzer.sh)
Takes a log file as argument, counts how many INFO, WARNING and ERROR 
lines it contains, extracts the error messages, and saves the result 
to log-report.txt.

### Usage
./log-analyzer.sh server.log

### What I learned
- How to use sed to find and replace text
- How to use awk to extract specific columns from text
- How to pipe grep into awk to filter and process lines
