################################################################################
# This file is part of OpenELEC - http://www.openelec.tv
# Copyright (C) 2015 Anton Voyl (awiouy@gmail.com)
#
# OpenELEC is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# OpenELEC is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with OpenELEC. If not, see <http://www.gnu.org/licenses/>.
################################################################################
PKG_NAME="tinc"
PKG_VERSION="1.1pre11"
PKG_REV="3"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_SITE="http://www.tinc-vpn.org/"
PKG_URL="${PKG_SITE}/packages/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libressl lzo"
PKG_PRIORITY="optional"
PKG_SECTION="plugin/program"
PKG_SHORTDESC="tinc Virtual Private Network Daemon"
PKG_LONGDESC="tinc is a virtual private network (VPN) daemon that uses tunnelling and encryption to create a secure private network between hosts on the Internet. Because the VPN appears to the IP level network code as a normal network device, there is no need to adapt any existing software. This allows VPN sites to share information with each other over the Internet without exposing any information to others."
PKG_AUTORECONF="yes"
PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_MAINTAINER="Anton Voyl (awiouy@gmail.com)"
PKG_DISCLAIMER="This is an unofficial addon. Please don't ask for support in openelec forum or irc channel."
PKG_CONFIGURE_OPTS_TARGET="--disable-curses --disable-readline \
                           --disable-curses \
                           --sysconfdir=/storage/.cache"

pre_configure_target() {
  # tinc fails to build in subdirs
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
}

makeinstall_target() {
  :
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $PKG_BUILD/src/tinc \
     $PKG_BUILD/src/tincd \
     $ADDON_BUILD/$PKG_ADDON_ID/bin
}
