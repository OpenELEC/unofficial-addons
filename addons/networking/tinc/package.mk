#####################################################################
# This file is part of the tinc addon for OpenELEC.
# Copyright (C) 2014 Jean-Charles Andlauer
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with OpenELEC; if not, write to the Free Software Foundation,
# Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#####################################################################

PKG_NAME="tinc"
PKG_VERSION="1.0.24"
PKG_REV="8"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_SITE="http://www.tinc-vpn.org/"
PKG_URL="${PKG_SITE}/packages/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain lzo"
PKG_PRIORITY="optional"
PKG_SECTION="service/system"
PKG_SHORTDESC="tinc Virtual Private Network Daemon"
PKG_LONGDESC="tinc is a virtual private network (VPN) daemon that uses tunnelling and encryption to create a secure private network between hosts on the Internet. Because the VPN appears to the IP level network code as a normal network device, there is no need to adapt any existing software. This allows VPN sites to share information with each other over the Internet without exposing any information to others."
PKG_DISCLAIMER="This is an unofficial addon. Do therefore not expect support from OpenELEC forum and irc channel."

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.service"

PKG_MAINTAINER="Jean-Charles Andlauer (andlauer@gmail.com)"

PKG_AUTORECONF="yes"
PKG_CONFIGURE_OPTS_TARGET="--sysconfdir=/storage/.cache"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
}

makeinstall_target() {
  :
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $PKG_BUILD/src/tincd $ADDON_BUILD/$PKG_ADDON_ID/bin
}
