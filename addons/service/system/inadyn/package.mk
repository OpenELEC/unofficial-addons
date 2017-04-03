#####################################################################
# This file is part of the inadyn addon for OpenELEC.
# Copyright (C) 2014-2016 Anton Voyl (awiouy at gmail.com)
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

PKG_NAME="inadyn"
PKG_VERSION="1.99.15"
PKG_REV="2"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_SITE="http://troglobit.com/inadyn.html"
PKG_URL="ftp://troglobit.com/$PKG_NAME/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain libressl"
PKG_PRIORITY="optional"
PKG_SECTION="service/system"
PKG_SHORTDESC="Inadyn, a small and simple DDNS client"
PKG_LONGDESC="Inadyn is a small and simple DDNS client with HTTPS support. It is commonly available in many GNU/Linux distributions, used in off-the-shelf routers and Internet gateways to automate the task of keeping your DNS record up to date with any IP address changes from your ISP. It can also be used in installations with redundant (backup) connections to the Internet."
PKG_DISCLAIMER="This is a community addon. Do therefore not expect support from OpenELEC forum and irc channel."
PKG_MAINTAINER="Anton Voyl (awiouy at gmail.com)"

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.service"
PKG_ADDON_PROVIDES=""
PKG_ADDON_REPOVERSION="7.0"

PKG_AUTORECONF="yes"
PKG_CONFIGURE_OPTS_TARGET="--enable-openssl" # --sysconfdir is ineffective

pre_configure_target() {
  # inadyn fails to build in subdirs
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
}

makeinstall_target() {
  :
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $PKG_BUILD/src/inadyn $ADDON_BUILD/$PKG_ADDON_ID/bin
}
