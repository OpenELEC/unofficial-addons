################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2016 OpenELEC 
#      Copyright (C) 2016 Peter Smorada (smoradap@gmail.com)
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

PKG_NAME="u-boot-tools"
PKG_VERSION="2016.01"
PKG_REV="0"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.denx.de/wiki/U-Boot/WebHome"
PKG_URL="ftp://ftp.denx.de/pub/u-boot/u-boot-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_SHORTDESC="U-Boot bootloader utility tools"
PKG_LONGDESC="U-Boot bootloader utility tools. This package includes the mkimage program, which allows generation of U-Boot images in various formats, and the fw_printenv and fw_setenv programs to read and modify U-Boot's environment and other tools."
PKG_DISCLAIMER="This addon can make your device unusable if improperly configured. Use at your own risk. This is an unofficial addon. Please don't ask for support in openelec forum / irc channel"

PKG_AUTORECONF="no"

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROVIDES=""
PKG_ADDON_NAME="uboot-tools"
PKG_ADDON_REPOVERSION="7.0"

PKG_MAINTAINER="Peter Smorada (smoradap at gmail dot com)"

unpack() {
  tar jxf "$SOURCES/$PKG_NAME/u-boot-${PKG_VERSION}.tar.bz2" -C $BUILD
  mv $BUILD/u-boot-$PKG_VERSION $BUILD/u-boot-tools-$PKG_VERSION 
}


make_target() {
  make dummy_defconfig
  make CROSS_COMPILE="$TARGET_PREFIX" ARCH="$TARGET_ARCH" env
  make CROSS_COMPILE="$TARGET_PREFIX" cross_tools
}

makeinstall_target() {
  : # nop
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $PKG_BUILD/tools/env/fw_printenv $ADDON_BUILD/$PKG_ADDON_ID/bin/fw_printenv
  cp $PKG_BUILD/tools/env/fw_printenv $ADDON_BUILD/$PKG_ADDON_ID/bin/fw_setenv
  cp $PKG_BUILD/tools/dumpimage $ADDON_BUILD/$PKG_ADDON_ID/bin/dumpimage
  cp $PKG_BUILD/tools/fdtgrep $ADDON_BUILD/$PKG_ADDON_ID/bin/fdtgrep
  cp $PKG_BUILD/tools/gen_eth_addr $ADDON_BUILD/$PKG_ADDON_ID/bin/gen_eth_addr
  cp $PKG_BUILD/tools/img2srec $ADDON_BUILD/$PKG_ADDON_ID/bin/img2srec
  cp $PKG_BUILD/tools/mkenvimage $ADDON_BUILD/$PKG_ADDON_ID/bin/mkenvimage
  cp $PKG_BUILD/tools/mkimage $ADDON_BUILD/$PKG_ADDON_ID/bin/mkimage
  cp $PKG_BUILD/tools/proftool $ADDON_BUILD/$PKG_ADDON_ID/bin/proftool
  cp $PKG_BUILD/tools/relocate-rela $ADDON_BUILD/$PKG_ADDON_ID/bin/relocate-rela
}


