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

PKG_NAME="makemkv"
PKG_VERSION="1.9.2"
PKG_REV="0"
PKG_ARCH="x86_64"
PKG_LICENSE="OSS"
PKG_SITE="http://www.makemkv.com/forum2/viewforum.php?f=3"
PKG_URL="http://www.makemkv.com/download/${PKG_NAME}-oss-${PKG_VERSION}.tar.gz"
PKG_URL="$PKG_URL http://www.makemkv.com/download/${PKG_NAME}-bin-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain libressl expat ffmpeg"
PKG_PRIORITY="optional"
PKG_SECTION="lib/multimedia"
PKG_SHORTDESC="MakeMKV converts the video clips from proprietary (and usually encrypted) disc into a set of MKV files, preserving most information but not changing it in any way."
PKG_LONGDESC="MakeMKV can instantly stream decrypted video without intermediate conversion to wide range of players, so you may watch Blu-ray and DVD discs with your favorite player on your favorite OS or on your favorite device."

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROVIDES=""
PKG_ADDON_REPOVERSION="6.0"

PKG_AUTORECONF="no"

PKG_MAINTAINER="unofficial.addon.pro"

PKG_CONFIGURE_OPTS_TARGET="--disable-gui --enable-noec"

post_unpack() {
  mkdir -p $BUILD/$PKG_NAME-$PKG_VERSION
    mv $BUILD/${PKG_NAME}-oss-${PKG_VERSION}/* $BUILD/$PKG_NAME-$PKG_VERSION
    rm -rf $BUILD/${PKG_NAME}-oss-${PKG_VERSION}
  mkdir -p $BUILD/$PKG_NAME-$PKG_VERSION/bin
    mv $BUILD/${PKG_NAME}-bin-${PKG_VERSION}/* $BUILD/$PKG_NAME-$PKG_VERSION/bin
    rm -rf $BUILD/${PKG_NAME}-bin-${PKG_VERSION}
}

pre_configure_target() {
# makemkv fails to build in subdirs
  cd $ROOT/$PKG_BUILD
    rm -rf .$TARGET_NAME
}

makeinstall_target() {
  : # nop
}

addon() {
  MAKEMKV_ARCH=amd64

  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $PKG_BUILD/bin/bin/$MAKEMKV_ARCH/makemkvcon $ADDON_BUILD/$PKG_ADDON_ID/bin/makemkvcon.bin
  chmod 755 $ADDON_BUILD/$PKG_ADDON_ID/bin/makemkvcon.bin

  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp $PKG_BUILD/out/libmakemkv.so.[0-9] $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp $PKG_BUILD/out/libdriveio.so.[0-9] $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp $PKG_BUILD/out/libmmbd.so.[0-9] $ADDON_BUILD/$PKG_ADDON_ID/lib
}
