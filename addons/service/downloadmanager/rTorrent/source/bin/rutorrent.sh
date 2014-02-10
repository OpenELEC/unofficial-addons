PHP_CGI="/storage/.xbmc/addons/tools.php/bin/php-cgi"

# hack: make php/dtach executable to save reboot on update
chmod a+x $PHP_CGI
chmod a+x /storage/.xbmc/addons/tools.dtach/bin/dtach

# rutorrent needs php in path
if [ ! `which php` ]; then
  ln -sf $PHP_CGI $ADDON_DIR/bin/php
fi

# generate config file
cat > $RUTORRENT_CONF << EOF
# httpd.conf for rutorrent
# This file is generated from the rtorrent.start script

H:$ADDON_DIR/rutorrent/
A:*                          # Allow address from all ip's
E404:/usr/www/error/404.html # /path/e404.html is the 404 (not found) error page
I:index.html                 # Show index.html when a directory is requested
*.php:$ADDON_DIR/bin/php

EOF

if [ "$RUTORRENT_AUTH" == "true" ];then
  cat >> $RUTORRENT_CONF << EOF
# ruTorrent Wed Auth is enabled
/:$RUTORRENT_USER:$RUTORRENT_PASS

EOF
  # if upnp do upnp port mapping.
  if [ "$RUTORRENT_UPNP" == "true" -a "$UPNP_OK" == "true" ];then
    $ADDON_DIR/bin/upnpc -a $LAN_IP $RUTORRENT_PORT $RUTORRENT_PORT TCP
  fi
fi
