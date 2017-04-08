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

PKG_NAME="dvb-apps"
PKG_VERSION="3d43b28"
PKG_REV="0"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://www.linuxtv.org/wiki/index.php/LinuxTV_dvb-apps"
PKG_URL="$DISTRO_SRC/dvb-apps-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_SHORTDESC="Digitial Video Broadcasting (DVB) applications"
PKG_LONGDESC="Applications and utilities geared towards the initial setup, testing and operation of an DVB device supporting the DVB-S, DVB-C, DVB-T, and ATSC standards."
PKG_DISCLAIMER="this is an unofficial addon. please don't ask for support in openelec forum / irc channel"

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROVIDES=""
PKG_ADDON_REPOVERSION="7.0"

PKG_AUTORECONF="no"

PKG_MAINTAINER="Stefan Saraev (seo at irc.freenode.net)"

make_target() {
  make -C lib
  make -C util
}

makeinstall_target() {
  : # nop
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $PKG_BUILD/util/dvbdate/dvbdate $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $PKG_BUILD/util/dvbnet/dvbnet $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $PKG_BUILD/util/dvbscan/dvbscan $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $PKG_BUILD/util/dvbtraffic/dvbtraffic $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $PKG_BUILD/util/femon/femon $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $PKG_BUILD/util/scan/scan $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $PKG_BUILD/util/szap/azap $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $PKG_BUILD/util/szap/czap $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $PKG_BUILD/util/szap/szap $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $PKG_BUILD/util/szap/tzap $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $PKG_BUILD/util/zap/zap $ADDON_BUILD/$PKG_ADDON_ID/bin
}
