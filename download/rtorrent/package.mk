###############################################################################
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

PKG_NAME="rtorrent"
PKG_VERSION="0.9.3"
PKG_REV="5"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://libtorrent.rakshasa.no"
PKG_URL="http://libtorrent.rakshasa.no/downloads/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libressl curl libtool pkg-config ncurses libtorrent zlib xmlrpc-c libsigc++"
PKG_PRIORITY="optional"
PKG_SECTION="service/downloadmanager"
PKG_SHORTDESC="rTorrent: a very fast, free BitTorrent client"
PKG_LONGDESC="rTorrent bittorrent client can handel multipel watch dirs and post actions. [CR][CR]After changing settings you need to disable and re-enable the addon. [CR][CR]Hove this addon is intended to work: [CR][CR]You add base dirs. [CR]torrents: /storage/downloads/torrents/ [CR]downloads: /storage/downloads [CR]comlete: /storege [CR][CR]then you add watch dirs separated by: ,[CR]videos,tvshows,music [CR][CR]Wath will happen then is: [CR][CR]Directorys while ve created if they dont exist: [CR]/storage/downloads/torrents/videos [CR]/storage/downloads/videos [CR]/storege/videos [CR][CR]then rtorrent while start dtached. [CR][CR]Now if you add a torrent file to: /storage/downloads/torrents/videos it while be downloaded to /storage/downloads/videos [CR][CR]On completion it while be Linked or Copyed to /storege/videos [CR][CR]The same for every watch dir added... [CR][CR]Nice ha..."
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_MAINTAINER="Daniel Forsberg (daniel.forsberg1@gmail.com)"

PKG_CONFIGURE_OPTS_TARGET="--disable-debug \
            --with-xmlrpc-c=$SYSROOT_PREFIX/usr/bin/xmlrpc-c-config \
            --with-gnu-ld"

makeinstall_target() {
  : # nop
}
