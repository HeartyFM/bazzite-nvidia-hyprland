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

section "RPM-OSTREE"
rpm-ostree status || true

section "NVIDIA"
nvidia-smi || true

section "KERNEL MODULES"
lsmod | grep -Ei 'nvidia|nouveau' || true

section "NVIDIA DEVICES"
ls -la /dev/nvidia* 2>/dev/null || true

section "HOST COMMANDS"
check_cmd Hyprland
check_cmd hyprctl
check_cmd waybar
check_cmd gamemoderun
check_cmd gamemoded
