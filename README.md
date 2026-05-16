# Bazzite NVIDIA Hyprland Image

This project defines a custom BlueBuild image based on the official Bazzite NVIDIA image:

```text
ghcr.io/ublue-os/bazzite-nvidia-open:stable
```

The goal is to keep the working NVIDIA stack from the official Bazzite image and add a minimal Hyprland session plus the core tools needed by the existing user configuration.

## Why KDE Stays

This first version does not remove Plasma, SDDM, KDE, or base Bazzite packages. KDE stays as the safety desktop while Hyprland is added on top. Cleanup can happen later after the NVIDIA + Hyprland image is proven to boot and the Hyprland session is stable.

## v1 Scope

v0 passed in GitHub Actions with Hyprland core using:

```text
lionheartp/Hyprland
```

The previous attempts with `solopasha/hyprland` failed on Fedora 44 because `aquamarine` required `libdisplay-info.so.2`, while Fedora 44 uses the newer `libdisplay-info` ABI. This v0 switches to `lionheartp/Hyprland`, which is being tested as a Fedora 44-compatible Hyprland COPR.

v1 passed in GitHub Actions and added basic session tools: Waybar, Kitty, screenshot tools, and Wayland clipboard support.

v2 passed in GitHub Actions and added `playerctl`, `pamixer`, and `gamemode`. `playerctl` supports music and media widgets, `pamixer` supports Waybar and future EWW volume controls, and `gamemode` is included for gaming priority.

v3 failed because `swww` does not exist in the currently enabled repositories.

v3.1 passed in GitHub Actions with `matugen` and `hyprlock` without `swww`. `matugen` will be used for dynamic colors from wallpaper, and `hyprlock` is installed for a later lock-screen configuration phase.

v4 adds `rofi` as a basic launcher and `Thunar` as a graphical file manager. `swww` remains pending and will be resolved later with another repository, a separate build path, or an alternative such as `hyprpaper`. The goal is still to recover a usable Hyprland session on top of the official NVIDIA base, not to recreate the full rice yet.

## What This Image Adds

Core session packages are listed in:

```text
packages/hyprland-core.txt
```

Deferred v2 extras are listed in:

```text
packages/hyprland-extras.txt
```

For v2, the current deferred list is:

```text
swaync
swappy
yazi
walker
eww
```

NVIDIA drivers are intentionally not installed by this project. They must continue to come from the official `bazzite-nvidia-open` base image.

## Build Plan

The recommended path is:

1. Push this project to GitHub.
2. Add BlueBuild/GitHub Actions workflow.
3. Build and publish the image to GHCR:

```text
ghcr.io/diegoduartemorales23/bazzite-nvidia-hyprland:latest
```

Local builds with Podman/Buildah can be used for testing, but the final rebase should target a published image.

## Build and Publish

BlueBuild's GitHub Action expects the recipe name relative to the `recipes/` or `config/` directory, so this project keeps the build recipe at:

```text
recipes/recipe.yml
```

To publish the image:

1. Create a GitHub repository for this project.
2. Push this project to that repository on the `main` branch.
3. Enable GitHub Actions if GitHub asks for confirmation.
4. Add the signing secret expected by BlueBuild as `SIGNING_SECRET`.
5. Run the `build` workflow manually, or push to `main`.
6. Wait for GHCR to publish:

```text
ghcr.io/diegoduartemorales23/bazzite-nvidia-hyprland:latest
```

NO ejecutar todavía:

```bash
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/diegoduartemorales23/bazzite-nvidia-hyprland:latest
```

The rebase requires a reboot before the new deployment is active.

## Signing Setup

The workflow in `.github/workflows/build.yml` requires a GitHub Actions secret named:

```text
SIGNING_SECRET
```

That secret should contain the full private cosign key. Do not commit the private key to this repository, do not upload it as a normal file, and do not store it inside this project directory.

Suggested private location for the key material:

```text
~/.local/share/cosign/bazzite-nvidia-hyprland/
```

Suggested commands, not executed by this project:

```bash
mkdir -p ~/.local/share/cosign/bazzite-nvidia-hyprland
cd ~/.local/share/cosign/bazzite-nvidia-hyprland
cosign generate-key-pair
```

That creates:

```text
cosign.key
cosign.pub
```

In GitHub, open:

```text
Repo -> Settings -> Secrets and variables -> Actions -> New repository secret
```

Create:

```text
Name: SIGNING_SECRET
Value: full contents of cosign.key
```

If `cosign.key` is protected with a password, the signing flow may also need a password secret. Keep the workflow as-is for the first attempt and start by configuring `SIGNING_SECRET`.

## Unsigned Testing Option

Signed images are preferred. If you decide to test without signature verification, the rebase would need to use an unverified reference instead:

```bash
rpm-ostree rebase ostree-unverified-registry:ghcr.io/diegoduartemorales23/bazzite-nvidia-hyprland:latest
```

This is less recommended because it skips image signature verification. Use the signed `ostree-image-signed:docker://...` path once signing is configured.

## Rebase Command

NO ejecutar todavía:

```bash
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/diegoduartemorales23/bazzite-nvidia-hyprland:latest
```

The rebase creates a new deployment and requires a reboot.

## Rollback

If the new deployment fails or Hyprland is not usable, boot the previous deployment or run:

```bash
rpm-ostree rollback
```

That also requires a reboot to enter the rolled-back deployment.

## Verification

Before rebase, use:

```bash
scripts/verify-host.sh
```

After rebasing to the custom image, use:

```bash
scripts/verify-image.sh
```

Both scripts are diagnostic only and do not modify the system.

## First Boot Checks

After rebasing and rebooting into the custom image, run:

```bash
scripts/verify-image.sh
```

This checks the active image, NVIDIA, Hyprland commands, related tools, and whether the Hyprland session is present in `/usr/share/wayland-sessions`.
