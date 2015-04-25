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

PKG_NAME="x11-utils"
PKG_VERSION="1"
PKG_REV="3"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_SITE="http://xorg.freedesktop.org/releases/individual/app/"
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain xprop xwininfo xdpyinfo xrdb"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_SHORTDESC="x11-utils"
PKG_LONGDESC="xprop xwininfo xdpyinfo xrdb"
PKG_DISCLAIMER="this is an unofficial addon. please don't ask for support in openelec forum / irc channel"

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROVIDES=""
PKG_ADDON_REPOVERSION="4.3"

PKG_AUTORECONF="no"

PKG_MAINTAINER="Stefan Saraev (seo at irc.freenode.net)"

make_target() {
  : nop
}

makeinstall_target() {
  : # nop
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -PR $(get_build_dir xprop)/.$TARGET_NAME/xprop $ADDON_BUILD/$PKG_ADDON_ID/bin/
  cp -PR $(get_build_dir xwininfo)/.$TARGET_NAME/xwininfo $ADDON_BUILD/$PKG_ADDON_ID/bin/
  cp -PR $(get_build_dir xdpyinfo)/.$TARGET_NAME/xdpyinfo $ADDON_BUILD/$PKG_ADDON_ID/bin/
  cp -PR $(get_build_dir xrdb)/.$TARGET_NAME/xrdb $ADDON_BUILD/$PKG_ADDON_ID/bin/
}
