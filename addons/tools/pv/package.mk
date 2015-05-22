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

PKG_NAME="pv"
PKG_VERSION="1.6.0"
PKG_REV="0"
PKG_ARCH="any"
PKG_LICENSE="GNU"
PKG_SITE="http://www.ivarch.com/programs/pv.shtml"
PKG_URL="http://www.ivarch.com/programs/sources/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="tools"
PKG_PRIORITY="optional"
PKG_SHORTDESC="Pipe Viewer is a terminal-based tool for monitoring the progress of data through a pipeline"
PKG_LONGDESC="Pipe Viwer can be inserted into any normal pipeline between two processes to give a visual indication of how quickly data is passing through, how long it has taken, how near to completion it is, and an estimate of how long it will be until completion."

PKG_CONFIGURE_OPTS_TARGET="--enable-static-nls"

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROVIDES=""
PKG_ADDON_REPOVERSION="6.0"
PKG_AUTORECONF="no"
PKG_MAINTAINER="James White"

makeinstall_target() {
        : # nop
}

addon() {
        mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
        cp -P $PKG_BUILD/.$TARGET_NAME/pv $ADDON_BUILD/$PKG_ADDON_ID/bin
}

