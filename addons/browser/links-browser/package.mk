
PKG_NAME="plugin.program.linksbrowser"
PKG_VERSION="1.0.2"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.antiprism.ca/"
PKG_URL="http://www.antiprism.ca/releases/$PKG_NAME-$PKG_VERSION.zip"
PKG_DEPENDS_TARGET="toolchain links"
PKG_PRIORITY="optional"
PKG_SECTION="addons"
PKG_SHORTDESC="Links web browser plugin for OpenELEC"
PKG_LONGDESC="Links web browser plugin for OpenELEC"
PKG_MAINTAINER="AntiPrism.ca (antiprism@antiprism.ca)"
PKG_DISCLAIMER="this is an unofficial addon. please don't ask for support in openelec forum / irc channel"

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="plugin.program"

PKG_AUTORECONF="no"

PKG_MAINTAINER="antiprism.ca"

post_unpack() {
  [ -d "$ROOT/$PKG_BUILD" ] || mv `echo "$ROOT/$PKG_BUILD" | sed -e "s/$PKG_NAME-$PKG_VERSION/$PKG_NAME/g"` $ROOT/$PKG_BUILD
  if [ -d $ROOT/$PKG_BUILD/$PKG_NAME ]
  then
    cp -R $ROOT/$PKG_BUILD/$PKG_NAME/* $ROOT/$PKG_BUILD
    rm -rf $ROOT/$PKG_BUILD/$PKG_NAME
  fi
}

make_target() {
  :  
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/share/xbmc/addons/$PKG_NAME
  cp -R $ROOT/$PKG_BUILD/* $INSTALL/usr/share/xbmc/addons/$PKG_NAME
  rm -rf $INSTALL/usr/share/xbmc/addons/$PKG_NAME/bin
}


