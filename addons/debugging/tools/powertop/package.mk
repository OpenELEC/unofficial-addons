################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2013 Dag Wieers (dag@wieers.com)
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

PKG_NAME="powertop"
PKG_VERSION="2.2"
PKG_REV="0"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://01.org/powertop/"
PKG_URL="https://01.org/powertop/sites/default/files/downloads/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET=""
PKG_BUILD_DEPENDS_TARGET="toolchain ncurses pciutils libnl"
PKG_PRIORITY="optional"
PKG_SECTION="debug/tools"
PKG_SHORTDESC="powertop: tool to diagnose issues with power consumption and power management"
PKG_LONGDESC="PowerTOP is a Linux tool to diagnose issues with power consumption and power management. In addition to being a diagnostic tool, PowerTOP also has an interactive mode where the user can experiment various power management settings for cases where the Linux distribution has not enabled these settings."

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"

PKG_AUTORECONF="yes"

PKG_MAINTAINER="Dag Wieers (dag@wieers.com)"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes"

pre_configure_target() {
  export CXXFLAGS="$CXXFLAGS -I$SYSROOT_PREFIX/usr/include/ncurses"
  export CFLAGS="$CFLAGS -I$SYSROOT_PREFIX/usr/include/ncurses"
}

makeinstall_target() {
  : # nop
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -P $PKG_BUILD/.$TARGET_NAME/src/powertop $ADDON_BUILD/$PKG_ADDON_ID/bin
}
