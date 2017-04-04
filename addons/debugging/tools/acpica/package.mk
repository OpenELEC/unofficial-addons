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

PKG_NAME="acpica"
PKG_VERSION="unix-20161222"
PKG_REV="2"
PKG_ARCH="i386 x86_64"
PKG_LICENSE="GPL"
PKG_SITE="http://www.acpica.org/"
PKG_URL="https://acpica.org/sites/acpica/files/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain flex:host bison:host"
PKG_PRIORITY="optional"
PKG_SECTION="debug/tools"
PKG_SHORTDESC="acpica: A set of tools to disassemble ACPI tables"
PKG_LONGDESC="acpica is a set of tools from Intel to disassemble ACPI tables."

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROVIDES=""
PKG_ADDON_REPOVERSION="7.0"

PKG_AUTORECONF="no"

PKG_MAINTAINER="Dag Wieers (dag@wieers.com)"

if [ $TARGET_ARCH="x86_64" ]; then
  ACPICA_BITS="64"
elif [ $TARGET_ARCH="i386" ]; then
  ACPICA_BITS="64"
fi

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
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -p $PKG_BUILD/generate/unix/bin/* $ADDON_BUILD/$PKG_ADDON_ID/bin
}
