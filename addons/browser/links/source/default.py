# -*- coding: utf-8 -*-

################################################################################
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

import os, sys, subprocess, xbmcaddon, xbmcplugin, xbmcgui

__scriptname__ = 'Links Web Browser plugin for OpenELEC'
__author__ = 'AntiPrism.ca'
__addon__ = xbmcaddon.Addon(id='browser.links')

T = __addon__.getLocalizedString

class MyClass(xbmcgui.Window):
	def __init__(self):
		self.links = '/usr/bin/links'
		if not os.path.isfile(self.links) or not os.access(self.links, os.X_OK):
			self.links = os.path.join(__addon__.getAddonInfo('path'), 'bin', 'links')
			if os.path.isfile(self.links) and not os.access(self.links, os.X_OK):
				subprocess.call('chmod a+x "' + self.links + '"', shell=True)
		links_lng = xbmc.getLanguage()
		if links_lng not in [ "English", "Bahasa Indonesian", "Belarusian", "Brazilian Portuguese", "Bulgarian", "Catalan", "Croatian", "Czech", "Danish", "Dutch", "Estonian", "Finnish", "French", "Galician", "German" , "Greek", "Hungarian", "Icelandic", "Italian", "Lithuanian", "Norwegian", "Polish", "Portuguese", "Romanian", "Russian", "Serbian", "Slovak", "Spanish", "Swedish", "Swiss German", "Turkish", "Ukrainian", "Upper Sorbian" ]:
			links_lng = "English"				
		if not os.path.isfile(self.links) or not os.access(self.links, os.X_OK) or subprocess.call(self.links + ' -mode ' + str(self.getWidth()) + 'x' + str(self.getHeight()) + ' -language "' + links_lng + '" ' + __addon__.getSetting('homepage') + ' &', shell=True) != 0:
			xbmcgui.Dialog().ok(__scriptname__, T(32002), ' ', self.links) 

if __name__ == '__main__': 
	mydisplay = MyClass()
	del mydisplay
	sys.modules.clear()
	
