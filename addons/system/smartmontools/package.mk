################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2013 Peter Smorada (smoradap@gmail.com)
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

PKG_NAME="smartmontools"
PKG_VERSION="6.5"
PKG_REV="2"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://smartmontools.sourceforge.net"
PKG_URL="http://download.sourceforge.net/$PKG_NAME/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="plugin/program"
PKG_SHORTDESC="S.M.A.R.T. disk monitoring tool with XBMC gui."
PKG_LONGDESC="S.M.A.R.T. disk monitoring tool with XBMC gui. This version is based on smartmontools v 6.2."
PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROVIDES=""
PKG_ADDON_REPOVERSION="7.0"
PKG_AUTORECONF="yes"
PKG_MAINTAINER="Peter Smorada (smoradap@gmail.com)"

makeinstall_target() {
  : # nop
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $PKG_BUILD/.$TARGET_NAME/smartctl $ADDON_BUILD/$PKG_ADDON_ID/bin/smartctl
  cp $PKG_BUILD/.$TARGET_NAME/smartd $ADDON_BUILD/$PKG_ADDON_ID/bin/smartd
}
