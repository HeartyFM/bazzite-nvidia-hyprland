#!/usr/bin/env bash
set -u

section() {
  printf '\n=== %s ===\n' "$1"
}

check_cmd() {
  local cmd="$1"
  if command -v "$cmd" >/dev/null 2>&1; then
    printf 'OK  %s -> %s\n' "$cmd" "$(command -v "$cmd")"
  else
    printf 'NO  %s\n' "$cmd"
  fi
}

section "ACTIVE IMAGE"
rpm-ostree status || true

section "NVIDIA"
nvidia-smi || true

section "HYPRLAND STACK"
check_cmd Hyprland
check_cmd hyprctl
check_cmd waybar
check_cmd swww
check_cmd matugen
check_cmd gamemoderun
check_cmd gamemoded

section "WAYLAND SESSIONS"
ls -la /usr/share/wayland-sessions 2>/dev/null || true
grep -Rni 'Hyprland\|hyprland' /usr/share/wayland-sessions 2>/dev/null || true
