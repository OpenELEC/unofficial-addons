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

PKG_NAME="tvdb_api"
PKG_VERSION="1.10"
PKG_REV="0"
PKG_ARCH="any"
PKG_LICENSE="unlicense"
PKG_SITE="http://github.com/dbr/tvdb_api/tree/master"
PKG_URL="https://pypi.python.org/packages/source/t/$PKG_NAME/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python"
PKG_PRIORITY="optional"
PKG_SECTION="libs"
PKG_SHORTDESC="Interface to thetvdb.com"
PKG_LONGDESC="API interface to TheTVDB.com"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"
PKG_MAINTAINER="luivit (luivit39@gmail.com)"

makeinstall_target() {
  : # nop
}
make_target() {
 python setup.py build
}
