#!/bin/bash

# Exit on any error
# set -e

# Change to the directory where the script is located
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
cd "$SCRIPT_DIR"

# create a temporary working directory
# mkdir libfprint-CS9711-build
cd libfprint-CS9711-build

# uninstall current fprintd and libfprint (if installed)
sudo pacman -Rns fprintd

# get original PKGBUILD
# curl -O https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=libfprint-git

# patch
# curl -O https://gitlab.freedesktop.org/-/project/124/uploads/843f52378da235f8f285eef1dc171061/PKGBUILD.patch
patch PKGBUILD PKGBUILD.patch

# build and install as libfprint-CS9711-git
makepkg -si  --needed --asdeps

# reinstall fprintd
sudo pacman -S fprintd

