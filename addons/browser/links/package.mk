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

PKG_NAME="links"
PKG_VERSION="2.14"
PKG_REV="1"
PKG_ARCH="i386 x86_64"
PKG_LICENSE="GPL"
PKG_SITE="http://links.twibright.com/"
PKG_URL="http://links.twibright.com/download/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libressl libjpeg-turbo libpng libX11 libxcb libXau zlib"
PKG_PRIORITY="optional"
PKG_SECTION="browser"
PKG_SHORTDESC="Links web browser plugin for OpenELEC"
PKG_LONGDESC="Links is a popular small-footprint graphics and text mode privacy-oriented web browser, released under GPL. Visit http://www.antiprism.ca for more privacy tools."
PKG_MAINTAINER="AntiPrism.ca (antiprism@antiprism.ca)"
PKG_DISCLAIMER="this is an unofficial addon. please don't ask for support in openelec forum / irc channel"
PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROVIDES=""
PKG_ADDON_REPOVERSION="7.0"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--x-includes=$SYSROOT_PREFIX/usr/include/X11/ \
        --x-libraries=$SYSROOT_PREFIX/usr/X11/lib/ \
        --enable-graphics \
        --with-ssl \
        --disable-ssl-pkgconfig \
        --without-libevent \
        --without-bzip2 \
        --without-bzlib \
        --without-lzma \
        --without-svgalib \
        --with-x \
        --without-directfb \
        --without-libtiff"

makeinstall_target() {
  : # nope
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -f $PKG_BUILD/.$TARGET_NAME/links $ADDON_BUILD/$PKG_ADDON_ID/bin/
  $STRIP $ADDON_BUILD/$PKG_ADDON_ID/bin/links
}
