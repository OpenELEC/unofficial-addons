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

PKG_NAME="hddtemp"
PKG_VERSION="0.3-beta15"
PKG_REV="0"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.guzu.net/linux/hddtemp.php"
PKG_URL="http://download.savannah.gnu.org/releases/hddtemp/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET=""
PKG_BUILD_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="debug/tools"
PKG_SHORTDESC="hddtemp: tool that reports hard drive temperature"
PKG_LONGDESC="hddtemp is a small utility (daemonizable) that gives you the temperature of your hard drive by reading S.M.A.R.T. informations (for drives that support this feature)."

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"

PKG_AUTORECONF="no"

PKG_MAINTAINER="Dag Wieers (dag@wieers.com)"

PKG_CONFIGURE_OPTS_TARGET="--with-db-path=/storage/.xbmc/addons/debug.tools.hddtemp/hddtemp.db"

makeinstall_target() {
  : # nop
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -P $PKG_BUILD/.$TARGET_NAME/src/hddtemp $ADDON_BUILD/$PKG_ADDON_ID/bin
}
