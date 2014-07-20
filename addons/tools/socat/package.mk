################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.tv; see the file COPYING.  If not, write to
#  the Free Software Foundation, 51 Franklin Street, Suite 500, Boston, MA 02110, USA.
#  http://www.gnu.org/copyleft/gpl.html
################################################################################

PKG_NAME="socat"
PKG_VERSION="1.7.2.4"
PKG_REV="0"
PKG_ARCH="any"
PKG_LICENSE="GPL2"
PKG_SITE="http://www.dest-unreach.org/socat/"
PKG_URL="http://www.dest-unreach.org/socat/download/${PKG_NAME}-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain libressl"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_SHORTDESC="Multipurpose relay"
PKG_LONGDESC="socat is a relay for bidirectional data transfer between two independent data channels"

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"

PKG_AUTORECONF="no"

PKG_MAINTAINER="Stefan Saraev (seo at irc.freenode.net)"

PKG_CONFIGURE_OPTS_TARGET="--disable-sctp \
            --disable-help \
            --disable-udp \
            --disable-socks4 \
            --disable-socks4a \
            --disable-proxy \
            --disable-readline \
            --disable-tun \
            --disable-filan \
            --disable-sycls"

pre_configure_target() {
  ( cd ..; do_autoreconf --exclude=autoheader )
}

makeinstall_target() {
  : # nop
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $PKG_BUILD/.$TARGET_NAME/socat $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $PKG_BUILD/.$TARGET_NAME/procan $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $PKG_BUILD/.$TARGET_NAME/filan $ADDON_BUILD/$PKG_ADDON_ID/bin
}
