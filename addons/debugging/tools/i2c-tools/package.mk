################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2013 Dag Wieers (dag@wieers.com)
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.tv; see the file COPYING.  If not, write to
#  the Free Software Foundation, 51 Franklin Street, Suite 500, Boston, MA 02110, USA.
#  http://www.gnu.org/copyleft/gpl.html
################################################################################

PKG_NAME="i2c-tools"
PKG_VERSION="3.1.0"
PKG_REV="0"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.lm-sensors.org/wiki/I2CTools"
PKG_URL="http://dl.lm-sensors.org/i2c-tools/releases/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET=""
PKG_BUILD_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="debug/tools"
PKG_SHORTDESC="i2c-tools: bus probing tool, eeprom decoding/programming and SMBus python interface"
PKG_LONGDESC="The i2c-tools package contains a heterogeneous set of I2C tools for Linux: a bus probing tool, a chip dumper, register-level SMBus access helpers, EEPROM decoding scripts, EEPROM programming tools, and a python module for SMBus access."

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"

PKG_AUTORECONF="no"

PKG_MAINTAINER="Dag Wieers (dag@wieers.com)"

make_target() {
  make PREFIX=/usr \
     CC="$TARGET_CC" \
     AR="$TARGET_AR" \
     CFLAGS="$TARGET_CFLAGS" \
     CPPFLAGS="$TARGET_CPPFLAGS"
}

makeinstall_target() {
  : # nop
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -P $PKG_BUILD/tools/i2cdetect $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -P $PKG_BUILD/tools/i2cdump $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -P $PKG_BUILD/tools/i2cget $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -P $PKG_BUILD/tools/i2cset $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -P $PKG_BUILD/stub/i2c-stub-from-dump $ADDON_BUILD/$PKG_ADDON_ID/bin
}
