
PKG_NAME="links"
PKG_VERSION="2.8"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://links.twibright.com/"
PKG_URL="http://links.twibright.com/download/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib openssl libjpeg-turbo libpng libX11 libxcb libXau"
PKG_PRIORITY="optional"
PKG_SECTION="web"
PKG_SHORTDESC="Links web browser"
PKG_LONGDESC="The Links web browser combines ease of use, crystal clear pictures of exactly rendered video output, and the power and reliability of an HTTP requester and HTML parser written manually without compromises in C."
PKG_MAINTAINER="AntiPrism.ca (antiprism@antiprism.ca)"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr --x-includes=$SYSROOT_PREFIX/usr/include/X11/ --x-libraries=$SYSROOT_PREFIX/usr/X11/lib/ --enable-graphics --with-ssl --disable-ssl-pkgconfig --without-bzip2 --without-bzlib --without-lzma --without-svgalib --with-x --without-directfb --without-libtiff"

post_makeinstall_target() {
  strip $INSTALL/usr/bin/links
}
