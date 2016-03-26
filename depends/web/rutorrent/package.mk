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

PKG_NAME="rutorrent"
PKG_VERSION="3.6"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://rutorrent.googlecode.com/"
PKG_URL="http://dl.bintray.com/novik65/generic/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="$PKG_NAME"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SHORTDESC=""
PKG_LONGDESC=""

PKG_IS_ADDON="no"

PKG_AUTORECONF="no"

PKG_MAINTAINER="Daniel Forsberg (jenkins101)"

pre_patch() {
  chmod -R +w $ROOT/$BUILD/${PKG_NAME}-${PKG_VERSION}/*
}

make_target() {
  install_plugins="cpuload diskspace _getdir rss seedingtime data datadir erasedata scheduler extsearch httprpc ratio"

  # install some useful plugins
  for plugin in $install_plugins ;do
    echo "Installing rutorrent plugin: $plugin-$PKG_VERSION..."
    wget -q http://dl.bintray.com/novik65/generic/plugins/$plugin-$PKG_VERSION.tar.gz 
    tar zxf $plugin-$PKG_VERSION.tar.gz -C plugins/
    rm -f $plugin-$PKG_VERSION.tar.gz
  done

  echo "Installing rutorrent plugin: lbll-suite-0.8.1..."
  wget -q http://rutorrent-tadd-labels.googlecode.com/files/lbll-suite_0.8.1.tar.gz
  tar zxf lbll-suite_0.8.1.tar.gz -C plugins/
  rm -f lbll-suite_0.8.1.tar.gz
}

makeinstall_target() {
  : # nop
}
