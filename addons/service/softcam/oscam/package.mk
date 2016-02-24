################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
#      Copyright (C) 2011-2011 Gregor Fuis (gujs@openelec.tv)
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

PKG_NAME="oscam"
PKG_VERSION="11211"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.streamboard.tv/oscam/wiki"
PKG_URL="$DISTRO_SRC/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain pcsc-lite"
PKG_PRIORITY="optional"
PKG_SECTION="service/softcam"
PKG_SHORTDESC="oscam: OSCam is Open Source Conditional Access Modul."
PKG_LONGDESC="OSCam is Open Source Conditional Access Modul."
PKG_DISCLAIMER="using oscam may be illegal in your country. if in doubt, do not install"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="OSCam"
PKG_ADDON_TYPE="xbmc.service"
PKG_ADDON_REPOVERSION="7.0"

PKG_AUTORECONF="no"

PKG_MAINTAINER="unofficial.addon.pro"

configure_target() {
  cmake -DCMAKE_TOOLCHAIN_FILE=$CMAKE_CONF \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DLIBUSBDIR=$SYSROOT_PREFIX/usr \
      -DWITH_SSL=0 \
      -DHAVE_LIBCRYPTO=0 \
      -DHAVE_DVBAPI=1 -DWITH_STAPI=0 \
      -DWEBIF=1 \
      -DWITH_DEBUG=0 \
      -DOPTIONAL_INCLUDE_DIR=$SYSROOT_PREFIX/usr/include \
      -DSTATIC_LIBUSB=1 \
      -DCLOCKFIX=0 \
      ..
}

makeinstall_target() {
  : # nop
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -P $PKG_BUILD/.$TARGET_NAME/oscam $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -P $PKG_BUILD/.$TARGET_NAME/utils/list_smargo $ADDON_BUILD/$PKG_ADDON_ID/bin
}
