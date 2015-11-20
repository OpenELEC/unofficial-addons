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
PKG_VERSION="a061e0a"
PKG_REV="0"
PKG_ARCH="arm"
PKG_LICENSE="OSS"
PKG_SITE="https://github.com/hanzelpeter/dispmanx_vnc"
PKG_URL="$DISTRO_SRC/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain libvncserver bcm2835-driver"
PKG_PRIORITY="optional"
PKG_SECTION="service/system"
PKG_SHORTDESC="VNC Server for Raspberry PI using dispmanx"
PKG_LONGDESC="VNC Server for Raspberry PI using dispmanx"
PKG_DISCLAIMER="this is an unofficial addon. please don't ask for support in openelec forum / irc channel"

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.service"
PKG_ADDON_PROVIDES=""
PKG_ADDON_PROJECTS="RPi RPi2"
PKG_ADDON_REPOVERSION="6.0"

PKG_AUTORECONF="no"

PKG_MAINTAINER="Lukas Rusak (lrusak at irc.freenode.net)"

make_target() {  
  $CC $CFLAGS main.c -o dispmanx_vncserver -DHAVE_LIBBCM_HOST \
                                           -DUSE_EXTERNAL_LIBBCM_HOST \
                                           -DUSE_VCHIQ_ARM \
                                           $LDFLAGS \
                                           -I$SYSROOT_PREFIX/include \
                                           -I$SYSROOT_PREFIX/usr/include \
                                           -I$SYSROOT_PREFIX/usr/include/interface/vcos/pthreads \
                                           -I$SYSROOT_PREFIX/usr/include/interface/vmcs_host \
                                           -I$SYSROOT_PREFIX/usr/include/interface/vmcs_host/linux \
                                           -L$SYSROOT_PREFIX/usr/lib \
                                           -L$SYSROOT_PREFIX/lib \
                                           -lGLESv2 \
                                           -lEGL \
                                           -lopenmaxil \
                                           -lbcm_host \
                                           -lvcos \
                                           -lvchiq_arm \
                                           -lpthread \
                                           -lrt \
                                           -lz \
                                           -lssl -lcrypto \
                                           -lresolv \
                                           -lvncserver \
                                           -ljpeg -lpng16
}

makeinstall_target() {
  : # nop
}

addon() {
  mkdir -p $ROOT/$ADDON_BUILD/$PKG_ADDON_ID/bin
    cp -p $ROOT/$PKG_BUILD/dispmanx_vncserver $ROOT/$ADDON_BUILD/$PKG_ADDON_ID/bin
}
