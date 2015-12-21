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

PKG_NAME="libvncserver"
PKG_VERSION="0.9.10"
PKG_REV="0"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://libvnc.github.io/"
PKG_URL="https://github.com/LibVNC/libvncserver/archive/LibVNCServer-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libjpeg-turbo libpng"
PKG_SECTION="libs"
PKG_PRIORITY="optional"
PKG_SHORTDESC="LibVNCServer/LibVNCClient are cross-platform C libraries that allow you to easily implement VNC server or client functionality in your program."
PKG_LONGDESC="LibVNCServer/LibVNCClient are cross-platform C libraries that allow you to easily implement VNC server or client functionality in your program."

PKG_IS_ADDON="no"

PKG_AUTORECONF="yes"

PKG_MAINTAINER="Lukas Rusak (lrusak at irc.freenode.net)"

unpack() {
  mkdir -p $ROOT/$PKG_BUILD
  tar xf $ROOT/$SOURCES/$PKG_NAME/LibVNCServer-$PKG_VERSION.tar.gz --strip-components=1 -C $ROOT/$PKG_BUILD
}

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
                           --enable-static \
                           --with-sysroot=$SYSROOT_PREFIX \
                           --with-jpeg \
                           --with-png \
                           --without-sdl \
                           --without-gcrypt \
                           --without-client-gcrypt \
                           --without-gnutls"
