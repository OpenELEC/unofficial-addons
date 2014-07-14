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

PKG_NAME="libtorrent"
PKG_VERSION="0.13.3"
PKG_REV="2"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://libtorrent.rakshasa.no"
PKG_URL="http://libtorrent.rakshasa.no/downloads/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libressl curl libtool pkg-config ncurses libsigc++"
PKG_PRIORITY="optional"
PKG_SHORTDESC=""
PKG_LONGDESC=""
PKG_IS_ADDON="no"

PKG_AUTORECONF="yes"

PKG_MAINTAINER="Daniel Forsberg (daniel.forsberg1@gmail.com)"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
            --enable-static \
            --enable-aligned \
	    --disable-debug \
	    --without-kqueue \
	    --with-posix-fallocate"
