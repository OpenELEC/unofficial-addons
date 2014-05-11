# -*- coding: utf-8 -*-

################################################################################
#  Copyright (C) Peter Smorada 2014 (smoradap@gmail.com)
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
import xbmcgui;  # @UnresolvedImport @UnusedImport
import xbmc;  # @UnresolvedImport
import xbmcaddon;  # @UnresolvedImport
import xbmcplugin;  # @UnresolvedImport @UnusedImport
import shutil;
import subprocess;

addonId = "plugin.network.dhcp";
addon = xbmcaddon.Addon(id=addonId);

sys.path.append(os.path.join (addon.getAddonInfo('path'), 'resources', 'lib'));
import sutils; # @UnresolvedImport


# folders
home = addon.getAddonInfo('path');
icon = os.path.join(home, "icon.png");
execDir = os.path.join (home,"bin");


reload(sys);
sys.setdefaultencoding("utf-8");  # @UndefinedVariable

# needed dirs
pidFileDir = "/var/run";
dbFileDir = "/var/db";
dhcpdLeaseDir = "/var/lib/dhcpd";
addonSettingsDir = xbmc.translatePath("special://masterprofile/addon_data/" + addonId);

# config file names
dhclientConf = "dhclient.conf";
dhcpdConf = "dhcpd.conf" ;

confFiles = [dhclientConf, dhcpdConf]
neededDirs = [pidFileDir, dbFileDir, dhcpdLeaseDir, addonSettingsDir];


def checkDirExistence():
    for folder in neededDirs:
        if not os.path.exists(folder):
            try:
                os.makedirs(folder);
            except:
                pass;


def checkConfigFileExistence():
    
    for conf in confFiles:
        if not os.path.exists(os.path.join(addonSettingsDir, conf)):
            xbmc.log("dhclient / dhcpd: " + conf +  " settings file not found on default location.", level=xbmc.LOGDEBUG);
            
            if not os.path.exists(os.path.join(addonSettingsDir, conf + ".example")) :
                shutil.copyfile(src=os.path.join (addon.getAddonInfo('path'), 'resources', 'sample', conf + ".example"),
                                dst=os.path.join(addonSettingsDir, conf + ".example"));

def startService():
    
    if addon.getSetting("startDhcpd") == "true":
        cmd = "dhcpd.start" ;    
        xbmc.log("dhcpd: starting service" + cmd, level=xbmc.LOGDEBUG);
               
        p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
        output, errors = p.communicate();
        
        xbmc.log("dhcpd s out:" + str(output), level=xbmc.LOGDEBUG);
        xbmc.log("dhcpd e out:" + str(errors), xbmc.LOGERROR if errors else xbmc.LOGDEBUG);
        
    if addon.getSetting("startDhclient") == "true":
        interfaces = addon.getSetting("dhclientInfaces").split(" "); 
        
        for interface in interfaces:            
            cmd = "dhclient.start " + interface;    
            xbmc.log("dhclient: starting service:" + cmd, level=xbmc.LOGDEBUG);
                   
            p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
            output, errors = p.communicate();
            
            xbmc.log("dhclient s out: " + str(output), level=xbmc.LOGDEBUG);
            xbmc.log("dhclient e out: "  + str(errors), xbmc.LOGERROR if errors else xbmc.LOGDEBUG);
            
    if addon.getSetting("startDhcrelay") == "true":
        cmd = "dhcrelay.start" ;    
        xbmc.log("dhcrelay: starting service" + cmd, level=xbmc.LOGDEBUG);
               
        p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
        output, errors = p.communicate();
        
        xbmc.log("dhcrelay s out: " + str(output), level=xbmc.LOGDEBUG);
        xbmc.log("dhcrelay e out: " + str(errors), xbmc.LOGERROR if errors else xbmc.LOGDEBUG);


def stopService():
    cmd = "dhcpd.stop" ;    
    xbmc.log("dhcpd: stopping service if running: " + cmd, level=xbmc.LOGDEBUG);
               
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();
    
    xbmc.log("dhcpd s out:" + str(output), level=xbmc.LOGDEBUG);
    xbmc.log("dhcpd e out:" + str(errors), xbmc.LOGERROR if errors else xbmc.LOGDEBUG); 
    
    cmd = "dhclient.stop" ;    
    xbmc.log("dhclient: stopping service if running: " + cmd, level=xbmc.LOGDEBUG);
           
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();
    
    xbmc.log("dhclient s out: " + str(output), level=xbmc.LOGDEBUG);
    xbmc.log("dhclient e out: "  + str(errors), xbmc.LOGERROR if errors else xbmc.LOGDEBUG) 
    
    cmd = "dhrelay.stop" ;    
    xbmc.log("dhrelay: stopping service if running: " + cmd, level=xbmc.LOGDEBUG);
           
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();
    
    xbmc.log("dhcrelay s out: " + str(output), level=xbmc.LOGDEBUG);
    xbmc.log("dhcrelay e out: " + str(errors), xbmc.LOGERROR if errors else xbmc.LOGDEBUG);

checkDirExistence();
checkConfigFileExistence();
sutils.addExecPermissions(execDir, True);
startService();

while(not xbmc.abortRequested):
    xbmc.sleep(250);

stopService();    