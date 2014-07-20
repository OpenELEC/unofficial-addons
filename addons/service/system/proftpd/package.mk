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

PKG_NAME="proftpd"
PKG_VERSION="1.3.4e"
PKG_REV="0"
PKG_ARCH="all"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://www.proftpd.org/"
PKG_URL="ftp://ftp.proftpd.org/distrib/source/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain ncurses libcap whois pcre libressl"
PKG_PRIORITY="optional"
PKG_SECTION="service/system"
PKG_SHORTDESC="Highly configurable GPL-licensed FTP server software"
PKG_LONGDESC="Secure and configurable FTP server with SSL/TLS support"

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.service"
PKG_AUTORECONF="no"

PKG_MAINTAINER="vpeter4 (peter.vicman@gmail.com)"

ADDON_DIR="/storage/.xbmc/addons/service.system.proftpd"

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
            --enable-openssl \
            --with-modules=mod_tls \
            --enable-nls \
            --localedir=$ADDON_DIR/locale \
            --enable-sendfile \
            --enable-facl \
            --enable-autoshadow \
            --enable-ctrls \
            --enable-ipv6 \
            --enable-nls \
            --enable-pcre \
            --enable-largefile"

pre_build_target() {
  mkdir -p $PKG_BUILD/.$TARGET_NAME
  cp -RP $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME
}

pre_configure_target() {
  export CFLAGS="$CFLAGS -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -I$SYSROOT_PREFIX/usr/include/ncurses -I$ROOT/$PKG_BUILD/.$TARGET_NAME/include/"
  export LDFLAGS="$LDFLAGS -L$ROOT/$PKG_BUILD/.$TARGET_NAME/lib"
}

makeinstall_target() {
  : # nop
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $PKG_BUILD/.$TARGET_NAME/proftpd   $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $PKG_BUILD/.$TARGET_NAME/ftpwho  $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $PKG_BUILD/.$TARGET_NAME/ftptop  $ADDON_BUILD/$PKG_ADDON_ID/bin

  cp $BUILD/whois*/mkpasswd $ADDON_BUILD/$PKG_ADDON_ID/bin

  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/locale
  cp $PKG_BUILD/.$TARGET_NAME/locale/* $ADDON_BUILD/$PKG_ADDON_ID/locale
}
