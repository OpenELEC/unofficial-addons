#!/bin/sh

################################################################################
#  Copyright (C) Peter Smorada 2013
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

script="/storage/.kodi/addons/plugin.program.smartmontools/default.py"

# prints name of the disk and device with which it is connected
# format of print: name of disk|disk id from /dev/disk/by-id|device
getDisks(){
	ls -l /dev/disk/by-id 2>/dev/null | awk "/sd[a-z]?$|hd[a-z]?$/"'{
		if (match($9, /wwn-/) == 0)
			print substr($9, index($9, "-") + 1) "|" $9 "|" "\/dev\/" substr($11,7)
	}' 2>/dev/null
}

showinfo(){
	echo Usage:
}

case "$1" in
	disks) getDisks
		rv=$?
		;;
	*) showinfo
		rv=0
		;;
esac
if [ "$rv" != "0" ]; then
	echo return value: $rv
fi


exit $rv