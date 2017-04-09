################################################################################
# empty placeholder
################################################################################
import xbmcgui
import xbmc
import xbmcaddon
import os

# Show Readme file if in the addon folder otherwise shows only simple ok dialog
addon = xbmcaddon.Addon()
readmePath = os.path.join(addon.getAddonInfo("path"), "readme")
if(os.path.exists(readmePath)):
	with open(readmePath, "r") as file:
		text = file.read()
	window = xbmcgui.Window(10147)
	xbmc.executebuiltin("ActivateWindow(10147)") 
	xbmc.sleep(500)
	window.getControl(5).setText(text)
	window.getControl(1).setLabel(addon.getAddonInfo("name"))
else:
	dialog = xbmcgui.Dialog()
	dialog.ok('', 'This is a console-only addon')
