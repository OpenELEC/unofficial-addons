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
import xbmcgui;  # @UnresolvedImport
import xbmc;  # @UnresolvedImport
import xbmcaddon;  # @UnresolvedImport
import xbmcplugin;  # @UnresolvedImport
addon= xbmcaddon.Addon(id = "plugin.program.smartmontools");
sys.path.append( os.path.join (addon.getAddonInfo('path'), 'resources','lib') );
import consts;
import sutils;  # @UnresolvedImport
import sutilsxbmc;  # @UnresolvedImport
import smartd;
import smartctl;
import smartmontools;
import windows;



#reload(sys);
#sys.setdefaultencoding("utf-8");

# Script constants
home = addon.getAddonInfo('path');
icon = os.path.join(home, "icon.png");


if addon.getSetting(consts.settingSmardPoupus) == "true":
    showPopups = True;
else:
    showPopups = False;


def addFolderItem(name, index, additionalParams = "", isFolder = False):
    u=sys.argv[0]+"?index="+ str(index) + ("" if additionalParams == "" else "&" + additionalParams);
    liz=xbmcgui.ListItem(name, iconImage="DefaultFolder.png", thumbnailImage=home + "/icon.png");
    ok=xbmcplugin.addDirectoryItem(handle=int(sys.argv[1]),url=u, listitem=liz,isFolder=isFolder);
    return ok;

  
def startSmartd(): 
    smartd.startDaemon();
    if smartd.daemonRunning():
        if showPopups:
            xbmc.executebuiltin("Notification(smartmontools, " + addon.getLocalizedString(50001)+ ", 7, " + icon + ")");  # smartd started
    else:
        xbmc.log(consts.logHeader + "failed to start smartd", xbmc.LOGERROR);
        xbmcgui.Dialog().ok(consts.dialogHeader, addon.getLocalizedString(50024));   # Failed to start smartd
         
def stopSmartd(): 
    if smartd.daemonRunning():
        smartd.stopDaemon();
        if not smartd.daemonRunning():
            if showPopups:
                xbmc.executebuiltin("Notification(smartmontools, " + addon.getLocalizedString(50025)+ ", 7, " + icon + ")");  # smartd stopped
        else:
            xbmcgui.Dialog().ok(consts.dialogHeader, addon.getLocalizedString(50026));   # Failed to stop smartd
            
def reloadSmartdConfig():
    smartd.reloadDaemonConfiguration();
    if showPopups:
        xbmc.executebuiltin("Notification(smartmontools, " + addon.getLocalizedString(50061)+ ", 7, " + icon + ")");  # smartd reloading config

def runTestNowSmartd():
    smartd.runDaemonTestNow();
    if showPopups:
        xbmc.executebuiltin("Notification(smartmontools, " + addon.getLocalizedString(50062)+ ", 7, " + icon + ")");  # smartd running test now


def listDisks():
    disksData = smartmontools.getDisks();
    if len(disksData) > 0:
        addFolderItem(consts.fontBold + consts.colorBlue + addon.getLocalizedString(50018) +        # Choose disk for smartctl:
                      consts.colorEnd + consts.fontBoldEnd, -97);
        for data in disksData:
            l = data.split("|"); # params indexes: 0 - name; 1 - disk id from /dev/disk/by-id; 2 - device (/dev/sda, /dev/hda etc.)

            # getting and setting params to be passed to next call
            deviceType = smartmontools.getDiskType(l[1]);
            dic = smartctl.getStatusInfo(l[2], deviceType);
            dic[consts.paramDevice] = l[2];
            dic[consts.paramDiskId] = l[1];
            dic[consts.paramDiskType] = deviceType;
            params = sutilsxbmc.createParamStringFromDictionairy(dic, False);
            
            displayName = "";
            
            # add color to device name
            try:
                if dic[consts.paramDeviceIsSuported]:
                    if dic[consts.paramOverallHealth] == "PASSED":
                        displayName = consts.colorShadeOfGreen;
                    else:
                        displayName = consts.colorShadeOfRed;
                else:
                    displayName = consts.colorOrange;
            except:
                displayName = "";
            
            displayName += l[0] + " (" + l[2] + ")" + (consts.colorEnd if displayName else "");
                    
            addFolderItem(displayName , 20, params, True);

