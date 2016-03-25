################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2016 Anton Voyl (awiouy at gmail dot com)
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

PKG_NAME="syncthing"
PKG_VERSION="0.12.21"
PKG_REV="2"
PKG_ARCH="any"
PKG_LICENSE="MPLv2"
PKG_SITE="https://syncthing.net/"
PKG_DEPENDS_TARGET=""
PKG_PRIORITY="optional"
PKG_SECTION="service/system"

PKG_SHORTDESC="Open Source Continuous File Synchronization"
PKG_LONGDESC="Syncthing replaces proprietary sync and cloud services with something open, trustworthy and decentralized. Your data is your data alone and you deserve to choose where it is stored, if it is shared with some third party and how it's transmitted over the Internet."
PKG_DISCLAIMER="This is a community addon. Please don't ask for support in openelec forum or irc channel."
PKG_MAINTAINER="Anton Voyl (awiouy at gmail dot com)"
PKG_ADDON_REPOVERSION="7.0"

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.service"
PKG_ADDON_PROVIDES=""
PKG_AUTORECONF="no"

if [ "$TARGET_ARCH" = "arm" ]; then
  ST_ARCH="linux-arm"
elif [ "$TARGET_ARCH" = "x86_64" ]; then
  ST_ARCH="linux-amd64"
fi

PKG_URL="https://github.com/$PKG_NAME/$PKG_NAME/releases/download/v$PKG_VERSION/$PKG_NAME-$ST_ARCH-v$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="$PKG_NAME-$ST_ARCH-v$PKG_VERSION"

make_target() {
  :
}

makeinstall_target() {
  :
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $PKG_BUILD/syncthing $ADDON_BUILD/$PKG_ADDON_ID/bin
}
