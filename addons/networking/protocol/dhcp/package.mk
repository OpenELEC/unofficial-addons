################################################################################
# This file is part of OpenELEC - http://www.openelec.tv
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2014 smory
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

PKG_NAME="dhcp"
PKG_VERSION="4.1-ESV-R9"
PKG_REV="0"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://www.isc.org/"
PKG_URL="ftp://ftp.isc.org/isc/dhcp/$PKG_VERSION/dhcp-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="plugin/network"
PKG_SHORTDESC="ISC DHCP is easy and efficient way to provide dhcp services"
PKG_LONGDESC="ISC DHCP is open source software that implements the Dynamic Host Configuration Protocol for connection to an IP network. It is production-grade software that offers a complete solution for implementing DHCP servers, relay agents, and clients for small local networks to large enterprises. ISC DHCP solution supports both IPv4 and IPv6, and is suitable for use in high-volume and high-reliability applications. DHCP is available under the terms of the ISC License, a BSD style license."
PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.service"
PKG_ADDON_PROVIDES=""
PKG_ADDON_REPOVERSION="7.0"
PKG_AUTORECONF="yes"
PKG_MAINTAINER="Peter Smorada (smoradap@gmail.com)"
PKG_DISCLAIMER="this is an unofficial addon. please don't ask for support in openelec forum / irc channel"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_file__dev_random=yes \
                           --sysconfdir=/storage/.kodi/userdata/addon_data/plugin.network.dhcp"

pre_configure_target() {
  # dhcp fails to build in subdirs
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME

  export CFLAGS="$CFLAGS -D_PATH_DHCLIENT_SCRIPT='\"/storage/.kodi/addons/plugin.network.dhcp/bin/dhclient-script\"' \
    -D_PATH_DHCPD_CONF='\"/storage/.kodi/userdata/addon_data/plugin.network.dhcp/dhcpd.conf\"'  \
    -D_PATH_DHCLIENT_CONF='\"/storage/.kodi/userdata/addon_data/plugin.network.dhcp/dhclient.conf\"'"
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $PKG_BUILD/.install_pkg/usr/sbin/dhclient $ADDON_BUILD/$PKG_ADDON_ID/bin/
  cp $PKG_BUILD/.install_pkg/usr/sbin/dhcpd $ADDON_BUILD/$PKG_ADDON_ID/bin/
  cp $PKG_BUILD/.install_pkg/usr/sbin/dhcrelay $ADDON_BUILD/$PKG_ADDON_ID/bin/
  cp $PKG_BUILD/.install_pkg/usr/bin/omshell $ADDON_BUILD/$PKG_ADDON_ID/bin/
}