def showTextWindow(header, text):
    window = windows.basicTextWindow("textDialog.xml", home, 'Default');
    window.setHeaderAndText(header, text);
    window.doModal(); 
    del window;      

            
def warning():
    xbmcgui.Dialog().ok(consts.dialogHeader, addon.getLocalizedString(50057),
                        addon.getLocalizedString(50058));         

def listSmartctlTasks(device, diskId, diskType):
    del params["index"];
    paramString = sutilsxbmc.createParamStringFromDictionairy(params, False);
#    params = consts.paramDevice + "=" + device + "&" + consts.paramDiskId +"=" + diskId;
#    params += "&" + consts.paramDiskType + "="+ diskType;
    
    addFolderItem(addon.getLocalizedString(50037), 44, paramString);
    addFolderItem(addon.getLocalizedString(50028), 41, paramString);          # Overall health status
    addFolderItem(addon.getLocalizedString(50027), 30, paramString, True);    # Perform self-test
    addFolderItem(addon.getLocalizedString(50038), 40, paramString, True);    # Reports
    addFolderItem(addon.getLocalizedString(50002), 21, paramString);          # Set device type
    #addFolderItem("Addon test purpouse task only", 90, paramString);   
    xbmcplugin.endOfDirectory(int(sys.argv[1]));
    
    
def listSmartctlTests(device, diskId, diskType):
    del params[consts.paramIndex];
    paramString = sutilsxbmc.createParamStringFromDictionairy(params, False);
#    params = consts.paramDevice + "=" + device + "&" + consts.paramDiskId +"=" + diskId;
#    params += "&" + consts.paramDiskType + "="+ diskType;
    
    addFolderItem(consts.fontBold + consts.colorBlue + addon.getLocalizedString(50011) +   # Choose test type:
                  consts.colorEnd + consts.fontBoldEnd, -99);  
    
    # create list items with test duration              
    shortTestString = addon.getLocalizedString(50006);  # short 
    try:
        shortTestString += " (" + params[consts.paramShortTestDuration] + " " + \
                          addon.getLocalizedString(50036) + ")";
    except: # if duration is not available it will keep only name of the test
        pass;
    
    longTestString = addon.getLocalizedString(50007);  # long
    try:
        longTestString += " (" + params[consts.paramLongTestDuration] + " " + \
                          addon.getLocalizedString(50036) + ")";
    except:
        pass;
    
    conveyanceTestString = addon.getLocalizedString(50008);   # conveyance
    try:
        conveyanceTestString += " (" + params[consts.paramConveyanceTestDuration] + " " + \
                          addon.getLocalizedString(50036) + ")";
    except:
        pass;
    
    addFolderItem(shortTestString, 31, paramString);   
    addFolderItem(longTestString, 32, paramString);   
    addFolderItem(conveyanceTestString, 33, paramString);
    addFolderItem(addon.getLocalizedString(50009), 34, paramString);   # offline
    addFolderItem(addon.getLocalizedString(50010), 39, paramString);   # Cancel running tests
    xbmcplugin.endOfDirectory(int(sys.argv[1]));

def listSmartdTasks():
    addFolderItem(consts.fontBold + consts.colorBlue + addon.getLocalizedString(50012) +       # smartd daemon tasks:
                  consts.colorEnd + consts.fontBoldEnd, -99); 
    if smartd.daemonRunning():
        addFolderItem(addon.getLocalizedString(50013), 3); # reload configuration file
        addFolderItem(addon.getLocalizedString(50014), 4); # run test now
        addFolderItem(addon.getLocalizedString(50015), 2); # stop
    else:
        addFolderItem(addon.getLocalizedString(50016), 1); # start
        
    addFolderItem(addon.getLocalizedString(50017), 5);    # show log
    
    
