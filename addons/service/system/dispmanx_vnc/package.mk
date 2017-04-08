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

PKG_NAME="dispmanx_vnc"
PKG_ADDON_NAME="Raspberry Pi VNC"
PKG_VERSION="78e6673"
PKG_REV="2"
PKG_ARCH="arm"
PKG_LICENSE="OSS"
PKG_SITE="https://github.com/patrikolausson/dispmanx_vnc"
PKG_GIT_URL="https://github.com/patrikolausson/dispmanx_vnc.git"
PKG_GIT_BRANCH="master"
PKG_DEPENDS_TARGET="toolchain libvncserver bcm2835-firmware libconfig"
PKG_PRIORITY="optional"
PKG_SECTION="service/system"
PKG_SHORTDESC="VNC Server for Raspberry PI using dispmanx"
PKG_LONGDESC="VNC Server for Raspberry PI using dispmanx"
PKG_DISCLAIMER="this is an unofficial addon. please don't ask for support in openelec forum / irc channel"

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.service"
PKG_ADDON_PROVIDES=""
PKG_ADDON_PROJECTS="RPi RPi2"
PKG_ADDON_REPOVERSION="7.0"

PKG_AUTORECONF="no"

PKG_MAINTAINER="Lukas Rusak (lrusak at irc.freenode.net)"

pre_make_target() {
  export SYSROOT_PREFIX
}

makeinstall_target() {
  : # nop
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
    cp -p $PKG_BUILD/dispmanx_vncserver $ADDON_BUILD/$PKG_ADDON_ID/bin

  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/config
    cp $PKG_DIR/source/config/dispmanx_vncserver.conf $ADDON_BUILD/$PKG_ADDON_ID/config/
}
