################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
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

PKG_NAME="jq"
PKG_VERSION="1.5"
PKG_REV="0"
PKG_ARCH="any"
PKG_LICENSE="MIT"
PKG_SITE="http://stedolan.github.io/jq/"
PKG_URL="http://github.com/stedolan/jq/releases/download/$PKG_NAME-$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_SHORTDESC="jq is a command-line JSON processor"
PKG_LONGDESC="jq is like sed for JSON data – you can use it to slice and filter and map and transform structured data with the same ease that sed, awk, grep and friends let you play with text."

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROVIDES=""
PKG_ADDON_REPOVERSION="8.0"

PKG_AUTORECONF="yes"

PKG_MAINTAINER="James White"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \ 
                           --enable-static \
                           --disable-maintainer-mode"

makeinstall_target() {
	: # nop
}

addon() {
	mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
	cp -P $PKG_BUILD/.$TARGET_NAME/jq $ADDON_BUILD/$PKG_ADDON_ID/bin
}
