# Health Snapshot

Creates timestamped snapshots of system health — top 5 processes by CPU, top 5 by memory, and current load average.

## Usage

./health-snapshot.sh

## Output

Files are saved to the `snapshots/` directory with a timestamped filename.

Each file contains the date and time of the snapshot, top 5 CPU processes, top 5 memory processes, and current load average.
