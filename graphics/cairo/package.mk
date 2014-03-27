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

PKG_NAME="cairo"
PKG_VERSION="1.12.16"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="LGPL"
PKG_SITE="http://cairographics.org/"
PKG_URL="http://cairographics.org/releases/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain zlib freetype fontconfig libpng pixman libXrender libX11 Mesa glu"
PKG_PRIORITY="optional"
PKG_SECTION="graphics"
PKG_SHORTDESC="cairo: Multi-platform 2D graphics library"
PKG_LONGDESC="Cairo is a vector graphics library with cross-device output support. Currently supported output targets include the X Window System and in-memory image buffers. PostScript and PDF file output is planned. Cairo is designed to produce identical output on all output media while taking advantage of display hardware acceleration when available."
PKG_IS_ADDON="no"

PKG_AUTORECONF="no" # ToDo

PKG_MAINTAINER="none"

PKG_CONFIGURE_OPTS_TARGET="--x-includes="$SYSROOT_PREFIX/usr/include" \
            --x-libraries="$SYSROOT_PREFIX/usr/lib" \
            --disable-silent-rules \
            --enable-shared \
            --disable-static \
            --disable-gtk-doc \
            --enable-largefile \
            --enable-atomic \
            --disable-gcov \
            --disable-valgrind \
            --enable-xlib \
            --enable-xlib-xrender \
            --disable-xcb \
            --disable-xlib-xcb \
            --disable-xcb-shm \
            --disable-qt \
            --disable-quartz \
            --disable-quartz-font \
            --disable-quartz-image \
            --disable-win32 \
            --disable-win32-font \
            --disable-skia \
            --disable-os2 \
            --disable-beos \
            --disable-glesv2 \
            --disable-cogl \
            --disable-drm \
            --disable-drm-xr \
            --disable-gallium \
            --disable-xcb-drm \
            --enable-png \
            --enable-gl \
            --disable-directfb \
            --disable-vg \
            --disable-egl \
            --enable-glx \
            --disable-wgl \
            --disable-script \
            --enable-ft \
            --enable-fc \
            --enable-ps \
            --enable-pdf \
            --enable-svg \
            --disable-test-surfaces \
            --disable-tee \
            --disable-xml \
            --enable-pthread \
            --disable-gobject \
            --disable-full-testing \
            --disable-trace \
            --enable-interpreter \
            --disable-symbol-lookup \
            --enable-some-floating-point \
            --with-gnu-ld \
            --with-x"
