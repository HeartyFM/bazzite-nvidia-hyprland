# Checkpoint: Bazzite NVIDIA + Hyprland Working

Date: 2026-05-16

## Image And Repo

Active image:

```text
ghcr.io/heartyfm/bazzite-nvidia-hyprland:latest
```

Repository:

```text
https://github.com/HeartyFM/bazzite-nvidia-hyprland
```

Local project:

```text
~/Projects/bazzite-nvidia-hyprland-image
```

## Final Working State

The custom image based on the official Bazzite NVIDIA image is working. The system can boot the custom Hyprland image while preserving the official KDE NVIDIA image as fallback.

Known boot entries:

```text
Bazzite 0 -> custom Bazzite NVIDIA + Hyprland image
Bazzite 1 -> official Bazzite NVIDIA KDE fallback
```

The active deployment was confirmed as:

```text
ostree-image-signed:docker://ghcr.io/heartyfm/bazzite-nvidia-hyprland:latest
```

KDE/Plasma remains available as a fallback.

## NVIDIA State

NVIDIA works on the custom image.

Confirmed:

```text
nvidia-smi works
Driver Version: 595.71.05
CUDA Version: 13.2
/dev/nvidia* exists
```

Loaded NVIDIA modules:

```text
nvidia
nvidia_drm
nvidia_modeset
nvidia_uvm
```

## Hyprland State

Hyprland starts successfully.

Session used:

```text
hyprland-uwsm.desktop
```

Detected displays:

```text
Internal: eDP-1, 2400x1600@120Hz, scale 1.60
External: DP-3, 1920x1080@60Hz, scale 1.00
```

Working tools:

```text
Hyprland
hyprctl
waybar
kitty
matugen
hyprlock
rofi
Thunar
gamemoderun
gamemoded
```

## Packages Included

Current image package set added for Hyprland:

```text
hyprland
xdg-desktop-portal-hyprland
waybar
kitty
grim
slurp
wl-clipboard
playerctl
pamixer
gamemode
matugen
hyprlock
rofi
Thunar
```

## COPR

Current COPR:

```text
https://copr.fedorainfracloud.org/coprs/lionheartp/Hyprland/repo/fedora-%OS_VERSION%/lionheartp-Hyprland-fedora-%OS_VERSION%.repo
```

The earlier `solopasha/hyprland` COPR did not work on Fedora 44 because the build failed with:

```text
nothing provides libdisplay-info.so.2()(64bit)
needed by aquamarine-0.9.5-2.fc44.x86_64
```

Fedora 44 uses the newer `libdisplay-info` ABI, so the image was switched to `lionheartp/Hyprland`.

## Build Progression

```text
v0 passed: hyprland + xdg-desktop-portal-hyprland
v1 passed: + waybar, kitty, grim, slurp, wl-clipboard
v2 passed: + playerctl, pamixer, gamemode
v3 failed: + swww failed because package was not found
v3.1 passed: + matugen, hyprlock, without swww
v4 passed: + rofi, Thunar
```

## swww State

`swww` is not installed.

It was removed because the build failed with:

```text
Packages not found: swww
```

Temporary Hyprland config changes disabled `swww` startup and wallpaper dynamic setup.

Future options:

```text
1. Use hyprpaper as a simple replacement.
2. Find a Fedora 44-compatible repository for swww.
3. Build swww inside the image.
```

## Hyprland Config Fixes

Config file:

```text
~/.config/hypr/hyprland.conf
```

Temporarily commented because `swww` is not installed:

```ini
# exec-once = swww-daemon
# exec-once = bash -c 'sleep 1 && WP=$(cat ~/.cache/current-wallpaper 2>/dev/null || echo ~/Pictures/Wallpapers/1406850.png) && wallpaper-set.sh "$WP"'
```

Commented because the fields were invalid for the current Hyprland version:

```ini
# layerrule = blur, waybar
# layerrule = ignorezero, waybar
# pseudotile     = true
```

Window rules were migrated.

Old rules:

```ini
windowrulev2 = float, class:.*
windowrulev2 = center, class:.*
windowrulev2 = suppressevent maximize, class:.*
windowrulev2 = nofocus, class:^$, title:^$, xwayland:1, floating:1, fullscreen:0, pinned:0
```

Current rules:

```ini
windowrule = float on, match:class .*
windowrule = center on, match:class .*
windowrule = suppress_event maximize, match:class .*
windowrule = no_focus on, match:class ^$, match:title ^$, match:xwayland on, match:float on
```

After reload:

```text
hyprctl reload
hyprctl configerrors
ok
```

## Backups

General backup before NVIDIA rebase:

```text
~/Backups/bazzite-hyprland-before-nvidia-rebase/configs-20260516-124836.tar.gz
```

Hyprland config backup before compatibility fixes:

```text
~/.config/hypr/hyprland.conf.broken-pre-fix-20260516-160854
```

Hyprland config backup before window rule migration:

```text
~/.config/hypr/hyprland.conf.windowrules-pre-fix-20260516-161140
```

## Current Issues

Non-critical pending work:

```text
1. swww is not installed.
2. Dynamic wallpaper is temporarily disabled.
3. EWW widgets are pending.
4. SwayNC is pending.
5. Walker is pending.
6. Swappy is pending.
7. Yazi is pending.
8. Hyprlock is installed but not visually configured.
9. GameMode works, but gamemoded -t fails the CPU governor check.
10. rEFInd shows two Bazzite entries; keep both for now.
```

GameMode known issue:

```text
ERROR: Governor was not set to performance (was actually powersave)!
```

Diagnostics showed:

```text
scaling_driver: intel_pstate
current governor: powersave
available governors: performance powersave
tuned.service: active
power-profiles-daemon: not installed/running
```

Do not change the permanent power configuration until the wallpaper path is settled.

## Next Recommended Phase

Do not start EWW yet.

Next step should be wallpaper:

```text
A. Test hyprpaper as a simple replacement for swww.
B. Investigate a clean Fedora 44/BlueBuild path for swww.
```

After wallpaper is stable, continue with notification/widgets in small batches.
