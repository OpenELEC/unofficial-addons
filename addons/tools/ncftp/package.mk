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

PKG_NAME="ncftp"
PKG_VERSION="3.2.5"
PKG_REV="0"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.ncftp.com/ncftp/"
PKG_URL="ftp://ftp.ncftp.com/ncftp/ncftp-${PKG_VERSION}-src.tar.bz2"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_SHORTDESC="NcFTP Client (also known as just NcFTP) is a set of FREE application programs implementing the File Transfer Protocol (FTP)."
PKG_LONGDESC="NcFTP Client (also known as just NcFTP) is a set of FREE application programs implementing the File Transfer Protocol (FTP)."
PKG_DISCLAIMER="this is an unofficial addon. please don't ask for support in openelec forum / irc channel"

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROVIDES=""
PKG_ADDON_REPOVERSION="7.0"

PKG_AUTORECONF="no"

PKG_MAINTAINER="Stefan Saraev (seo at irc.freenode.net)"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_header_librtmp_rtmp_h=yes \
            --enable-readline \
            --disable-universal \
            --disable-ccdv \
            --without-curses"

pre_configure_target() {
  export CFLAGS="$CFLAGS -I../"
}

pre_build_target() {
  mkdir -p $PKG_BUILD/.$TARGET_NAME
  cp -RP $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME
}

makeinstall_target() {
  : # nop
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -P $PKG_BUILD/.$TARGET_NAME/bin/ncftp $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -P $PKG_BUILD/.$TARGET_NAME/bin/ncftpbatch $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -P $PKG_BUILD/.$TARGET_NAME/bin/ncftpget $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -P $PKG_BUILD/.$TARGET_NAME/bin/ncftpls $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -P $PKG_BUILD/.$TARGET_NAME/bin/ncftpput $ADDON_BUILD/$PKG_ADDON_ID/bin
}
