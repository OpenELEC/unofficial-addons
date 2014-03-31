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

PKG_NAME="dvb-apps"
PKG_VERSION="20090201"
PKG_REV="0"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.linuxtv.org"
PKG_URL="http://sources.openbricks.org/devel/dvb-apps-${PKG_VERSION}.tar.bz2"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_SHORTDESC="Digitial Video Broadcasting (DVB) applications"
PKG_LONGDESC="Applications and utilities geared towards the initial setup, testing and operation of an DVB device supporting the DVB-S, DVB-C, DVB-T, and ATSC standards."
PKG_DISCLAIMER="this is an unofficial addon. please don't ask for support in openelec forum / irc channel"

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"

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
