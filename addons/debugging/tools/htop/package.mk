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

PKG_NAME="htop"
PKG_VERSION="2.0.1"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://htop.sourceforge.net/"
PKG_URL="http://hisham.hm/htop/releases/$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain netbsd-curses"
PKG_PRIORITY="optional"
PKG_SECTION="debug/tools"
PKG_SHORTDESC="htop: Htop is an ncurses based interactive process viewer for Linux."
PKG_LONGDESC="Htop is an ncurses based interactive process viewer for Linux."

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROVIDES=""
PKG_ADDON_REPOVERSION="7.0"

PKG_AUTORECONF="yes"

PKG_MAINTAINER="unofficial.addon.pro"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_malloc_0_nonnull=yes \
            ac_cv_func_realloc_0_nonnull=yes \
            --enable-cgroup \
            --disable-vserver \
            --disable-unicode \
            --enable-proc \
            --disable-hwloc \
            --with-gnu-ld"

pre_configure_target() {
# htop fails to build in subdirs
  cd $ROOT/$PKG_BUILD
    rm -rf .$HOST_NAME
}

makeinstall_target() {
  : # nop
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -P $PKG_BUILD/htop $ADDON_BUILD/$PKG_ADDON_ID/bin
}
