#!/bin/bash
set -uo pipefail
#The audit script verifies that a server was provisioned correctly.
#It checks everything provision.sh creates and reports PASS or FAIL for each item.

LOG="/var/log/audit-$(date '+%Y-%m-%d_%H-%M').log"
SUCCESS=0
FAILED=0

PACKAGES=("nginx" "curl" "git" "htop")
APP_USERS=("webdev1" "webdev2" "admin1")
APP_GROUPS=("webteam" "admins")

BASE_DIR="/opt/webproject"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S')" "$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S')" "$1" >> "$LOG"
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
     log "PERMISSION DENIED - must run as root"
     exit 1
    fi
}

package_check() {
    for package in "${PACKAGES[@]}"; do
     if dpkg -l "$package" &>/dev/null; then
      log "$package is installed"
      SUCCESS=$((SUCCESS+1))
    else
      log "$package is NOT installed"
      FAILED=$((FAILED+1))
    fi
done
}

app_groups_check() {
    for group in "${APP_GROUPS[@]}"; do
     if getent group "$group" &>/dev/null; then
      log "$group exists"
      SUCCESS=$((SUCCESS+1))
    else
      log "$group doesn't exist"
      FAILED=$((FAILED+1))
    fi
done
}

app_users_check() {
    for user in "${APP_USERS[@]}"; do
     if id "$user" &>/dev/null; then
      log "$user exists"
      SUCCESS=$((SUCCESS+1))
    else
      log "$user doesn't exist"
      FAILED=$((FAILED+1))
    fi
done
}

dir_check() {
  DIRS=("$BASE_DIR" "$BASE_DIR/public" "$BASE_DIR/private" "$BASE_DIR/uploads")
  OWNERS=("root:admins" "root:webteam" "root:admins" "root:webteam")
  PERMS=("750" "2755" "2770" "3775")

  for i in "${!DIRS[@]}"; do
   if [[ -d "${DIRS[$i]}" ]]; then
    ACTUAL_PERM=$(stat -c "%a" "${DIRS[$i]}")
    log "${DIRS[$i]} exists"
    SUCCESS=$((SUCCESS+1))
   if [[ "$ACTUAL_PERM" == "${PERMS[$i]}" ]]; then
    log "${DIRS[$i]} has correct permissions"
    SUCCESS=$((SUCCESS+1))
   else
    log "${DIRS[$i]} has wrong permissions"
    FAILED=$((FAILED+1))
   fi
else
   log "${DIRS[$i]} doesn't exist"
   FAILED=$((FAILED+1))
fi
done  
}

print_summary() {
    log "Total successful actions - $SUCCESS"
    log "Total failed actions - $FAILED"

    if [[ "$FAILED" -eq 0 ]]; then
     log "ALL CHECKS PASSED"
    else
     log "$FAILED CHECKS FAILED"
    fi
}

# Main
log "=== Audit results ==="
check_root
package_check
app_groups_check
app_users_check
dir_check
print_summary
log "=== Audit finished ==="