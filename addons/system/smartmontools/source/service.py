# -*- coding: utf-8 -*-

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

import os.path;
import sys;
import xbmc;  # @UnresolvedImport
import xbmcaddon;  # @UnresolvedImport
import xbmcgui;  # @UnresolvedImport
addon= xbmcaddon.Addon(id = "plugin.program.smartmontools");
sys.path.append( os.path.join (addon.getAddonInfo('path'), 'resources','lib') );
import consts;
import sutils;  # @UnresolvedImport
import smartd;
import smartmontools;

home = addon.getAddonInfo('path');
icon = os.path.join(home, "icon.png");
execDir =  os.path.join (home,"bin");

def startService():
    if not sutils.isFileExecutableByOwner(consts.script):
        sutils.addExecPermissions(execDir, True);
        
    smartmontools.checkConfigurationFilesExistance();

    if addon.getSetting(consts.settingDBupdates ) == "true":
        smartmontools.updateDatabase();

    if addon.getSetting(consts.settingRunDaemonOnStartup ) == "true":        
        smartd.startDaemon();
        if smartd.daemonRunning():
            if addon.getSetting(consts.settingSmartdStartupPopup) == True:
                xbmc.executebuiltin("Notification(smartmontools, " + addon.getLocalizedString(50001)+ ", 7, " + icon + ")");  # smartd started
        else:
            xbmc.log(consts.logHeader + "failed to start smartd", xbmc.LOGERROR);
            xbmcgui.Dialog().ok(consts.dialogHeader, addon.getLocalizedString(50024));
        
def stopService():
    smartd.stopDaemon();

    
startService();

while(not xbmc.abortRequested):
    xbmc.sleep(250);
    
stopService();
    