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

PKG_NAME="streamdisc"
PKG_VERSION="14f152c"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/tilwolff/streamdisc"
PKG_GIT_URL="https://github.com/tilwolff/streamdisc.git"
PKG_GIT_BRANCH="master"
PKG_DEPENDS_TARGET="toolchain libbluray libdvdread libdvdcss"
PKG_PRIORITY="optional"
PKG_SECTION="service/multimedia"
PKG_SHORTDESC="streamdisc (Version: $PKG_VERSION): stream unencrypted DVD and BluRay content to clients that do not have an optical drive."
PKG_LONGDESC="streamdisc (Version: $PKG_VERSION): a tiny http streaming server delivering unencrypted DVD and BluRay content to clients that do not have an optical drive. On the client side, just add http://your.server.ip.address:port as a new generic kodi source."
PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.service"
PKG_ADDON_PROVIDES=""
PKG_AUTORECONF="no"
PKG_ADDON_REPOVERSION="7.0"

PKG_MAINTAINER="tilwolff (at) yahoo (dotcom)"

pre_configure_target() {
  export LIBS="-ldvdread -ldvdcss"
}

makeinstall_target() {
  : # nothing to do here
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
    cp -P $PKG_BUILD/.$TARGET_NAME/src/streamdisc_server $ADDON_BUILD/$PKG_ADDON_ID/bin
}
