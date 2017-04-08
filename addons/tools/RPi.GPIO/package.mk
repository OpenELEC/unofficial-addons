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

PKG_NAME="RPi.GPIO"
PKG_VERSION="0.6.3"
PKG_REV="3"
PKG_ARCH="arm"
PKG_LICENSE="MIT"
PKG_SITE="http://sourceforge.net/p/raspberry-gpio-python/"
PKG_URL="https://pypi.python.org/packages/e2/58/6e1b775606da6439fa3fd1550e7f714ac62aa75e162eed29dbec684ecb3e/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python distutilscross:host"
PKG_PRIORITY="optional"
PKG_SECTION="python"
PKG_SHORTDESC="A module to control Raspberry Pi GPIO channels"
PKG_LONGDESC="A module to control Raspberry Pi GPIO channels"
PKG_DISCLAIMER="this is an unofficial addon. please don't ask for support in openelec forum / irc channel"

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.module"
PKG_ADDON_PROVIDES=""
PKG_ADDON_PROJECTS="RPi RPi2"
PKG_ADDON_REPOVERSION="7.0"

PKG_AUTORECONF="no"

PKG_MAINTAINER="Lukas Rusak (lrusak at irc.freenode.net)"

pre_configure_target() {
  export CPPFLAGS="$TARGET_CPPFLAGS -I${SYSROOT_PREFIX}/usr/include/python2.7"
}

make_target() {
  python setup.py build
}

makeinstall_target() {
  : # nop
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/lib/RPi/
  cp -PR $PKG_BUILD/build/lib.linux-*/RPi/* $ADDON_BUILD/$PKG_ADDON_ID/lib/RPi
}
