#!/bin/bash
set -uo pipefail
#This script is used for setting up newly created servers.

LOG="/var/log/provision-$(date '+%Y-%m-%d_%H-%M').log"
SUCCESS=0
FAILED=0
SKIPPED=0

PACKAGES=("nginx" "curl" "git" "htop")
APP_USERS=("webdev1" "webdev2" "admin1")
APP_GROUPS=("webteam" "admins")

BASE_DIR="/opt/webproject"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S')" "$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S')" "$1" >> "$LOG"
}

check_root() {
   if [[ "$EUID" -ne 0 ]]; then
      log "Permission denied - must run as root"
     exit 1
   fi
}

install_packages() {
apt update
for package in "${PACKAGES[@]}"; do
  if dpkg -l "$package" &>/dev/null; then
    log "$package already installed"
    SKIPPED=$((SKIPPED+1))
  else
    if apt install -y "$package"; then
      log "$package installed successfully"
      SUCCESS=$((SUCCESS+1))
    else
      log "$package failed to install"
      FAILED=$((FAILED+1))
  fi
fi
done
}

create_groups() {
  for group in "${APP_GROUPS[@]}"; do
   if getent group "$group" &>/dev/null; then
    log "$group already exists"
    SKIPPED=$((SKIPPED+1))
   else
    if groupadd "$group"; then
      log "$group was successfully created"
      SUCCESS=$((SUCCESS+1))
    else
      log "$group failed to create"
      FAILED=$((FAILED+1))
  fi
fi
done
}

create_users() {
  for user in "${APP_USERS[@]}"; do
   if id "$user" &>/dev/null; then
    log "$user already exists"
    SKIPPED=$((SKIPPED+1))
  else
   if useradd -m -s /bin/bash "$user"; then
    log "$user was successfully created"
    SUCCESS=$((SUCCESS+1))
   else
    log "$user failed to create"
    FAILED=$((FAILED+1))
  fi
fi
done
}

setup_directories() {
  DIRS=("$BASE_DIR" "$BASE_DIR/public" "$BASE_DIR/private" "$BASE_DIR/uploads")
  OWNERS=("root:admins" "root:webteam" "root:admins" "root:webteam")
  PERMS=("750" "2755" "2770" "3775")

  for i in "${!DIRS[@]}"; do
   if [[ -d "${DIRS[$i]}" ]]; then
    log "${DIRS[$i]} already exists"
    SKIPPED=$((SKIPPED+1))
   else
     if mkdir "${DIRS[$i]}" && chown "${OWNERS[$i]}" "${DIRS[$i]}" && chmod "${PERMS[$i]}" "${DIRS[$i]}"; then
      log "${DIRS[$i]} created successfully"
      SUCCESS=$((SUCCESS+1))
    else
     log "${DIRS[$i]} failed to create"
     FAILED=$((FAILED+1))
    fi
  fi
done
}

print_summary() {
  log "Total successful actions - $SUCCESS"
  log "Total skipped actions - $SKIPPED"
  log "Total failed actions - $FAILED"
  
  if [ "$FAILED" -eq 0 ]; then
   log "SUCCESS"
  else
   log "COMPLETED WITH ERRORS"
  fi
}

# Main
log "=== Provisioning started ==="
check_root
install_packages
create_groups
create_users
setup_directories
print_summary
log "=== Provisioning complete ==="