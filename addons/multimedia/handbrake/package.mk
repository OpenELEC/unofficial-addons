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

PKG_NAME="handbrake"
PKG_VERSION="b79c968"
PKG_REV="3"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_SITE="https://handbrake.fr/"
PKG_URL="$DISTRO_SRC/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain yasm:host bzip2 fontconfig freetype fribidi libxml2 libass libogg libvorbis lame"
PKG_PRIORITY="optional"
PKG_SECTION="lib/multimedia"
PKG_SHORTDESC="HandBrake is a tool for converting video from nearly any format to a selection of modern, widely supported codecs."
PKG_LONGDESC="HandBrake is a tool for converting video from nearly any format to a selection of modern, widely supported codecs."
PKG_DISCLAIMER="this is an unofficial addon. please don't ask for support in openelec forum / irc channel"

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROVIDES=""
PKG_ADDON_REPOVERSION="4.3"

PKG_AUTORECONF="no"

PKG_MAINTAINER="Lukas Rusak (lrusak at irc.freenode.net)"

pre_configure_target() {
  # handbrake fails to compile with lto / gold
  strip_lto
  strip_gold
  # dont build in OE's default subdir
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
}

configure_target() {
  cd $ROOT/$PKG_BUILD
  ./configure --disable-gtk \
              --cross=$TARGET_NAME \
              --sysroot=$SYSROOT_PREFIX/usr \
              --ar=$TARGET_AR \
              --gcc=$TARGET_CC \
              --ranlib=$TARGET_RANLIB \
              --strip=$TARGET_STRIP \
              --force
}

pre_make_target() {
  # compile in ./build
  mkdir -p $ROOT/$PKG_BUILD/build
  cd $ROOT/$PKG_BUILD/build
}

post_make_target() {
  $STRIP HandBrakeCLI
}

makeinstall_target() {
  : # nop
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
    cp -P $PKG_BUILD/build/HandBrakeCLI $ADDON_BUILD/$PKG_ADDON_ID/bin/
}
