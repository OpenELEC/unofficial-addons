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

PKG_NAME="wireless_tools"
PKG_VERSION="29"
PKG_REV="0"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Tools.html"
PKG_URL="http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/$PKG_NAME.$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="${PKG_NAME}.${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="debug/tools"
PKG_SHORTDESC="wireless-tools: tools allowing to manipulate the Wireless Extensions"
PKG_LONGDESC="The Wireless Tools (WT) is a set of tools allowing to manipulate the Wireless Extensions. They use a textual interface and are rather crude, but aim to support the full Wireless Extension. There are many other tools you can use with Wireless Extensions, however Wireless Tools is the reference implementation."

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROVIDES=""
PKG_ADDON_REPOVERSION="8.0"

PKG_AUTORECONF="no"

PKG_MAINTAINER="Dag Wieers (dag@wieers.com)"

pre_configure_Target() {
  # wireless_tools fails to build on some systems with LTO enabled
  strip_lto
}

make_target() {
  make PREFIX=/usr CC="$CC" AR="$AR" \
     CFLAGS="$CFLAGS" CPPFLAGS="$CPPFLAGS" iwmulticall
}

makeinstall_target() {
  : # nop
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -P $PKG_BUILD/iwmulticall $ADDON_BUILD/$PKG_ADDON_ID/bin/iwconfig
  cp -P $PKG_BUILD/iwmulticall $ADDON_BUILD/$PKG_ADDON_ID/bin/iwgetid
  cp -P $PKG_BUILD/iwmulticall $ADDON_BUILD/$PKG_ADDON_ID/bin/iwlist
  cp -P $PKG_BUILD/iwmulticall $ADDON_BUILD/$PKG_ADDON_ID/bin/iwspy
  cp -P $PKG_BUILD/iwmulticall $ADDON_BUILD/$PKG_ADDON_ID/bin/iwpriv
}
