################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2015 Stephan Raue (stephan@openelec.tv)
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

PKG_NAME="sqlite"
PKG_VERSION="autoconf-3090000"
PKG_REV="0"
PKG_ARCH="any"
PKG_LICENSE="PublicDomain"
PKG_SITE="http://www.sqlite.org/"
PKG_URL="http://sqlite.org/2015/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_SHORTDESC="sqlite: An Embeddable SQL Database Engine"
PKG_LONGDESC="SQLite is a C library that implements an embeddable SQL database engine. Programs that link with the SQLite library can have SQL database access without running a separate RDBMS process. The distribution comes with a standalone command-line access program (sqlite) that can be used to administer an SQLite database and which serves as an example of how to use the SQLite library. SQLite is not a client library used to connect to a big database server. SQLite is the server. The SQLite library reads and writes directly to and from the database files on disk."

PKG_IS_ADDON="yes"
PKG_AUTORECONF="yes"

PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROVIDES=""
PKG_ADDON_REPOVERSION="6.0"

PKG_MAINTAINER="James White"

# The following has been taken from the sqlite OpenELEC source tree package.mk
# https://github.com/OpenELEC/OpenELEC.tv/blob/master/packages/databases/sqlite/package.mk

  CFLAGS=`echo $CFLAGS | sed -e "s|-Ofast|-O3|g"`
  CFLAGS=`echo $CFLAGS | sed -e "s|-ffast-math||g"`
  CFLAGS="$CFLAGS -DSQLITE_ENABLE_STAT3"
  CFLAGS="$CFLAGS -DSQLITE_ENABLE_COLUMN_METADATA=1"
  CFLAGS="$CFLAGS -DSQLITE_TEMP_STORE=3 -DSQLITE_DEFAULT_MMAP_SIZE=268435456"

pre_make_target() {
  # dont build parallel
  MAKEFLAGS=-j1
}

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
                           --disable-shared \
                           --disable-readline \
                           --enable-threadsafe \
                           --enable-dynamic-extensions \
                           --with-gnu-ld"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
}

makeinstall_target() {
        : # nop
}

addon() {
        mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
        cp -P $PKG_BUILD/.$TARGET_NAME/sqlite3 $ADDON_BUILD/$PKG_ADDON_ID/bin
}

