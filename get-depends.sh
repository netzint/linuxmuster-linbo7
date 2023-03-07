#!/bin/sh
#
# thomas@linuxmuster.net
# 20230306
#

set -e

SUDO="$(which sudo)"
if [ -z "$SUDO" ]; then
  echo "Please install sudo!"
  exit 1
fi

PKGNAME="linuxmuster-linbo7"

echo "###############################################"
echo "# Installing $PKGNAME build depends #"
echo "###############################################"
echo

if [ ! -e debian/control ]; then
 echo "debian/control not found!"
 exit
fi

if ! grep -q "Source: $PKGNAME" debian/control; then
 echo "This is no $PKGNAME source tree!"
 exit
fi

# clean config.dat
echo "Clean config.dat"
$SUDO rm -v /var/cache/debconf/config.dat

# install prerequisites
$SUDO apt-get update
$SUDO apt-get -y install grub-efi-amd64-bin
$SUDO apt-get --only-upgrade -y install grub-efi-amd64-signed
$SUDO apt-get -y dist-upgrade
$SUDO apt-get -y install bash bash-completion ccache curl dpkg-dev


# install build depends
BUILDDEPENDS="$(sed -n '/Build-Depends:/,/Package:/p' debian/control | grep -v ^Package | sed -e 's|^Build-Depends: ||' | sed -e 's|,||g')"
$SUDO apt-get -y install $BUILDDEPENDS
