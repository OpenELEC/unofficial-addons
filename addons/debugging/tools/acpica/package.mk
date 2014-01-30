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

PKG_NAME="acpica"
PKG_VERSION="unix2-20130328"
PKG_REV="0"
PKG_ARCH="i386 x86_64"
PKG_LICENSE="GPL"
PKG_SITE="http://www.acpica.org/"
PKG_URL="https://www.acpica.org/download/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_URL="https://acpica.org/sites/acpica/files/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain flex bison:host"
PKG_PRIORITY="optional"
PKG_SECTION="debug/tools"
PKG_SHORTDESC="acpica: A set of tools to disassemble ACPI tables"
PKG_LONGDESC="acpica is a set of tools from Intel to disassemble ACPI tables."

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"

PKG_AUTORECONF="no"

PKG_MAINTAINER="Dag Wieers (dag@wieers.com)"

[ "$TARGET_ARCH" = "i386" ] && ACPICA_BITS="32"
[ "$TARGET_ARCH" = "x86_64" ] && ACPICA_BITS="64"

make_target() {
  make PREFIX=/usr \
     CC="$TARGET_CC" \
     AR="$TARGET_AR" \
     HOST=_LINUX \
     HARDWARE_NAME=$TARGET_ARCH \
     BITS=$ACPICA_BITS \
     YACC=$ROOT/$TOOLCHAIN/bin/bison \
     CWARNINGFLAGS="-O2 $TARGET_CFLAGS"
}

makeinstall_target() {
  : # nop
}

addon() {
  [ "$TARGET_ARCH" = "i386" ] && ACPICA_BIN="bin32"
  [ "$TARGET_ARCH" = "x86_64" ] && ACPICA_BIN="bin64"

  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -p $PKG_BUILD/generate/unix/$ACPICA_BIN/* $ADDON_BUILD/$PKG_ADDON_ID/bin
}
