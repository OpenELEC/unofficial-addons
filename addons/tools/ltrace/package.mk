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

PKG_NAME="ltrace"
PKG_VERSION="0.7.3"
PKG_REV="4"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_SITE="http://ltrace.org/"
PKG_URL="ftp://orff.orchestra.cse.unsw.edu.au/pub/gentoo/distfiles/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain elfutils"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_SHORTDESC="ltrace intercepts and records dynamic library calls which are called by an executed process and the signals received by that process"
PKG_LONGDESC="ltrace intercepts and records dynamic library calls which are called by an executed process and the signals received by that process"
PKG_DISCLAIMER="this is an unofficial addon. please don't ask for support in openelec forum / irc channel"

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROVIDES=""

PKG_AUTORECONF="yes"

PKG_MAINTAINER="Stefan Saraev (seo at irc.freenode.net)"

PKG_CONFIGURE_OPTS_TARGET="--disable-werror --without-libunwind --with-sysroot=$SYSROOT_PREFIX"

makeinstall_target() {
  : # nop
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -P $PKG_BUILD/.$TARGET_NAME/ltrace $ADDON_BUILD/$PKG_ADDON_ID/bin/
}
