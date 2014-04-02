################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
#      Copyright (C) 2011 Anthony Nash (nash.ant@gmail.com)
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

PKG_NAME="SickBeard"
PKG_VERSION="fb37d33"
PKG_REV="1"
PKG_ARCH="all"
PKG_LICENSE="OSS"
PKG_SITE="https://github.com/midgetspy/Sick-Beard"
PKG_URL="$DISTRO_SRC/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain Python Cheetah"
PKG_PRIORITY="optional"
PKG_SECTION="service/downloadmanager"
PKG_SHORTDESC="SickBeard: automated TV show downloading."
PKG_LONGDESC="SickBeard: automated TV show downloading."

PKG_IS_ADDON="no"

PKG_AUTORECONF="no"

PKG_MAINTAINER="unofficial.addon.pro"

make_target() {
  : # nothing to do here
}

makeinstall_target() {
  : # nothing to do here
}
