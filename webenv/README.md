# Dev Environment Setup

1. This is a script for setting up test environment.
2. It creates users, groups, directories also assigns permissions.
3. Run webenv.sh for testing and run teardown.sh when testing is finished.
4. This script does not check for existing users or groups before creation. Running webenv.sh twice will produce errors and is unsafe to do. Please run teardown.sh before running webenv.sh again. A future version will handle this gracefully.
