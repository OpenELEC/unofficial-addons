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

PKG_NAME="handbrake"
PKG_VERSION="0.10.5"
PKG_REV="1"
PKG_ARCH="i386 x86_64"
PKG_LICENSE="GPL"
PKG_SITE="https://handbrake.fr/"
PKG_GIT_URL="https://github.com/HandBrake/HandBrake.git"
PKG_GIT_BRANCH="0.10.x"
PKG_DEPENDS_TARGET="toolchain yasm:host bzip2 fontconfig freetype fribidi libxml2 libass libogg libvorbis lame"
PKG_PRIORITY="optional"
PKG_SECTION="lib/multimedia"
PKG_SHORTDESC="HandBrake is a tool for converting video from nearly any format to a selection of modern, widely supported codecs."
PKG_LONGDESC="HandBrake is a tool for converting video from nearly any format to a selection of modern, widely supported codecs."
PKG_DISCLAIMER="this is an unofficial addon. please don't ask for support in openelec forum / irc channel"

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROVIDES=""
PKG_ADDON_REPOVERSION="7.0"

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