def listSmartctlReports():
    del params[consts.paramIndex];
    paramString = sutilsxbmc.createParamStringFromDictionairy(params, False);
    
    addFolderItem(addon.getLocalizedString(50033), 42, paramString);
    addFolderItem(addon.getLocalizedString(50032), 43, paramString);
    addFolderItem(addon.getLocalizedString(50039) + addon.getLocalizedString(50054), 45, paramString);    # SMART capabilities  + (ATA only)
    addFolderItem(addon.getLocalizedString(50040), 46, paramString);
    
    # logs from -l parameter, gets the same index as id of their description in strings.po
    for logType in consts.logTypeToDescStringIdDic.keys():
        index = consts.logTypeToDescStringIdDic[logType];
        description = addon.getLocalizedString(index) 
        addFolderItem(description, index, paramString);
    
    xbmcplugin.endOfDirectory(int(sys.argv[1]));
    
def listOtherTasks():
    addFolderItem(consts.fontBold + consts.colorBlue + addon.getLocalizedString(50030) +   # Other:
                  consts.colorEnd + consts.fontBoldEnd, -99);
    addFolderItem(addon.getLocalizedString(50031), 91);
        
def showSmartdLog():
    text = smartd.getLog();
    showTextWindow(consts.logSmartdHeader, text);
    
def showXbmcLogEntries():
    logFile = xbmc.translatePath("special://logpath") + "kodi.log";
    #text = sutils.readFileAsStringShell(logFile);
    #text = sutils.readFileAsStringAndFilterShell(logFile, consts.dialogHeader);
    text = sutils.readFileAsString(logFile);
    matches = sutils.findAllMatches(text, consts.regexXbmcLogEntries);
    s = ""
    
    for match in matches:
        s += match + "\n"
    showTextWindow(consts.logXbmcLog, s);
    

    
def executeSmartctlTest(index, device, diskId, diskType):
    
    if index == 31:
        testType = consts.testShort;
    elif index == 32:
        testType = consts.testLong;
    elif index == 33:
        testType = consts.testConveyance;
    elif index == 34:
        testType = consts.testOffline;
    
    success = smartctl.executeSelfTest(testType, device, diskType);
    
    if success:
        if showPopups:
            xbmc.executebuiltin("Notification(smartmontools, " + addon.getLocalizedString(50034)+ ", 7, " + icon + ")");  # Self test started
    else:
        xbmcgui.Dialog().ok(consts.dialogHeader, addon.getLocalizedString(50035));   # Failed to start self test

def showOverallHealthStatus(device, deviceType):
    output = smartctl.getOverallHealthStatus(device, deviceType);
    showTextWindow(consts.logSmartctlHeader + addon.getLocalizedString(50029), output);
    
def showAllSmartInformation(device, deviceType):
    output = smartctl.getAllSmartDeviceInformation(device, deviceType);
    showTextWindow(consts.logSmartctlHeader + addon.getLocalizedString(50033), output);
    
def showBasicDeviceInformation(device, deviceType):
    output = smartctl.basicDriveInfo(device, deviceType);
    showTextWindow(consts.logSmartctlHeader + addon.getLocalizedString(50037), output);
    
def showAllDeviceInformation(device, deviceType):
    output = smartctl.getAllDeviceformation(device, deviceType);
    showTextWindow(consts.logSmartctlHeader + addon.getLocalizedString(50032), output);
    
def showDeviceCapabilities(device, deviceType):
    output = smartctl.driveCapabilities(device, deviceType);
    showTextWindow(consts.logSmartctlHeader + addon.getLocalizedString(50039) +
                   addon.getLocalizedString(50039), output);    # SMART capabilities +  (ATA only)
    
def showDeviceAttributes(device, deviceType):
    output = smartctl.driveSmartAttributes(device, deviceType);
    showTextWindow(consts.logSmartctlHeader + addon.getLocalizedString(50040), output);

def setDeviceType(diskId):
    deviceTypelist = consts.deviceTypeList;
    deviceTypelist.append(addon.getLocalizedString(50019));   # custom device type
    selected = xbmcgui.Dialog().select(addon.getLocalizedString(50002), deviceTypelist);    # Select device type
    deviceType = consts.deviceTypeList[selected];
    if selected == -1:  # dialog has been canceled
        return;
    
    if deviceType == addon.getLocalizedString(50019):  # custom dev type - user has to enter string
        deviceType = sutilsxbmc.getStringFromUser(addon.getLocalizedString(50019));   # Enter device type string
        xbmc.log(consts.logHeader + "custom device type - " + deviceType, level=xbmc.LOGDEBUG);
        
    smartmontools.setDiskType(diskId, deviceType); 
    xbmcgui.Dialog().ok(consts.dialogHeader, addon.getLocalizedString(50003), addon.getLocalizedString(50004));    # Setting changed.  Refresh folder to see the difference.
    

