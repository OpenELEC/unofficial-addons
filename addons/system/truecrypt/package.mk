################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2012-2013 ultraman
#      Copyright (C) 2012 smory
#      Copyright (C) 2009-2017 Stephan Raue (stephan@openelec.tv)
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

PKG_NAME="truecrypt"
PKG_VERSION="7.1a"
PKG_REV="2"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.truecrypt.org"
PKG_URL="http://fossies.org/linux/misc/TrueCrypt-$PKG_VERSION-Source.tar.gz"
PKG_DEPENDS_TARGET="toolchain fuse util-linux LVM2 wxWidgets ntfs-3g_ntfsprogs"
PKG_PRIORITY="optional"
PKG_SECTION="plugin/program"
PKG_SHORTDESC="Mount TrueCrypt Files."
PKG_LONGDESC="Manage Truecrypt files within XBMC. Up to 10 containers are supported. It's possible to mount, unmount, format, delete and create new files."

PKG_AUTORECONF="no"

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROVIDES=""
PKG_ADDON_NAME="TrueCrypt"
PKG_ADDON_REPOVERSION="7.0"

PKG_MAINTAINER="vpeter4 (peter.vicman@gmail.com) and smory (smoradap@gmail.com)"

pre_unpack() {
  TC_PKG="`echo $PKG_URL | sed 's%.*/\(.*\)$%\1%' | sed 's|%20| |g'`"
  SRC_ARCHIVE=$(readlink -f $SOURCES/$PKG_NAME/$TC_PKG)
  cd $ROOT/$BUILD
  tar xzf "$SRC_ARCHIVE"
  mv ${PKG_NAME}-${PKG_VERSION}-source ${PKG_NAME}-${PKG_VERSION}
  cd -
}

pre_configure_target() {
  # wxWidgets fails to build with LTO
  strip_lto
}

make_target() {
  # TODO: what? fix this.
  # use our strip
  sed -i 's|strip $(APPNAME)|$(STRIP) $(APPNAME)|' Main/Main.make

  WX_ROOT=$(get_build_dir wxWidgets)
  WX_BUILD_DIR=$WX_ROOT/wxrelease

  # enable environment WX_CONFIGURE_FLAGS
  sed -i 's|WX_CONFIGURE_FLAGS :=|WX_CONFIGURE_FLAGS +=|' Makefile

  # make wxWidgets library
  if [ ! -d "$WX_BUILD_DIR" ]; then
    WX_CONFIGURE_FLAGS="--host=$TARGET_NAME --build=$HOST_NAME" \
    make wxbuild \
         NOGUI=1 \
         WX_ROOT=$WX_ROOT \
         WX_BUILD_DIR=$WX_BUILD_DIR
  fi

  WX_LIBS=$($WX_BUILD_DIR/wx-config --libs)

  # make truecrypt binary
  make NOGUI=1 \
     WXSTATIC=1 \
     NOTEST=1 \
     NOASM=1 \
     PKCS11_INC=$PKG_DIR/pkcs11 \
     WX_ROOT=$WX_ROOT \
     WX_BUILD_DIR=$WX_BUILD_DIR \
     WX_CONFIG=$WX_BUILD_DIR/wx-config \
     WX_LIBS="$WX_LIBS -lrt"
}

makeinstall_target() {
  : # nop
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $PKG_BUILD/Main/truecrypt $ADDON_BUILD/$PKG_ADDON_ID/bin/
  # TODO remove. losetup is now in openelec
  #cp $(get_build_dir util-linux)/.install_pkg/usr/sbin/losetup $ADDON_BUILD/$PKG_ADDON_ID/bin/
  cp $(get_build_dir ntfs-3g_ntfsprogs)/.$TARGET_NAME/ntfsprogs/mkntfs $ADDON_BUILD/$PKG_ADDON_ID/bin/
  cp $(get_build_dir LVM2)/.install_pkg/usr/sbin/dmsetup $ADDON_BUILD/$PKG_ADDON_ID/bin/dmsetup

  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp $(get_build_dir LVM2)/.install_pkg/usr/lib/libdevmapper.so.1.02 $ADDON_BUILD/$PKG_ADDON_ID/lib
}
