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

PKG_NAME="SABnzbd-Suite"
PKG_VERSION="4.3"
PKG_REV="1"
# PKG_ARCH="i386 x86_64"
# DO NOT build. remove at Jan 1 2015 if noone steps as maintainer 
# TODO for the new maintainer: fix ssl, convert python deps to xbmc "module" addons
PKG_ARCH="none"
PKG_LICENSE="OSS"
PKG_SITE="http://www.openelec.tv"
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain Python SABnzbd SickBeard Headphones CouchPotatoServer"
PKG_PRIORITY="optional"
PKG_SECTION="service/downloadmanager"
PKG_SHORTDESC="SABnzbd-Suite is a Metapackage which combines SABnzbd, SickBeard, Couchpotato and Headphones in one Addon"
PKG_LONGDESC="SABnzbd-Suite makes Usenet as simple and streamlined as possible by automating everything we can. All you have to do is add a .nzb file. SABnzbd+ takes over from there, where it will be automatically downloaded, verified, repaired, extracted and filed away with zero human interaction."

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.service"
PKG_ADDON_REQUIRES="tools.unrar:0.0.0"

PKG_AUTORECONF="no"

PKG_MAINTAINER="unofficial.addon.pro"

make_target() {
  : # nop
}

makeinstall_target() {
  : # nop

}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $(get_build_dir par2cmdline)/.$TARGET_NAME/par2 $ADDON_BUILD/$PKG_ADDON_ID/bin

  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/pylib
  cp -R $(get_build_dir Cheetah)/.install_pkg/usr/lib/python*/site-packages/* $ADDON_BUILD/$PKG_ADDON_ID/pylib
  cp -R $(get_build_dir pyOpenSSL)/.install_pkg/usr/lib/python*/site-packages/* $ADDON_BUILD/$PKG_ADDON_ID/pylib
  cp -R $(get_build_dir yenc)/.install_pkg/usr/lib/python*/site-packages/* $ADDON_BUILD/$PKG_ADDON_ID/pylib
  cp -R $(get_build_dir configobj)/.install_pkg/usr/lib/python*/site-packages/* $ADDON_BUILD/$PKG_ADDON_ID/pylib

  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/SABnzbd
  cp -PR $(get_build_dir SABnzbd)/* $ADDON_BUILD/$PKG_ADDON_ID/SABnzbd

  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/SickBeard
  cp -PR $(get_build_dir SickBeard)/* $ADDON_BUILD/$PKG_ADDON_ID/SickBeard

  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/CouchPotatoServer
  cp -PR $(get_build_dir CouchPotatoServer)/* $ADDON_BUILD/$PKG_ADDON_ID/CouchPotatoServer

  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/Headphones
  cp -PR $(get_build_dir Headphones)/* $ADDON_BUILD/$PKG_ADDON_ID/Headphones
}
