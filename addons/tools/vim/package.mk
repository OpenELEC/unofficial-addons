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

PKG_NAME="vim"
PKG_VERSION="7.4.488"
PKG_REV="2"
PKG_ARCH="any"
PKG_LICENSE="VIM"
PKG_SITE="http://www.vim.org/"
PKG_URL="http://ftp.debian.org/debian/pool/main/v/vim/vim_$PKG_VERSION.orig.tar.gz"
PKG_DEPENDS_TARGET="toolchain ncurses"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_SHORTDESC="vim: VI IMproved"
PKG_LONGDESC="Vim is a highly configurable text editor built to enable efficient text editing. It is an improved version of the vi editor distributed with most UNIX systems."

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"

PKG_AUTORECONF="no"

PKG_MAINTAINER="Adam Michel (elfurbe)"

PKG_CONFIGURE_OPTS_TARGET="vim_cv_toupper_broken=no \
                           vim_cv_terminfo=yes \
                           vim_cv_tty_group=world \
                           vim_cv_tty_mode=0620 \
                           vim_cv_getcwd_broken=no \
                           vim_cv_stat_ignores_slash=yes \
                           vim_cv_memmove_handles_overlap=yes \
                           ac_cv_sizeof_int=4 \
                           ac_cv_small_wchar_t=no \
                           --enable-gui=no \
                           --with-compiledby=OpenELEC\
                           --with-tlib=ncurses \
                           --without-x"

makeinstall_target() {
  : # nothing to do here
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -P $PKG_BUILD/src/vim $ADDON_BUILD/$PKG_ADDON_ID/bin
}

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
}
