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

PKG_NAME="irssi"
PKG_VERSION="1.0.0"
PKG_REV="3"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.irssi.org/"
PKG_URL="https://github.com/irssi-import/irssi/releases/download/$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain glib netbsd-curses libressl"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_SHORTDESC="IRC client"
PKG_LONGDESC="Irssi is a terminal based IRC client for UNIX systems"
PKG_DISCLAIMER="this is an unofficial addon. please don't ask for support in openelec forum / irc channel"

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROVIDES=""
PKG_ADDON_REPOVERSION="7.0"

PKG_AUTORECONF="yes"

PKG_MAINTAINER="Stefan Saraev (seo at irc.freenode.net)"

PKG_CONFIGURE_OPTS_TARGET="--with-sysroot=$SYSROOT_PREFIX \
        --enable-ssl \
        --disable-glibtest \
        --without-socks \
        --with-textui \
        --without-bot \
        --without-proxy \
        --with-gc \
        --without-perl \
        --without-sco"

makeinstall_target() {
  : # nop
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -P $PKG_BUILD/.$TARGET_NAME/src/fe-text/irssi $ADDON_BUILD/$PKG_ADDON_ID/bin
}
