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

PKG_NAME="powertop"
PKG_VERSION="2.8"
PKG_REV="2"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://01.org/powertop/"
PKG_URL="https://01.org/sites/default/files/downloads/powertop/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain netbsd-curses pciutils libnl"
PKG_PRIORITY="optional"
PKG_SECTION="debug/tools"
PKG_SHORTDESC="powertop: tool to diagnose issues with power consumption and power management"
PKG_LONGDESC="PowerTOP is a Linux tool to diagnose issues with power consumption and power management. In addition to being a diagnostic tool, PowerTOP also has an interactive mode where the user can experiment various power management settings for cases where the Linux distribution has not enabled these settings."

#PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROVIDES=""
PKG_ADDON_REPOVERSION="7.0"

PKG_AUTORECONF="yes"

PKG_MAINTAINER="Dag Wieers (dag@wieers.com)"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes"

pre_configure_target() {
  export CXXFLAGS="$CXXFLAGS -I$SYSROOT_PREFIX/usr/include/ncurses"
  export CFLAGS="$CFLAGS -I$SYSROOT_PREFIX/usr/include/ncurses"
  export LDFLAGS="$LDFLAGS -ludev"
}

makeinstall_target() {
  : # nop
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -P $PKG_BUILD/.$TARGET_NAME/src/powertop $ADDON_BUILD/$PKG_ADDON_ID/bin
}
