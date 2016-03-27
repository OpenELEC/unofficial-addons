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

PKG_NAME="nfs-utils"
PKG_VERSION="1.3.3"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://linux-nfs.org/wiki/index.php/Main_Page"
PKG_URL="http://sourceforge.net/projects/nfs/files/$PKG_NAME/$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libevent libnfsidmap"
PKG_PRIORITY="optional"
PKG_SECTION="network"
PKG_SHORTDESC="The Linux NFS utility package"
PKG_LONGDESC="The Linux NFS utility package"
PKG_DISCLAIMER="this is an unofficial addon. please don't ask for support in openelec forum / irc channel"

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROVIDES=""
PKG_ADDON_REPOVERSION="7.0"

PKG_AUTORECONF="yes"

PKG_MAINTAINER="Lukas Rusak (lrusak at irc.freenode.net)"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
                           --enable-static \
                           --with-sysroot=$SYSROOT_PREFIX \
                           --disable-nfsv41 \
                           --disable-gss \
                           --disable-uuid \
                           --disable-tirpc \
                           --disable-ipv6 \
                           --disable-nfsdcltrack \
                           --without-tcp-wrappers"

pre_configure_target() {
  # nfs-utils fails to build in subdirs
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME

  strip_gold

  LDFLAGS="$LDFLAGS -static -lnfsidmap"
}

makeinstall_target() {
  : # nop
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
      cp -p $ROOT/$PKG_BUILD/utils/mount/mount.nfs $ADDON_BUILD/$PKG_ADDON_ID/bin/mount.nfs4
}
