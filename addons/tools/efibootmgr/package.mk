################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2017 Stephan Raue (stephan@openelec.tv)
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

PKG_NAME="efibootmgr"
PKG_VERSION="0bb83cf"
PKG_REV="2"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/vathpela/efibootmgr"
PKG_GIT_URL="https://github.com/vathpela/efibootmgr-devel.git"
PKG_GIT_BRANCH="master"
PKG_DEPENDS_TARGET="toolchain efivar pciutils zlib"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_SHORTDESC="EFI Boot Manager"
PKG_LONGDESC="This is a Linux user-space application to modify the Intel Extensible Firmware Interface (EFI) Boot Manager configuration. This application can create and destroy boot entries, change the boot order, change the next running boot option, and more."
PKG_DISCLAIMER="this is an unofficial addon. please don't ask for support in openelec forum / irc channel"

#PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROVIDES=""
PKG_ADDON_REPOVERSION="7.0"

PKG_AUTORECONF="no"

PKG_MAINTAINER="Stefan Benz (benz.st@gmail.com)"

pre_make_target() {
  strip_lto
  export CFLAGS="$CFLAGS -fgnu89-inline"
  export LDFLAGS="$LDFLAGS -ludev -ldl"
}

makeinstall_target() {
  : # nop
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -P $PKG_BUILD/src/efibootmgr/efibootmgr $ADDON_BUILD/$PKG_ADDON_ID/bin/
}

