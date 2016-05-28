################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
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

PKG_NAME="tvnamer"
PKG_VERSION="2.3"
PKG_REV="0"
PKG_ARCH="any"
PKG_LICENSE="unlicense"
PKG_SITE="http://github.com/dbr/tvnamer"
PKG_URL="https://pypi.python.org/packages/source/t/$PKG_NAME/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python tvdb_api"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_SHORTDESC="Automatic TV episode namer/mover"
PKG_LONGDESC="Automatically names downloaded/recorded TV-episodes, by parsing filenames and retrieving show-names from www.thetvdb.com."
PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_AUTORECONF="no"
PKG_MAINTAINER="luivit/dbr"
PKG_ADDON_REPOVERSION="8.0"

make_target() {
 python setup.py build
}

makeinstall_target() {
 : # nop
}

addon() {
 mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/resources/lib/
 cp -R $PKG_BUILD/build/lib/tvnamer $ADDON_BUILD/$PKG_ADDON_ID/resources/lib/tvnamer
 cp $(get_build_dir tvdb_api)/build/lib/* $ADDON_BUILD/$PKG_ADDON_ID/resources/lib/tvnamer
}
