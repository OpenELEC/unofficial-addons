################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
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

PKG_NAME="getscancodes"
PKG_VERSION="1.0"
PKG_REV="0"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://keytouch.sourceforge.net"
PKG_URL="$SOURCEFORGE_SRC/keytouch/getscancodes-${PKG_VERSION}.tar.gz"
PKG_SOURCE_DIR="$PKG_NAME"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_SHORTDESC="Shows the scancode of the pressed or released key"
PKG_LONGDESC="Shows the scancode of the pressed or released key"
PKG_DISCLAIMER="this is an unofficial addon. please don't ask for support in openelec forum / irc channel"

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"

PKG_AUTORECONF="no"

PKG_MAINTAINER="Stefan Saraev (seo at irc.freenode.net)"

makeinstall_target() {
  : # nop
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -P $PKG_BUILD/getscancodes $ADDON_BUILD/$PKG_ADDON_ID/bin/
}
