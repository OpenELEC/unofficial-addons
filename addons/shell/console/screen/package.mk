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

PKG_NAME="screen"
PKG_VERSION="4.3.1"
PKG_REV="0"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.gnu.org/software/screen/"
PKG_URL="http://ftp.gnu.org/gnu/screen/screen-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain netbsd-curses"
PKG_PRIORITY="optional"
PKG_SECTION="shell/console"
PKG_SHORTDESC="terminal multiplexor with VT100/ANSI terminal emulation"
PKG_LONGDESC="screen is a terminal multiplexor that runs several separate "screens" on a single physical character-based terminal. Each virtual terminal emulates a DEC VT100 plus several ANSI X3.64 and ISO 2022 functions. Screen sessions can be detached and resumed later on a different terminal."

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROVIDES=""
PKG_ADDON_REPOVERSION="8.0"

PKG_AUTORECONF="no"

PKG_MAINTAINER="unofficial.addon.pro"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_header_utempter_h=no \
                           --disable-pam \
                           --disable-use-locale \
                           --disable-telnet \
                           --disable-socket-dir"

pre_configure_target() {
  export LDFLAGS=`echo $LDFLAGS | sed -e "s|-Wl,--as-needed||"`

# screen fails to build in subdirs
  cd $ROOT/$PKG_BUILD
    rm -rf .$TARGET_NAME
}

makeinstall_target() {
  : # nop
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -P $PKG_BUILD/screen $ADDON_BUILD/$PKG_ADDON_ID/bin/screen
}
