################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
#      Copyright (C) 2012-2013 ultraman
#      Copyright (C) 2012 smory
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

PKG_NAME="truecrypt"
PKG_VERSION="7.1a"
PKG_CUSTOM_ADDON_VERSION="3.5.9"
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
PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_AUTORECONF="no"
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
  cp $(get_build_dir util-linux)/.$TARGET_NAME/losetup $ADDON_BUILD/$PKG_ADDON_ID/bin/
  cp $(get_build_dir ntfs-3g_ntfsprogs)/.$TARGET_NAME/ntfsprogs/mkntfs $ADDON_BUILD/$PKG_ADDON_ID/bin/
  cp $(get_build_dir LVM2)/.$TARGET_NAME/tools/dmsetup $ADDON_BUILD/$PKG_ADDON_ID/bin/dmsetup
}
