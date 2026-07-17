# Phase 1 Capstone — Server Provisioning & Audit

A set of Bash scripts to provision, verify, and tear down a fresh Ubuntu server environment.
Built as the Phase 1 capstone project of a self-taught DevOps learning roadmap.

## Scripts

**provision.sh** — Provisions a fresh Ubuntu server. Installs required packages, creates users
and groups, and sets up a directory structure with correct ownership and permissions.
Checks for existing resources before creating them (idempotent — safe to run multiple times).
Logs all actions with timestamps to `/var/log/provision-<date>.log` and prints a summary on completion.

**audit.sh** — Verifies the server matches the expected provisioned state.
Checks every package, user, group, and directory that provision.sh creates and reports PASS or FAIL for each.
Useful for confirming a fresh provisioning worked correctly, or for detecting drift on an existing server.
Logs results to `/var/log/audit-<date>.log`.

**teardown.sh** — Removes everything provision.sh created: users, groups, and directories.
Does not remove installed packages or log files.

## Usage

```bash
# Provision the server
sudo ./provision.sh

# Verify the provisioning is correct
sudo ./audit.sh

# Remove everything provision.sh created
sudo ./teardown.sh
```

## What Gets Created

- **Packages:** nginx, curl, git, htop
- **Groups:** webteam, admins
- **Users:** webdev1, webdev2, admin1
- **Directories:**
  - `/opt/webproject` — 750, owned by root:admins
  - `/opt/webproject/public` — 2755, owned by root:webteam
  - `/opt/webproject/private` — 2770, owned by root:admins
  - `/opt/webproject/uploads` — 3775, owned by root:webteam