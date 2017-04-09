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

PKG_NAME="FlexGet"
PKG_VERSION="1.2.503"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://flexget.com/"
PKG_URL="https://pypi.python.org/packages/source/F/$PKG_NAME/$PKG_NAME-$PKG_VERSION.tar.gz"
# PKG_SOURCE_DIR="$PKG_NAME"
PKG_DEPENDS_TARGET="toolchain Python"
PKG_PRIORITY="optional"
PKG_SECTION="service/downloadmanager"
PKG_SHORTDESC="FlexGet is a program aimed to automate downloading or processing content (torrents, podcasts, etc.) from different sources like RSS-feeds, html-pages, various sites and more."
PKG_LONGDESC="FlexGet is a multipurpose automation tool for content like torrents, nzbs, podcasts, comics, series, movies, etc. It can use different kinds of sources like RSS-feeds, html pages, csv files, search engines and there are even plugins for sites that do not provide any kind of useful feeds."
PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.service"
PKG_AUTORECONF="no"
PKG_MAINTAINER="unofficial.addon.pro"

addon() {
    # set
    # python -c "import sys; print(sys.path)"
    mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/site-packages
    wget -O get-pip.py https://bootstrap.pypa.io/get-pip.py
    python get-pip.py -t $ADDON_BUILD/$PKG_ADDON_ID/site-packages FlexGet
    python get-pip.py -t $ADDON_BUILD/$PKG_ADDON_ID/site-packages transmissionrpc
}
