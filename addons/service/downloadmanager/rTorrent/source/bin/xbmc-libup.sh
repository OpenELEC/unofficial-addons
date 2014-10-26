#!/bin/sh

# Update XBMC Librarys
sleep 2
kodi-send -a "UpdateLibrary(video)"
sleep 2
kodi-send -a "UpdateLibrary(music)"

