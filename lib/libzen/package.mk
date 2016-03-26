################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2011 Stephan Raue (stephan@openelec.tv)
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
#  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
#  http://www.gnu.org/copyleft/gpl.htmlLooking for the latest version?
################################################################################

PKG_NAME="libzen"
PKG_VERSION="0.4.33"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://mediaarea.net/en/MediaInfo/"
PKG_URL="http://mediaarea.net/download/source/libzen/$PKG_VERSION/libzen_$PKG_VERSION.tar.bz2"
PKG_SOURCE_DIR="ZenLib"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="multimedia"
PKG_SHORTDESC="MediaInfo is a convenient unified display of the most relevant technical and tag data for video and audio files"
PKG_LONGDESC="MediaInfo is a convenient unified display of the most relevant technical and tag data for video and audio files"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_MAINTAINER="Stefan Saraev (seo at irc.freenode.net)"

make_target() {
  cd Project/GNU/Library
  do_autoreconf
  ./configure \
        --host=$TARGET_NAME \
        --build=$HOST_NAME \
        --enable-static \
        --disable-shared \
        --prefix=/usr

  make
}

post_makeinstall_target() {
  mkdir -p $SYSROOT_PREFIX/usr/include/ZenLib
  cp -aP ../../../Source/ZenLib/*.h $SYSROOT_PREFIX/usr/include/ZenLib
  for i in HTTP_Client Format/Html Format/Http ; do
    mkdir -p $SYSROOT_PREFIX/usr/include/ZenLib/$i/
    cp -aP ../../../Source/ZenLib/$i/*.h $SYSROOT_PREFIX/usr/include/ZenLib/$i/
  done
  cp -P libzen-config $ROOT/$TOOLCHAIN/bin
}
