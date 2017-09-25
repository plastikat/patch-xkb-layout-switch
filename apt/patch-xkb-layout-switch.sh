#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# This tiny script tries to do all the chores to patch the X.Org
# Server source code to allow keyboard layout switch on keys release
# (instead of keys press). It is for apt-based distributions
# (Debian/Ubuntu). It relies on patches provided by the community. It
# downloads package source code, applies the patch, builds deb
# package files, installs and "freezes" one of them.
# 
# Bug https://bugs.launchpad.net/ubuntu/+source/xorg-server/+bug/1683383
# Original gist https://gist.github.com/elw00d/0826917118d58e81843e2d11bc6cf885
# Original article https://habrahabr.ru/post/87408/
# Thanks to Artem Kovalov, Igor Kostromin
# Reworked by Plastikat
# 
# Usage instructions:
# 
# This script uses a set of configuration files to be version agnostic.
# Put the script and its configuration files to a directory of your choice
# and simply run it.
# 
# Configuration files are similar, but differ by platform-specific values.
# If the script fails to find the appropriate file it will tell you the
# name. Using this name you may copy one of the existing configuration
# files and try to adapt it to your platform (read comments inside the
# file). If this works out - feel free to extend our collection with your
# file.
# 
# The script also watches for errors and stops should any occur. If this
# happens, try to figure what caused the error and eliminate that cause.
# Deleting the build directory is sometimes a good idea too. Then just run
# the script again. Feel free to report script errors.
# ------------------------------------------------------------------------------

set -eu

# Configuration
dist_desc=`lsb_release --short --description | sed 's/\s/_/g'`
dist_arch=`uname -m`
config_path="${dist_desc}-${dist_arch}.conf"
stat "$config_path" >/dev/null || exit 1

source "$config_path"
patch_file="xkb.patch"

[ -e "$build_relpath" ] || mkdir -p "$build_relpath"
cd "$build_relpath"

# Source links might be commented out
sudo sed -i.orig 's/^#\s*deb-src/deb-src/g' /etc/apt/sources.list

sudo apt-get update

# Get source code and dependencies
sudo apt-get --yes install devscripts
apt-get source $pkg_name
sudo apt-get --yes build-dep $pkg_name
sources_dir=`ls -d */`

# Download and apply patch
wget -O "$patch_file" "$patch_url"
patch "${sources_dir}/${target_file_relpath}" < "$patch_file"

# Compile sources and build debs
pushd "$sources_dir"/
debuild -us -uc
popd

# Install patched package
sudo dpkg -i "./$deb_name"

# Prevent package updates
sudo apt-mark hold $pkg_name
echo -e "To unhold the package run:\nsudo apt-mark unhold $pkg_name"
