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

PKG_NAME="chromium-browser"
PKG_VERSION="28.0.1500.52"
PKG_REV="2"
PKG_ARCH="x86_64"
PKG_LICENSE="Mixed"
PKG_SITE="http://www.chromium.org/Home"
PKG_URL="$DISTRO_SRC/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain gtk+ pciutils dbus libXcomposite libXcursor libXtst alsa-lib bzip2 yasm nss"
PKG_PRIORITY="optional"
PKG_SECTION="browser"
PKG_SHORTDESC="Chromium Browser"
PKG_LONGDESC="=== BIG FAT WARNING ===\nruns as root, is not sandboxed and has access to ALL your data. do not use this for online banking :D\n=== BIG FAT WARNING ===\n\nfeel free to join #openelec-unofficial on irc.freenode.net if you have questions"
PKG_DISCLAIMER="this is an unofficial addon. please don't ask for support in openelec forum / irc channel"

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROVIDES="executable"
PKG_ADDON_REPOVERSION="4.3"

PKG_AUTORECONF="no"

PKG_MAINTAINER="Stefan Saraev (seo at irc.freenode.net)"

# BIG FAT WARNING
#
# this package is unlikely to compile on your buildhost
# please dont report build failures
#

make_target() {
  cd $ROOT/$PKG_BUILD/src

  unset CFLAGS LDFLAGS LD
  export LDFLAGS="-Wl,--as-needed"
  export CXXFLAGS="-fno-ipa-cp"

  # configure....
  export GYP_PARAMS=
  export GYP_GENERATORS='make'
  export GYP_DEFINES="fastbuild=2 \
    target_arch=x64 \
    disable_sse2=1 \
    linux_sandbox_path=/storage/.kodi/addons/browser.chromium-browser/bin/chromium.sandbox \
    linux_breakpad=0 \
    linux_strip_binary=1 \
    linux_use_gold_binary=0 \
    linux_use_gold_flags=0 \
    enable_webrtc=1 \
    use_system_libpng=1 \
    use_system_libjpeg=1 \
    use_system_bzip2=1 \
    use_system_yasm=1 \
    disable_nacl=1 \
    build_ffmpegsumo=1 \
    proprietary_codecs=1 \
    use_gconf=0 \
    use_gio=0 \
    use_gnome_keyring=0 \
    use_pulseaudio=0 \
    use_kerberos=0 \
    use_cups=0 \
    enable_spellcheck=0 \
    no_strict_aliasing=1 \
    remove_webcore_debug_symbols=1 \
    enable_language_detection=0 \
    linux_use_tcmalloc=0"

  ./build/gyp_chromium -f make build/all.gyp --depth=.

  make BUILDTYPE=Release V=1 chrome chrome_sandbox
}

makeinstall_target() {
  : # nop
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -P  $PKG_BUILD/src/out/Release/chrome $ADDON_BUILD/$PKG_ADDON_ID/bin/chromium.bin
  cp -P  $PKG_BUILD/src/out/Release/chrome_sandbox $ADDON_BUILD/$PKG_ADDON_ID/bin/chromium.sandbox
  cp -P  $PKG_BUILD/src/out/Release/chrome.pak $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -P  $PKG_BUILD/src/out/Release/chrome_100_percent.pak $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -P  $PKG_BUILD/src/out/Release/resources.pak $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -PR $PKG_BUILD/src/out/Release/resources $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -P  $PKG_BUILD/src/out/Release/libffmpegsumo.so $ADDON_BUILD/$PKG_ADDON_ID/bin
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin/locales
  cp -PR $PKG_BUILD/src/out/Release/locales/en-US.pak $ADDON_BUILD/$PKG_ADDON_ID/bin/locales

  $STRIP $ADDON_BUILD/$PKG_ADDON_ID/bin/chromium.bin
  $STRIP $ADDON_BUILD/$PKG_ADDON_ID/bin/chromium.sandbox
  $STRIP $ADDON_BUILD/$PKG_ADDON_ID/bin/libffmpegsumo.so

  # config
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/config
  cp -P $PKG_DIR/config/* $ADDON_BUILD/$PKG_ADDON_ID/config

  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/lib

  # pango
  cp -PL $(get_build_dir pango)/.install_pkg/usr/lib/libpangocairo-1.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PL $(get_build_dir pango)/.install_pkg/usr/lib/libpango-1.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PL $(get_build_dir pango)/.install_pkg/usr/lib/libpangoft2-1.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib

  # cairo
  cp -PL $(get_build_dir cairo)/.install_pkg/usr/lib/libcairo.so.2 $ADDON_BUILD/$PKG_ADDON_ID/lib

  # gtk
  cp -PL $(get_build_dir gtk+)/.install_pkg/usr/lib/libgdk-x11-2.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PL $(get_build_dir gtk+)/.install_pkg/usr/lib/libgtk-x11-2.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib

  # atk
  #cp -PL $(get_build_dir atk)/.install_pkg/usr/lib/libatk-1.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib

  # harfbuzz
  cp -PL $(get_build_dir harfbuzz)/.install_pkg/usr/lib/libharfbuzz.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib

  # gdk-pixbuf
  cp -PL $(get_build_dir gdk-pixbuf)/.install_pkg/usr/lib/libgdk_pixbuf-2.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib

  # pango modules
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/pango-modules
  cp -PL $(get_build_dir pango)/.install_pkg/usr/lib/pango/1.8.0/modules/* $ADDON_BUILD/$PKG_ADDON_ID/pango-modules

  # pixbuf loaders
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/gdk-pixbuf-modules
  cp -PL $(get_build_dir gdk-pixbuf)/.install_pkg/usr/lib/gdk-pixbuf-2.0/2.10.0/loaders/* $ADDON_BUILD/$PKG_ADDON_ID/gdk-pixbuf-modules

  # flash
  if [ -d $PKG_BUILD/src/PepperFlash.$TARGET_ARCH ] ; then
    cp -a $PKG_BUILD/src/PepperFlash.$TARGET_ARCH $ADDON_BUILD/$PKG_ADDON_ID/bin/PepperFlash
  fi

  # nss
  cp -PL $(get_build_dir nss)/dist/Linux*OPT.OBJ/lib/*.so $ADDON_BUILD/$PKG_ADDON_ID/lib

  # nspr
  cp -PL $(get_build_dir nspr)/.install_pkg/usr/lib/*.so $ADDON_BUILD/$PKG_ADDON_ID/lib

}
