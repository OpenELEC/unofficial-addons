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

PKG_NAME="rTorrent"
PKG_VERSION="4.3"
PKG_REV="2"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://libtorrent.rakshasa.no"
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain libressl curl ncurses libtorrent zlib xmlrpc-c rutorrent miniupnpc rtorrent"
PKG_PRIORITY="optional"
PKG_SECTION="service/downloadmanager"
PKG_SHORTDESC="rTorrent: This is the free BitTorrent client rtorrent packed for OpenELEC"
PKG_LONGDESC="rTorrent BitTorrent client can handel multipel watch dirs and post actions. [CR][CR]After changing settings you need to disable and re-enable the addon. [CR][CR]Hove this addon is intended to work: [CR][CR]You add base dirs. [CR]torrents: /storage/downloads/torrents/ [CR]downloads: /storage/downloads [CR]comlete: /storege [CR][CR]then you add watch dirs separated by: ,[CR]videos,tvshows,music [CR][CR]Wath will happen then is: [CR][CR]Directorys while be created if they dont exist: [CR]/storage/downloads/torrents/videos [CR]/storage/downloads/videos [CR]/storege/videos [CR][CR]then rtorrent while start dtached. [CR][CR]Now if you add a torrent file to: /storage/downloads/torrents/videos it while be downloaded to /storage/downloads/videos [CR][CR]On completion it while be Linked or Moved to /storege/videos [CR][CR]The same for every watch dir added... [CR][CR]Nice ha..."

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.service"
PKG_ADDON_REQUIRES="tools.php:0.0.0 tools.dtach:0.0.0"

PKG_AUTORECONF="no"

PKG_MAINTAINER="Daniel Forsberg (daniel.forsberg1@gmail.com)"

make_target() {
  : # nop
}

makeinstall_target() {
  : # nop
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $(get_build_dir rtorrent)/.$TARGET_NAME/src/rtorrent $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $(get_build_dir miniupnpc)/upnpc-static $ADDON_BUILD/$PKG_ADDON_ID/bin/upnpc

  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp $LIB_PREFIX/lib/libxmlrpc_util.so.[0-9] $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp $LIB_PREFIX/lib/libxmlrpc_server.so.[0-9] $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp $LIB_PREFIX/lib/libxmlrpc.so.[0-9] $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp $LIB_PREFIX/lib/libsigc*.so.[0-9] $ADDON_BUILD/$PKG_ADDON_ID/lib

  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/rutorrent/
  cp -r $(get_build_dir rutorrent)/* $ADDON_BUILD/$PKG_ADDON_ID/rutorrent/

  cp $PKG_DIR/extra/rtorrent.default.rc $ADDON_BUILD/$PKG_ADDON_ID/rtorrent.default.rc
}
