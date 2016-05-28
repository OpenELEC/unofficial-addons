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

PKG_NAME="dvblast"
PKG_VERSION="3.0"
PKG_REV="0"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.videolan.org"
PKG_URL="http://downloads.videolan.org/pub/videolan/dvblast/${PKG_VERSION}/dvblast-${PKG_VERSION}.tar.bz2"
PKG_DEPENDS_TARGET="toolchain bitstream libev"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_SHORTDESC="DVBlast is a simple and powerful MPEG-2/TS demux and streaming application"
PKG_LONGDESC="DVBlast is a simple and powerful MPEG-2/TS demux and streaming application"
PKG_DISCLAIMER="this is an unofficial addon. please don't ask for support in openelec forum / irc channel"

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROVIDES=""
PKG_ADDON_REPOVERSION="8.0"

PKG_AUTORECONF="no"

PKG_MAINTAINER="Stefan Saraev (seo at irc.freenode.net)"

MAKEFLAGS="V=1"

pre_configure_target() {
  export LDFLAGS="$LDFLAGS -lm"
}

makeinstall_target() {
  : # nop
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -P $PKG_BUILD/dvblast $ADDON_BUILD/$PKG_ADDON_ID/bin/
}
