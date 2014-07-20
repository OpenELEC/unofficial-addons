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

PKG_NAME="x11vnc"
PKG_VERSION="0.9.13"
PKG_REV="0"
PKG_ARCH="i386 x86_64"
PKG_LICENSE="OSS"
PKG_SITE="http://www.karlrunge.com/x11vnc/"
PKG_URL="http://downloads.sourceforge.net/project/libvncserver/x11vnc/${PKG_VERSION}/x11vnc-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain libX11 libXext libXtst libjpeg-turbo"
PKG_PRIORITY="optional"
PKG_SECTION="service/system"
PKG_SHORTDESC="x11vnc allows one to view remotely and interact with real X displays"
PKG_LONGDESC="x11vnc allows one to view remotely and interact with real X displays"
PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.service"

PKG_AUTORECONF="yes"

PKG_MAINTAINER="Stefan Saraev (seo at irc.freenode.net)"

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
      --with-x11vnc \
      --with-x \
      --without-xkeyboard \
      --without-xinerama \
      --without-xrandr \
      --without-xfixes \
      --without-xdamage \
      --without-xtrap \
      --without-xrecord \
      --without-fbpm \
      --without-dpms \
      --without-v4l \
      --without-fbdev \
      --without-uinput \
      --without-macosx-native \
      --without-crypt \
      --without-crypto \
      --without-ssl \
      --without-avahi \
      --with-jpeg \
      --without-libz \
      --with-zlib \
      --without-gnutls \
      --without-client-tls"

pre_build_target() {
  mkdir -p $PKG_BUILD/.$TARGET_NAME
  cp -RP $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME
}

makeinstall_target() {
  : # nop
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $PKG_BUILD/.$TARGET_NAME/x11vnc/x11vnc $ADDON_BUILD/$PKG_ADDON_ID/bin
}
