################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
#
#  OpenELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  OpenELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="picamera"
PKG_VERSION="1.9"
PKG_REV="0"
PKG_ARCH="arm"
PKG_LICENSE="BSD"
PKG_SITE="http://sourceforge.net/p/raspberry-gpio-python/"
PKG_URL="https://pypi.python.org/packages/source/p/picamera/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python distutilscross:host bcm2835-driver"
PKG_PRIORITY="optional"
PKG_SECTION="python"
PKG_SHORTDESC="A python and shell interface for the Raspberry Pi camera module"
PKG_LONGDESC="A python and shell interface for the Raspberry Pi camera module"
PKG_DISCLAIMER="This is an unofficial addon. please don't ask for support in openelec forum / irc channel"

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.module"
PKG_ADDON_PROVIDES=""
PKG_ADDON_PROJECTS="RPi RPi2"
PKG_ADDON_REPOVERSION="7.0"

PKG_AUTORECONF="no"

PKG_MAINTAINER="Lukas Rusak (lrusak at irc.freenode.net)"

if [ "$TARGET_FLOAT" = "softfp" -o "$TARGET_FLOAT" = "soft" ]; then
  FLOAT="softfp"
elif [ "$TARGET_FLOAT" = "hard" ]; then
  FLOAT="hardfp"
fi

make_target() {
  : # nop
}

makeinstall_target() {
  : # nop
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/lib/
    cp -rP $PKG_BUILD/picamera $ADDON_BUILD/$PKG_ADDON_ID/lib/picamera

  BCM2835_DIR="$(get_build_dir bcm2835-driver)"
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin/
    cp -P $BCM2835_DIR/$FLOAT/opt/vc/bin/raspistill $ADDON_BUILD/$PKG_ADDON_ID/bin
    cp -P $BCM2835_DIR/$FLOAT/opt/vc/bin/raspiyuv $ADDON_BUILD/$PKG_ADDON_ID/bin
    cp -P $BCM2835_DIR/$FLOAT/opt/vc/bin/raspivid $ADDON_BUILD/$PKG_ADDON_ID/bin
    cp -P $BCM2835_DIR/$FLOAT/opt/vc/bin/raspividyuv $ADDON_BUILD/$PKG_ADDON_ID/bin
}
