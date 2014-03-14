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

PKG_NAME="nss"
PKG_VERSION="3.15.5"
PKG_REV="1"
PKG_ARCH="i386 x86_64"
PKG_LICENSE="Mozilla Public License"
PKG_SITE="http://ftp.mozilla.org/"
PKG_URL="http://ftp.mozilla.org/pub/mozilla.org/security/nss/releases/NSS_3_15_5_RTM/src/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain nss:host nspr"
PKG_PRIORITY="optional"
PKG_SECTION="security"
PKG_SHORTDESC="The Network Security Services (NSS) package is a set of libraries designed to support cross-platform development of security-enabled client and server applications"
PKG_LONGDESC="The Network Security Services (NSS) package is a set of libraries designed to support cross-platform development of security-enabled client and server applications"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_MAINTAINER="vpeter4 (peter.vicman@gmail.com)"

MAKEFLAGS=-j1

make_host() {
  cd $ROOT/$PKG_BUILD/nss

  [ "`uname -m`" = "x86_64" ] && HOST_USE_64="USE_64=1"

  # make host part for nsinstall binary and created library signatures
  make -C coreconf/nsinstall $HOST_USE_64 \
     USE_SYSTEM_ZLIB=1 ZLIB_LIBS=-lz \
     V=1

  # save library signatures to be used on target
  #find ./ -name "lib*.chk" -exec cp {} $ROOT/$PKG_BUILD/dist/ \;
}

makeinstall_host() {
  cp $ROOT/$PKG_BUILD/nss/coreconf/nsinstall/Linux*_DBG.OBJ/nsinstall $ROOT/$TOOLCHAIN/bin
}

post_makeinstall_host() {
  # clean up host part
  rm -rf `find  $ROOT/$PKG_BUILD/nss -type d -name Linux*_DBG.OBJ`
}

make_target() {
  cd $ROOT/$PKG_BUILD/nss

  [ "$TARGET_ARCH" = "x86_64" ] && TARGET_USE_64="USE_64=1"

  #strip_lto

  make BUILD_OPT=1 $TARGET_USE_64 \
     NSPR_INCLUDE_DIR=$SYSROOT_PREFIX/usr/include/nspr \
     USE_SYSTEM_ZLIB=1 ZLIB_LIBS=-lz \
     OS_TEST=$TARGET_ARCH \
     NSS_TESTS="dummy" \
     NSINSTALL=$ROOT/$TOOLCHAIN/bin/nsinstall \
     CPU_ARCH_TAG=$TARGET_ARCH \
     CC=$TARGET_CC LDFLAGS="$LDFLAGS -L$SYSROOT_PREFIX/usr/lib" \
     V=1
}

makeinstall_target() {
  cd $ROOT/$PKG_BUILD
  $STRIP dist/Linux*/lib/*.so
  cp -L dist/Linux*/lib/*.so $SYSROOT_PREFIX/usr/lib
  cp -L dist/Linux*/lib/libcrmf.a $SYSROOT_PREFIX/usr/lib
  mkdir -p $SYSROOT_PREFIX/usr/include/nss
  cp -RL dist/{public,private}/nss/* $SYSROOT_PREFIX/usr/include/nss
  cp -L dist/Linux*/lib/pkgconfig/nss.pc $SYSROOT_PREFIX/usr/lib/pkgconfig
}
