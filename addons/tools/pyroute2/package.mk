################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2015 Anton Voyl (awiouy@gmail.com)
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

PKG_NAME="pyroute2"
PKG_VERSION="0.3.4"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_SITE="http://docs.pyroute2.org/"
PKG_URL="https://github.com/svinota/$PKG_NAME/releases/download/$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.gz"

PKG_SHORTDESC="pyroute2, a pure Python netlink and Linux network configuration library"
PKG_LONGDESC="pyroute2 is a pure Python netlink and Linux network configuration library. It requires only Python stdlib, no 3rd party libraries. Later it can change, but the deps tree will remain as simple, as it is possible."
PKG_DISCLAIMER="This is an unofficial addon. Do therefore not expect support from OpenELEC forum and irc channel."
PKG_MAINTAINER="Anton Voyl (awiouy@gmail.com)"

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.module"
PKG_SECTION="tools"

PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_AUTORECONF="no"

pre_make_target() {
  export PYTHONXCPREFIX="$SYSROOT_PREFIX/usr"
}

make_target() {
  python setup.py build
}

makeinstall_target() {
  :
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -R $PKG_BUILD/build/lib/pyroute2/. $ADDON_BUILD/$PKG_ADDON_ID/lib
}
