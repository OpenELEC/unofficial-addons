################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2014 Stefan Benz (benz.st@gmail.com)
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

PKG_NAME="efivar"
PKG_VERSION="0.10"
PKG_REV="0"
PKG_ARCH="i386 x86_64"
PKG_LICENSE="LGPL"
PKG_SITE="https://github.com/vathpela/efivar"
PKG_URL="http://stbenz.de/openelec/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain efivar:host"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_SHORTDESC="EFI Variables"
PKG_LONGDESC="Tools and library to manipulate EFI variables."
PKG_IS_ADDON="no"

PKG_AUTORECONF="no"

PKG_MAINTAINER="Stefan Benz (benz.st@gmail.com)"

make_host() {
  strip_lto
  make -C src/ makeguids
}

make_target() {
  strip_lto
  make -C src/ libefivar.a efivar-guids.h efivar.h
}

makeinstall_host() {
  : # noop
}

makeinstall_target() {
  mkdir -p $SYSROOT_PREFIX/usr/lib
  mkdir -p $SYSROOT_PREFIX/usr/include
  cp -P src/libefivar.a $SYSROOT_PREFIX/usr/lib/
  cp -P src/efivar.h $SYSROOT_PREFIX/usr/include/
  cp -P src/efivar-guids.h $SYSROOT_PREFIX/usr/include/
}

