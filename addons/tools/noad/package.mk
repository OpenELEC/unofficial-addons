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

PKG_NAME="noad"
PKG_VERSION="0.8.5"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://noad.net23.net/"
PKG_URL="http://noad.net23.net/noad-0.8.5.tar.bz2"
PKG_DEPENDS_TARGET="ffmpeg libmpeg2"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_SHORTDESC="noad - no advertising"
PKG_LONGDESC="noad - no advertising"

PKG_IS_ADDON="yes"

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"

PKG_AUTORECONF="yes"

PKG_MAINTAINER="unofficial.addon.pro, henkwiedig"

PKG_CONFIGURE_OPTS_TARGET="--with-magick --with-tools"

makeinstall_target() {
  : # nop
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $PKG_BUILD/.$TARGET_NAME/noad $ADDON_BUILD/$PKG_ADDON_ID/bin
}
