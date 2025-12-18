#!/usr/bin/env bash

# Secura - MVP
# Read-only Linux infrastructure audit tool
# Target: SMEs / MSPs

set -euo pipefail

VERSION="0.1.0"

# --------- Helpers ---------
info()  { echo -e "[INFO] $1"; }
ok()    { echo -e "[OK]   $1"; }
warn()  { echo -e "[WARN] $1"; }
error() { echo -e "[ERR]  $1"; exit 1; }

require_root() {
  if [[ "$EUID" -ne 0 ]]; then
    error "This script must be run as root (read-only checks still require access)."
  fi
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# --------- Checks ---------
check_os() {
  if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    info "OS: $NAME $VERSION_ID"
  else
    warn "Unable to detect OS"
  fi
}

check_uptime() {
  local up
  up=$(uptime -p 2>/dev/null || true)
  info "Uptime: ${up:-unknown}"
}

check_ssh() {
  if [[ -f /etc/ssh/sshd_config ]]; then
    local root_login port
    root_login=$(grep -Ei '^PermitRootLogin' /etc/ssh/sshd_config 2>/dev/null | awk '{print $2}' | tail -n1 || true)
    port=$(grep -Ei '^Port' /etc/ssh/sshd_config 2>/dev/null | awk '{print $2}' | tail -n1 || true)

    [[ -z "$port" ]] && port=22

    if [[ "$root_login" == "yes" ]]; then
      warn "SSH root login enabled"
    else
      ok "SSH root login disabled"
    fi

    info "SSH port: $port"
  else
    warn "SSH configuration not found"
  fi
}

check_sudo_users() {
  local count
  count=$(getent group sudo 2>/dev/null | awk -F: '{print $4}' | tr ',' '\n' | grep -c . || true)

  if [[ "$count" -gt 2 ]]; then
    warn "$count sudo users detected"
  else
    ok "$count sudo users detected"
  fi
}

check_firewall() {
  if command_exists ufw; then
    if ufw status | grep -q "Status: active"; then
      ok "Firewall active (ufw)"
    else
      warn "Firewall installed but inactive (ufw)"
    fi
  elif command_exists firewall-cmd; then
    ok "Firewall detected (firewalld)"
  else
    warn "No firewall detected"
  fi
}

check_open_ports() {
  if command_exists ss; then
    local ports
    ports=$(ss -tuln | awk 'NR>1 {print $5}' | sed 's/.*://' | sort -n | uniq | wc -l)
    info "Open listening ports: $ports"
  else
    warn "Cannot check open ports (ss not available)"
  fi
}

check_updates() {
  if command_exists apt; then
    local updates
    updates=$(apt list --upgradable 2>/dev/null | grep -vc Listing || true)
    if [[ "$updates" -gt 0 ]]; then
      warn "$updates packages can be updated"
    else
      ok "System up to date"
    fi
  fi
}

# --------- Report ---------
report_markdown() {
  local file="secureinfra-report.md"
  {
    echo "# SecureInfra Report"
    echo
    date
    echo
    uname -a
  } > "$file"

  info "Report generated: $file"
}

# --------- Main ---------
usage() {
  echo "SecureInfra v$VERSION"
  echo
  echo "Usage: $0 scan | report"
}

main() {
  require_root

  case "${1:-}" in
    scan)
      check_os
      check_uptime
      check_ssh
      check_sudo_users
      check_firewall
      check_open_ports
      check_updates
      ;;
    report)
      report_markdown
      ;;
    *)
      usage
      ;;
  esac
}

main "$@"
