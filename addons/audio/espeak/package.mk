################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
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

PKG_NAME="espeak"
PKG_VERSION="1.48.04-source"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://espeak.sourceforge.net/"
PKG_URL="$DISTRO_SRC/$PKG_NAME-$PKG_VERSION.zip"
PKG_SOURCE_DIR="$PKG_NAME/$PKG_NAME-$PKG_VERSION"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="audio"
PKG_SHORTDESC="Text to Speech engine for English, with support for other languages"
PKG_LONGDESC="Text to Speech engine for English, with support for other languages"

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"

PKG_AUTORECONF="no"

PKG_MAINTAINER="Patrick Rasmussen (patrickrasmussen1988@gmail.com)"

pre_make_target() {
  cp src/portaudio19.h src/portaudio.h
}

make_target() {
  make -C src \
       CXXFLAGS="$CXXFLAGS" \
       LDFLAGS="$LDFLAGS" \
       DATADIR="/storage/.kodi/addons/audio.espeak/espeak-data" \
       AUDIO=""
}

makeinstall_target() {
  : # nop
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -P $PKG_BUILD/src/espeak $ADDON_BUILD/$PKG_ADDON_ID/bin

  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/espeak-data
  cp -r $PKG_BUILD/espeak-data $ADDON_BUILD/$PKG_ADDON_ID/

  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -P $PKG_BUILD/src/libespeak.so.1.1.48 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -P $PKG_BUILD/src/libespeak.so.1 $ADDON_BUILD/$PKG_ADDON_ID/lib
}
