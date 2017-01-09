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

PKG_NAME="encfs"
PKG_VERSION="1.9.1"
PKG_REV="2"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.arg0.net/encfs"
PKG_URL="https://github.com/vgough/encfs/releases/download/v$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain fuse libressl"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_SHORTDESC="encfs: encrypted filesystem in user-space"
PKG_LONGDESC="EncFS provides an encrypted filesystem in user-space. It runs without any special permissions and uses the FUSE library and Linux kernel module to provide the filesystem interface. You can find links to source and binary releases below. EncFS is open source software, licensed under the GPL"

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROVIDES=""
PKG_ADDON_REPOVERSION="7.0"

PKG_AUTORECONF="no"

PKG_MAINTAINER="Stefan Saraev (seo at irc.freenode.net)"

configure_target() {
  cmake -DCMAKE_TOOLCHAIN_FILE=$CMAKE_CONF \
        -DCMAKE_INSTALL_PREFIX=/usr \
        ..
}

makeinstall_target() {
  : # nop
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
    cp -P $PKG_BUILD/.$TARGET_NAME/encfs $ADDON_BUILD/$PKG_ADDON_ID/bin/
    cp -P $PKG_BUILD/.$TARGET_NAME/encfsctl $ADDON_BUILD/$PKG_ADDON_ID/bin/
}
