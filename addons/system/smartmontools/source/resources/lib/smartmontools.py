'''
Created on 15.9.2013

@author: Peter Smorada
'''

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

import consts;
import sutils;
import xbmcaddon;  # @UnresolvedImport
import xbmc;  # @UnresolvedImport
import os;
import subprocess;
import threading;
import datetime;
import time;

addon= xbmcaddon.Addon(id = consts.addonId);


def getDiskType(diskId):
    try:
        diskType = __diskTypeDic[diskId];
    except:
        diskType = None;
        
    if diskType == None:
        diskType = "auto" 
    return diskType;
        
        
def setDiskType(diskId, diskType):
    
    xbmc.log(msg="smartmontools: number of stored disk types before adding new one: " + str(len(__diskTypeDic)) , level=xbmc.LOGDEBUG);    
    __diskTypeDic[diskId] = diskType;
    
    string = ""
    for key in __diskTypeDic.keys():        
        string += ("&" if len(string) > 0 else "") + key + "=" + __diskTypeDic[key];
        
    addon.setSetting(consts.settingDiskTypes, string);    
    
def parseDiskTypes():
    settings = addon.getSetting(consts.settingDiskTypes);
    dic = sutils.get_params(settings);
    xbmc.log(msg="smartmontools: stored disk types were read: " + str(len(dic)) , level=xbmc.LOGDEBUG);
    return dic;
  
  
def checkConfigurationFilesExistance():
    if not os.path.exists(consts.fileDB):
        xbmc.log(msg="smartmontools addon: DB file doesn't exist, copying default.", level=xbmc.LOGDEBUG);
        cmd = "cp " + consts.fileDBDefault + " " + consts.fileDB;
        p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
        output, errors = p.communicate();
        xbmc.log(msg="smartmontools stdout: " + str(output), level=xbmc.LOGDEBUG);
        xbmc.log(msg="smartmontools stderr: " + str(errors), level=xbmc.LOGDEBUG);
      
    daemonConfExists = os.path.exists(consts.fileDaemonConfig);        
    if not daemonConfExists:
        xbmc.log(msg="smartmontools addon: copying default daemon config file.", level=xbmc.LOGDEBUG)
     
        cmd = "cp " + consts.fileDaemonConfigDefault + " " + consts.fileDaemonConfig;
        p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
        output, errors = p.communicate();
        xbmc.log(msg="smartmontools stdout: " + str(output), level=xbmc.LOGDEBUG);
        xbmc.log(msg="smartmontools stderr: " + str(errors), level=xbmc.LOGDEBUG);                 

  
        
def getDisks():
    cmd = "\"" + consts.script + "\" " + consts.commandDisks
    xbmc.log(msg="smartmon addon: getting connected disks", level=xbmc.LOGDEBUG);
            
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();  
    
    xbmc.log(msg="smartmontools stdout: " + str(output), level=xbmc.LOGDEBUG);
    xbmc.log(msg="smartmontools stderr: " + str(errors), level=xbmc.LOGDEBUG);
        
    return output.split();


def updateDatabase():
    cmd = "\"" + consts.updateScript + "\" " + consts.fileDB;
    xbmc.log(msg="smartmontools: starting DB update.", level=xbmc.LOGDEBUG);
            
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();  
    
    xbmc.log(msg="smartmontools stdout: " + str(output), level=xbmc.LOGDEBUG);
    xbmc.log(msg="smartmontools stderr: " + str(errors), level=xbmc.LOGDEBUG);
    
    # storing date when db update was performed
    today = datetime.date.today();
    todayString = str(today.year) + "-" + str(today.month) + "-" + str(today.day);
    xbmc.log(msg="smartmontools: updating date of last DB update check: " + todayString, level=xbmc.LOGDEBUG);
    addon.setSetting(consts.settingLastDBupdateChecked, todayString);
    # TODO: return true if updated
    
def shouldUpdateDB():
    allowed = True if addon.getSetting(consts.settingDBupdates) == "true" else False;
    #allowed = True;
    if allowed:
        lastUpdateDateString = addon.getSetting(consts.settingLastDBupdateChecked);
        #lastUpdateDateString = "2013-09-12"
        if not lastUpdateDateString:  # if check was never performed it should be done
            xbmc.log(msg="smartmontools: update of db was never performed.", level=xbmc.LOGDEBUG);
            return True;
        l = lastUpdateDateString.split("-");
        lastCheckDate = datetime.date(int(l[0]), int(l[1]), int(l[2]));
        today = datetime.date.today();
        td = today - lastCheckDate;
        difference = td.days;        
        updateInterval = int(addon.getSetting(consts.settingDBupdateInterval));
       
        if difference >= updateInterval:
            return True
            xbmc.log(msg="smartmontools: updating db due to number of days past " + str(difference) +".", level=xbmc.LOGDEBUG);
        else:
            xbmc.log(msg="smartmontools: not updating db due to number of days past " + str(difference) +".", level=xbmc.LOGDEBUG);
            return False;
    else:
        xbmc.log(msg="smartmontools: updating db is not allowed.", level=xbmc.LOGDEBUG);
        return False;


class dbUpdater (threading.Thread):    
    
    def __init__(self, shouldRun = True):
        self.shouldRun = shouldRun;
        threading.Thread.__init__(self);
    
    def run(self):
        xbmc.log(msg="smartmontools: update thread started", level=xbmc.LOGDEBUG);
        while self.shouldRun:
            xbmc.log(msg="smartmontools: update thread performing check if is time to execute update script.", level=xbmc.LOGDEBUG);
            update = shouldUpdateDB();
            if update:
                xbmc.log(msg="smartmontools: update thread executing update check.", level=xbmc.LOGDEBUG);
                updateDatabase();
            time.sleep(2 * 60 * 60);
        
        

# initiation of needed module variable        
__diskTypeDic = parseDiskTypes();
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    