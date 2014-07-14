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

PKG_NAME="php"
PKG_VERSION="5.5.14"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OpenSource"
PKG_SITE="http://www.php.net"
PKG_URL="http://www.php.net/distributions/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain zlib pcre curl openssl"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_SHORTDESC="php: Scripting language especially suited for Web development"
PKG_LONGDESC="PHP is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML."

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_MAINTAINER="none"

PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--disable-all \
                           --without-pear \
                           --with-config-file-path=/storage/.xbmc/userdata/addon_data/tools.php/etc \
                           --localstatedir=/var \
                           --disable-cli \
                           --enable-cgi \
                           --disable-sockets \
                           --enable-posix \
                           --disable-spl \
                           --disable-session \
                           --with-openssl=$SYSROOT_PREFIX/usr \
                           --disable-libxml \
                           --disable-xml \
                           --disable-xmlreader \
                           --disable-xmlwriter \
                           --disable-simplexml \
                           --with-zlib=$SYSROOT_PREFIX/usr \
                           --disable-exif \
                           --disable-ftp \
                           --without-gettext \
                           --without-gmp \
                           --enable-json \
                           --without-readline \
                           --disable-pcntl \
                           --disable-sysvmsg \
                           --disable-sysvsem \
                           --disable-sysvshm \
                           --disable-zip \
                           --disable-filter \
                           --disable-calendar \
                           --with-curl=$SYSROOT_PREFIX/usr \
                           --with-pcre-regex \
                           --without-sqlite3 \
                           --disable-pdo \
                           --without-pdo-sqlite \
                           --without-pdo-mysql"

makeinstall_target() {
  : # nothing to install
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
    cp $PKG_BUILD/.$TARGET_NAME/sapi/cgi/php-cgi $ADDON_BUILD/$PKG_ADDON_ID/bin/php-cgi
}