def executeIndexesReservedForSmartctlReports(index):
    if index == 40:
        listSmartctlReports();
    elif index == 41:
        showOverallHealthStatus(params[consts.paramDevice], params[consts.paramDiskType]);
    elif index == 42:
        showAllSmartInformation(params[consts.paramDevice], params[consts.paramDiskType]);    
    elif index == 43:
        showAllDeviceInformation(params[consts.paramDevice], params[consts.paramDiskType]); 
    elif index == 44:
        showBasicDeviceInformation(params[consts.paramDevice], params[consts.paramDiskType]); 
    elif index == 45:
        showDeviceCapabilities(params[consts.paramDevice], params[consts.paramDiskType]);
    elif index == 46:
        showDeviceAttributes(params[consts.paramDevice], params[consts.paramDiskType]);
    elif index > 50000:        
        for logType in consts.logTypeToDescStringIdDic.keys():
            i = consts.logTypeToDescStringIdDic[logType];
            if index == i:
                output = smartctl.getLog(logType, params[consts.paramDevice], params[consts.paramDiskType]);
                showTextWindow(consts.logSmartctlHeader + addon.getLocalizedString(index), output);
                break;  
     
        
# script logic
xbmc.log(msg="smartmontools plugin v " + addon.getAddonInfo("version"), level=xbmc.LOGDEBUG);
xbmc.log(msg="smartmontools number of params: " + str(len(sys.argv)), level=xbmc.LOGDEBUG);
xbmc.log(msg="smartmontools initial params: " + str(sys.argv), level=xbmc.LOGDEBUG);


params = sutils.get_params();    

xbmc.log(msg="smartmontools initial params:" + str(params), level=xbmc.LOGDEBUG);

try:
    index = int(params[consts.paramIndex]);
except:
    index = None;
    
if index == None : # creates initial folder structured menu
    if sutils.isFileExecutableByOwner(consts.script):
        listDisks();
        listSmartdTasks();
        listOtherTasks();
    else:
        s = consts.colorShadeOfRed + addon.getLocalizedString(50059) + consts.colorEnd;     # restart of OL required
        addFolderItem(s, -99);
        
    xbmcplugin.endOfDirectory(int(sys.argv[1]));

# Execute chosen task    
# indexes 1 - 20 are reserved for common smartd tasks 
elif index == 1:
    startSmartd();
    sutilsxbmc.refreshCurrentListing();
elif index == 2:
    stopSmartd();
    sutilsxbmc.refreshCurrentListing();
elif index == 3:
    reloadSmartdConfig();
elif index == 4:
    runTestNowSmartd();
elif index == 5:
    showSmartdLog();
   
# indexes 20 - 29 are reserved for common smartctl tasks 
elif index == 20:
    diskId = params[consts.paramDiskId];
    listSmartctlTasks(params[consts.paramDevice], diskId, smartmontools.getDiskType(diskId) ); 
elif index == 21:
    setDeviceType(params[consts.paramDiskId]);
    
# indexes 30 - 39 are reserved for smartctl tests
elif index == 30:
    listSmartctlTests(params[consts.paramDevice], params[consts.paramDiskId], 
                      params[consts.paramDiskType]);
elif index > 30 and index <35:
    executeSmartctlTest(index, params[consts.paramDevice], params[consts.paramDiskId], 
                        params[consts.paramDiskType]);
elif index == 39:
    smartctl.cancelSelfTest(params[consts.paramDevice], params[consts.paramDiskType]);

# indexes 40 - 49 are reserved for smartctl reports + indexes higher than 50000
elif (index >= 40 and index <50) or index > 50000:
    executeIndexesReservedForSmartctlReports(index);
 
elif index == 90:
    print("smartmontools: " + str(params));
    print("smartmontools: " + str(smartctl.getStatusInfo(params[consts.paramDevice])));
elif index == 91:
    showXbmcLogEntries();
elif index == 99:
    warning();  
elif index == -99:
    pass;


