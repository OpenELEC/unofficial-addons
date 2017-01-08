################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2013 Dag Wieers (dag@wieers.com)
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

PKG_NAME="iftop"
PKG_VERSION="1.0pre4"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://htop.sourceforge.net/"
PKG_URL="http://www.ex-parrot.com/pdw/iftop/download/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain netbsd-curses libpcap libnl"
PKG_PRIORITY="optional"
PKG_SECTION="network/analyzer"
PKG_SHORTDESC="iftop: display bandwidth usage on an interface"
PKG_LONGDESC="iftop does for network usage what top(1) does for CPU usage. It listens to network traffic on a named interface and displays a table of current bandwidth usage by pairs of hosts. Handy for answering the question 'why is our ADSL link so slow?'."

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROVIDES=""
PKG_ADDON_REPOVERSION="7.0"

PKG_AUTORECONF="yes"

PKG_MAINTAINER="unofficial.addon.pro"

pre_build_target() {
  mkdir -p $PKG_BUILD/.$TARGET_NAME
  cp -RP $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME
}

pre_configure_target() {
  export CFLAGS="$CFLAGS -I$SYSROOT_PREFIX/usr/include/pcap"
  export LIBS="-lpcap -lnl-3 -lnl-genl-3 -lncurses -lterminfo"
}

makeinstall_target() {
  : # nop
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $PKG_BUILD/.$TARGET_NAME/iftop $ADDON_BUILD/$PKG_ADDON_ID/bin
}
