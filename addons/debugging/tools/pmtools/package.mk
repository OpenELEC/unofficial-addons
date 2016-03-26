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

PKG_NAME="pmtools"
PKG_VERSION="20110323"
PKG_REV="0"
PKG_ARCH="i386 x86_64"
PKG_LICENSE="GPL"
PKG_SITE="https://lesswatts.org/projects/acpi/utilities.php"
PKG_URL="http://mirror.linux.org.au/linux/kernel/people/lenb/acpi/utils/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_SOURCE_DIR="${PKG_NAME}"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="debug/tools"
PKG_SHORTDESC="pmtools: ACPI debugging utilities"
PKG_LONGDESC="The pmtools package contains tools to debug ACPI DSDT tables"

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROVIDES=""
PKG_ADDON_REPOVERSION="7.0"

PKG_AUTORECONF="no"

PKG_MAINTAINER="Dag Wieers (dag@wieers.com)"

make_target() {
  make CC="$TARGET_CC" \
     CFLAGS="$TARGET_CFLAGS -Wall -Wstrict-prototypes -Wdeclaration-after-statement -Os -s -D_LINUX -DDEFINE_ALTERNATE_TYPES -I../include" \
     -C acpidump acpidump

  make CC="$TARGET_CC" \
     CFLAGS="$TARGET_CFLAGS -Wall -Wstrict-prototypes -Wdeclaration-after-statement -Os -s -D_LINUX -DDEFINE_ALTERNATE_TYPES -I../include" \
     -C acpixtract acpixtract

  make CC="$TARGET_CC" \
     CFLAGS="$TARGET_CFLAGS -Wall -Wstrict-prototypes -Wdeclaration-after-statement -Os -s -D_LINUX -DDEFINE_ALTERNATE_TYPES -I../include" \
     -C madt madt
}

makeinstall_target() {
  : # nop
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -P $PKG_BUILD/acpidump/acpidump $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -P $PKG_BUILD/acpixtract/acpixtract $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -P $PKG_BUILD/madt/madt $ADDON_BUILD/$PKG_ADDON_ID/bin
}
