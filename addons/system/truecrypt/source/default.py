# -*- coding: utf-8 -*-
'''
This module functions as both view and controller (MVC scheme) for OpenELEC's TrueCrypt addon.
It is meant to be executed only by from XBMC. 
'''

################################################################################
#  Copyright (C) Peter Smorada 2013 (smoradap@gmail.com)
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
addon= xbmcaddon.Addon(id = "plugin.program.truecrypt");
sys.path.append( os.path.join (addon.getAddonInfo('path'), 'resources','lib') );
import consts;
import sutils;  # @UnresolvedImport
import tcitem;  # @UnresolvedImport
import sutilsxbmc;  # @UnresolvedImport
from time import sleep

reload(sys);
sys.setdefaultencoding("utf-8");

# Script constants
__scriptname__ = "TrueCrypt"
__author__ = "Peter Smorada"
__home_ = addon.getAddonInfo('path');
__icon__ = os.path.join(__home_, "icon.png");
dialogHeader = "TrueCrypt";
dontStoreAnyInfo = True if  addon.getSetting(consts.dontStoreAnyInformation) == consts.trueString else False;
allowStorePassKey = False if dontStoreAnyInfo else True if addon.getSetting(consts.allowStoringPasswordAndKeyFile) == consts.trueString else False;
storeKeyFileUsage = False if dontStoreAnyInfo else True if addon.getSetting(consts.storeKeyFileInfo) == consts.trueString else False;


def addItemToXBMCDirView(item):
    '''
    This method adds saved item in the directory view of XBMC.
    :param item: item to be added
    '''
    
    u=sys.argv[0]+"?index="+ str(item.index);
    ok=True;
    
    # check if mount checking is active
    if addon.getSetting(consts.mountChecks) == consts.trueString:
        mounted = tcitem.isMounted(item.filePath, item.mountPoint);
    else :
        mounted = consts.unknownStatus;  #
        
    locked = item.isLocked();
    addToName = "";
    # blocks add status to the name
    if mounted == consts.mounted:
        addToName += consts.colorShadeOfGreen + addon.getLocalizedString(50056) + consts.colorEnd;   # mounted
    elif mounted == consts.mountPointInUse:
        addToName += consts.colorShadeOfRed + addon.getLocalizedString(50143) + consts.colorEnd;   # mount point in use
    if locked and not addToName == "":
        addToName += consts.colorShadeOfRed + ", " + addon.getLocalizedString(50064) + consts.colorEnd;
    elif locked :
        lckReason = item.getLockReason();
        addToName += consts.colorShadeOfRed + addon.getLocalizedString(50064) + (" - " + lckReason if lckReason != "" else "") + consts.colorEnd;
    if addToName != "" :
        addToName = " (" + addToName + ")"

    name = item.name + addToName;
    listItem=xbmcgui.ListItem(name, iconImage="DefaultFolder.png", thumbnailImage=item.icon);
    ok=xbmcplugin.addDirectoryItem(handle=int(sys.argv[1]),url=u, listitem=listItem,isFolder=False);
    return ok;

def addAllActiveItemsToXBMCView(items=None):
    '''
    The method adds items to the folder view of XBMC.
    :param items: list of items to be added. If None, then all active items are added 
    '''
    items = items if items != None else tcitem.getTCitems(True);
    for item in items:
        addItemToXBMCDirView(item);

def addFolderItem(name, index):
    '''
    Method adds a list item in the directory menu of XBMC. Default addon icon is used.
    :param name: display name of the item
    :param index: integer which stands for the action to be performed when item is activated
    '''
    u=sys.argv[0]+"?index="+ str(index);
    ok=True;
    liz=xbmcgui.ListItem(name, iconImage="DefaultFolder.png", thumbnailImage=addon.getAddonInfo('path') + "/icon.png");
    ok=xbmcplugin.addDirectoryItem(handle=int(sys.argv[1]),url=u, listitem=liz,isFolder=False);
    return ok;


def performAction(action, item ):
    '''
    The method performs selected action on the clicked item in XBMC directory view.
    :param action: string which represents action to be performed
    :param item: TC item on which perform the action
    '''
    if action == addon.getLocalizedString(50001) :   # Mount
        xbmc.log("Truecrypt attempt to mount drive.", level=xbmc.LOGDEBUG);
        mountDrive(volume = item.filePath, mountPoint = item.mountPoint, item = item);
    elif action == addon.getLocalizedString(50002) : # Unmount
        xbmc.log("Truecrypt attempt to unmount drive", level=xbmc.LOGDEBUG);
        unmountDrive(volume = item.filePath, mountPoint = item.mountPoint, item = item);
    elif action == addon.getLocalizedString(50003)  :     # "Deactivate"
        xbmc.log("Truecrypt deactivating item.", level=xbmc.LOGDEBUG);
        item.deactivate();
        xbmcgui.Dialog().ok(dialogHeader, addon.getLocalizedString(50013) + " " + addon.getLocalizedString(50014));  # Item is deactivated. Use Addon settings to re-activate it."
        sutilsxbmc.refreshCurrentListing();
    elif action == addon.getLocalizedString(50004) :  #  "Reset settings"
        xbmc.log("Truecrypt reseting item.", level=xbmc.LOGDEBUG);
        reset(item)
    elif action == xbmc.getLocalizedString(117): # delete
        xbmc.log("Truecrypt deleting item.", level=xbmc.LOGDEBUG);
        delete(item);
    elif action == addon.getLocalizedString(50005):  # "Recreate container"
        xbmc.log("Truecrypt recreating container.", level=xbmc.LOGDEBUG)
        recreateSimpleContainer(item);
    elif action == addon.getLocalizedString(50006) :    # "Format"
        xbmc.log("Truecrypt formating container.", level=xbmc.LOGDEBUG);
        formatExistingVolume(volume = item.filePath, mountPoint = item.mountPoint, item = item);
    elif action == addon.getLocalizedString(50007) :   # "Store password"
        xbmc.log("Truecrypt password being stored.", level=xbmc.LOGDEBUG);
        setPassword(item);
    elif action == addon.getLocalizedString(50008):   # "Remove stored password"
        xbmc.log("Truecrypt password being removed.", level=xbmc.LOGDEBUG);
        removeStoredPassword(item);
    elif action == addon.getLocalizedString(50066):    # Change password
        xbmc.log("Truecrypt password being changed.", level=xbmc.LOGDEBUG);
        changePassword(volume = item.filePath, item = item);        
    elif action == addon.getLocalizedString(50102):      # Store key file(s) path
        xbmc.log("Truecrypt - key file path is being stored.", level=xbmc.LOGDEBUG);
        storeKeyFilePath(item);   
    elif action == addon.getLocalizedString(50103):     # Remove stored key file(s) path
        xbmc.log("Truecrypt - stored key file path is being removed.", level=xbmc.LOGDEBUG);
        removeStoredKeyFilePath(item);
    
    elif action == addon.getLocalizedString(50101):      # Change key files(s)h
        xbmc.log("Truecrypt - key files are being changed.", level=xbmc.LOGDEBUG);
        changeKeyFiles(volume = item.filePath, mountPoint = item.mountPoint, item = item);
    
    elif action == addon.getLocalizedString(50100):  # Remove key files(s)
        xbmc.log("Truecrypt - key files are being changed.", level=xbmc.LOGDEBUG); 
        removeKeyFiles(volume = item.filePath, mountPoint = item.mountPoint, item = item);
    
    elif action == addon.getLocalizedString(50099):     # Add key file(s)
        xbmc.log("Truecrypt - key files are being added.", level=xbmc.LOGDEBUG);
        addKeyFiles(volume = item.filePath, mountPoint = item.mountPoint, item = item);
    elif action == addon.getLocalizedString(50153):   # Mount at startup
        xbmc.log("Truecrypt - item set for startup mounting.", level=xbmc.LOGDEBUG);
        item.setSettings(mountAtStartUp = True);
    elif action == addon.getLocalizedString(50154):   # Turn off mount at startup
        xbmc.log("Truecrypt - startup mounting was turned off.", level=xbmc.LOGDEBUG);
        item.setSettings(mountAtStartUp = False);
    elif action == addon.getLocalizedString(50155):  # Mount with hidden volume protection
        xbmc.log("Truecrypt - special mount.", level=xbmc.LOGDEBUG);
        mountAsHiddenProtected(item),
    elif action == xbmc.getLocalizedString(222):   # cancel
        xbmc.log("Truecrypt action canceled.", level=xbmc.LOGDEBUG);
        pass;


def itemActions(index):
    '''
    The method creates a list (select dialog) for all available actions for selected item based on
    prerequisities and settings of the addon. Afterwards, it will execute selected action.
    :param index: serial number of the item for which actions should be showed
    '''
    item = tcitem.createTCitem(index);
    prerequisitiesOK = checkRequirements(item);
    actions = []; # list of the supported actions

    if prerequisitiesOK:
        mountChecksEnabled = True if addon.getSetting(consts.mountChecks) == consts.trueString else False;
        riskyActionsEnabled = True if addon.getSetting(consts.riskyActions) == consts.trueString else False;
        passwordKeyfileManipulaionEnabled = True if addon.getSetting(consts.passwordAndKeyFileManipulation) == consts.trueString else False;
        mountStatus = tcitem.isMounted(item.filePath, item.mountPoint);
        # creation of the list of actions
        if item.isLocked(): 
            actions.append(addon.getLocalizedString(50065));   # No action availabe as item is locked.
        elif mountStatus == consts.mountPointInUse:
            actions.append(addon.getLocalizedString(50152));   # No action availabe as item is locked.
        else:
            # check if perform mount checks and based on it appends menu
            if mountChecksEnabled:
                if mountStatus == consts.mounted  :
                    actions.append(addon.getLocalizedString(50002));  # Unmount
                else:
                    actions.append(addon.getLocalizedString(50001));   # Mount
            else: # if no checks are performed both possibilities are added
                actions.append(addon.getLocalizedString(50001));   # Mount
                actions.append(addon.getLocalizedString(50002));  # Unmount                    

            actions.append(addon.getLocalizedString(50155));       # Mount with hidden volume protection
            if item.isStoredPassword():
                actions.append(addon.getLocalizedString(50008));          # "Remove stored password"
            elif allowStorePassKey :
                actions.append(addon.getLocalizedString(50007));     # "Store password"
                
            if item.isStoredKeyFilesPath():
                actions.append(addon.getLocalizedString(50103));     # Remove stored key file(s) path
            elif (not item.isStoredKeyFilesPath() and item.useKeyFiles) and allowStorePassKey:
                actions.append(addon.getLocalizedString(50102));      # Store key file(s) path
                
            if item.mountAtStartup:
                actions.append(addon.getLocalizedString(50154));       # Turn off mounting at start up
            else:
                actions.append(addon.getLocalizedString(50153));       # Mount at start up.

            actions.extend([addon.getLocalizedString(50003), addon.getLocalizedString(50004)]);   # "Deactivate", "Reset settings",
            
            if mountChecksEnabled and passwordKeyfileManipulaionEnabled:
                # allow this operation only if checks are 
                actions.append(addon.getLocalizedString(50066));  # Change password
                if item.useKeyFiles:
                    actions.append(addon.getLocalizedString(50101));  # Change key files(s)
                    actions.append(addon.getLocalizedString(50100));   # Remove key files(s)
                else:
                    actions.append(addon.getLocalizedString(50099));   # Add key file(s)
                    

            if riskyActionsEnabled:
                actions.append(xbmc.getLocalizedString(117)); # Delete 
                # allow these operation only if checks are on
                if mountChecksEnabled:
                    actions.append(addon.getLocalizedString(50006));
                    actions.append(addon.getLocalizedString(50005)) ;  #"Format", "Recreate container"
                                 
            actions.append(xbmc.getLocalizedString(222));   # adds Cancel
    else:
        actions.extend([addon.getLocalizedString(50003), addon.getLocalizedString(50004)]);   # "Deactivate", "Reset settings",
        actions.append(xbmc.getLocalizedString(222));   # adds Cancel

    n = xbmcgui.Dialog().select(addon.getLocalizedString(50009),actions);
    action = actions[n];
    xbmc.log("Truecrypt - chosen action: " + action, level=xbmc.LOGDEBUG);
    performAction(action, item)
    del item;
    

def setPassword(item):
    '''
    Initiates storage of the password
    :param item: item for which password should be stored.
    '''
    confirmed = xbmcgui.Dialog().yesno(dialogHeader, addon.getLocalizedString(50015) + " " + addon.getLocalizedString(50016),   # Store password? , It is possible to store password for this file.
                                       addon.getLocalizedString(50017), addon.getLocalizedString(50018)); # This way you won't need to specify it when mounting., It's stored encoded, but be carefull when using this feature.
    if confirmed:
        settingDic = getInformationFromUser( password = True);
        if settingDic == None:
            aborted();
            return;    
        item.setPassword(settingDic[consts.password]);
        del settingDic[consts.password];
        
        
def storeKeyFilePath(item):
    '''
    Initiates storage of the key files path
    :param item: item for which key file path should be stored.
    '''
    confirmed = xbmcgui.Dialog().yesno("Truecrypt. " + addon.getLocalizedString(50113), addon.getLocalizedString(50114),   # Store path to the key files? , It is possible to store key file path for this file.
                                       addon.getLocalizedString(50017), addon.getLocalizedString(50018)); # This way you won't need to specify it when mounting., It's stored encoded, but be carefull when using this feature.
    if confirmed:
        settingDic = getInformationFromUser( keyFilePath = True, item = item);
        if settingDic == None:
            aborted();
            return;        

        item.setSettings(useKeyFiles = True, numberOfKeyFiles = str(settingDic[consts.keyFileNumber]));
        item.setKeyFilesPath(settingDic[consts.keyFiles]);     
        
        del settingDic[consts.keyFiles];

def removeStoredPassword(item):
    '''
    Initiates removal of the stored password
    :param item: item for which password should be removed
    '''
    
    confirmed = xbmcgui.Dialog().yesno(dialogHeader, addon.getLocalizedString(50008), xbmc.getLocalizedString(750));   # Remove stored password, Are you sure?
    if confirmed:
        item.setSettings(password="");
        
def removeStoredKeyFilePath(item):
    '''
    Initiates removal of the stored key files path
    :param item: item for which key files path should be removed
    '''
    confirmed = xbmcgui.Dialog().yesno(dialogHeader, addon.getLocalizedString(50115), xbmc.getLocalizedString(750));   # Remove stored key file path, Are you sure?
    if confirmed:
        item.setSettings(keyFilesPath="");
    confirmed = xbmcgui.Dialog().yesno(dialogHeader, addon.getLocalizedString(50116));     # Remove also stored number of key files?
    if confirmed:
        item.setSettings(numberOfKeyFiles="-1");


def createNewSimpleContainer(volume, mountPoint, size, password, keyFiles = "", fileSystem = "", item = None  ):
    '''
    Method will initiate creation of the simple container. And informs user about actions to be performed and status.
    :param volume: path to the file
    :param mountPoint: mount point to ve used
    :param size: size of the volume in MB
    :param password: password to the container
    :param keyFiles: path to the key files
    :param fileSystem: file system to be used
    :param item: item on which action is perform (only needed when it should lock it in the menu)
    '''
    
    randomDataGenerator = addon.getSetting(consts.randomNumberGenerator);
    xbmc.executebuiltin("Notification(Truecrypt, " + addon.getLocalizedString(50022) + ", 7, " + __icon__ + ")");  # Creation of cantainer started.
    tcitem.createNewFile(volume, mountPoint, size, password, keyFiles, randomDataGenerator, item);
    if fileSystem:
        xbmc.executebuiltin("Notification(Truecrypt, " + addon.getLocalizedString(50033) + ", 7, " + __icon__ + ")");
        format(volume, mountPoint, fileSystem, password, keyFiles, item);
    xbmc.executebuiltin("Notification(Truecrypt, " + addon.getLocalizedString(50054) + ", 7, " + __icon__ + ")"); # Attempting to mount created file.
    success = mountUnmount(volume, mountPoint, password, keyFiles);
    if success :
        xbmcgui.Dialog().ok(dialogHeader, addon.getLocalizedString(50063));
    else:
        xbmcgui.Dialog().ok(dialogHeader, addon.getLocalizedString(50172));
        
    del password, keyFiles;
    return success;

def createItemAndSimpleContainer():
    '''
    It gets the information from user about the container to be created. It will save the information in the item
    if it is allowed. Afterwards it will start creation of the simple container.
    '''
    item = pickItem(False);
    settingDic = getInformationFromUser(itemName = True, newVolumeCreation = True, mountPoint = True, iconPath = True,
                                     password = True, keyFilePath = True, fileSystem = True, volumePath = True);
    if settingDic== None:
        aborted()
        return;
    item.setSettings(name = settingDic[consts.itemName], filePath = settingDic[consts.volume],  
                     drive = settingDic[consts.drive], active = True, icon = settingDic[consts.icon],
                     numberOfKeyFiles = settingDic[consts.keyFileNumber] if storeKeyFileUsage and settingDic[consts.storeKeyFileInfo] == True else "-1",
                     useKeyFiles = False if not storeKeyFileUsage else settingDic[consts.useKeyFiles]);
    
    createNewSimpleContainer(settingDic[consts.volume], settingDic[consts.drive], settingDic[consts.size],
                          settingDic[consts.password], settingDic[consts.keyFiles], settingDic[consts.fileSystem], item);    
    sutilsxbmc.refreshCurrentListing();
    del settingDic[consts.password], settingDic[consts.keyFiles];

def recreateSimpleContainer(item):
    '''
    It will recreate the container for the item.
    :param item: item for which new container should be created.
    '''
    confirmed = xbmcgui.Dialog().yesno(dialogHeader , addon.getLocalizedString(50020), xbmc.getLocalizedString(561) +": " + item.filePath,  addon.getLocalizedString(50019));  #"Continue?" ,"Your current truecrypt file will be removed.", "File: "   Continue?
    if confirmed :
        settingDic = getInformationFromUser(password = True, keyFilePath = True, fileSystem = True, size = True,
                                             newVolumeCreation = True );
        if settingDic == None:
            aborted();
            return;
        
        item.setSettings(numberOfKeyFiles = settingDic[consts.keyFileNumber] if storeKeyFileUsage and settingDic[consts.storeKeyFileInfo] == True else "-1",
                     useKeyFiles = False if not storeKeyFileUsage else settingDic[consts.useKeyFiles],
                     keyFilesPath = "", password = "");
                     
        createNewSimpleContainer(item.filePath, item.mountPoint, settingDic[consts.size], settingDic[consts.password], settingDic[consts.keyFiles],
                                 settingDic[consts.fileSystem], item);    
        sutilsxbmc.refreshCurrentListing();            
                    
        del settingDic[consts.password], settingDic[consts.keyFiles]


def reset(item):
    '''
    It resets / removes all stored setting for the item.
    :param item: item for which remove the setting
    '''
    confirmed = xbmcgui.Dialog().yesno(dialogHeader , addon.getLocalizedString(50024), addon.getLocalizedString(50019));  # All settings for selected item will be removed. Continue?"
    if confirmed:
        item.resetSettings();
    sutilsxbmc.refreshCurrentListing();

def pickFileSystem(includeNTFS = True):
    '''
    It shows dialog where ser can choose file systems to be used and returns it back
    :param includeNTFS: if NTFS should be included in the list as it may case problems when creating hidden volumes
    '''
    if includeNTFS:
        availableFS = ["FAT32", "ext4", "ext3", "ext2", "NTFS", xbmc.getLocalizedString(222)]; # Cancel
    else:
        availableFS = ["FAT32", "ext4", "ext3", "ext2", xbmc.getLocalizedString(222)]; # Cancel
    selected = xbmcgui.Dialog().select(addon.getLocalizedString(50025), availableFS);    # Select file system:
    fileSystem = availableFS[selected];
    if fileSystem == xbmc.getLocalizedString(222):  # Cancel
        return None;
    return fileSystem;


def format(volume, mountPoint, fileSystem, password, keyFiles, item = None):
    '''
    It initiates formating of the volume and checks it requirements (mounted) are in place
    :param volume: volume which to format
    :param mountPoint: mount point
    :param fileSystem: file system to be used
    :param password: password to the volume
    :param keyFiles: path to the key files
    :param item: item on which formating is performed (only to lock it in the menu)
    '''
    if tcitem.isMounted(volume, mountPoint) != consts.mounted:
        tcitem.mount(volume, mountPoint, password, keyFiles);
        if tcitem.isMounted(volume, mountPoint) != consts.mounted:
            xbmcgui.Dialog().ok(dialogHeader, addon.getLocalizedString(50031), addon.getLocalizedString(50032))   # "Error", "Failed to mount file.", "Not proceeding with formatting."
            #item.setSettings(active = True);
            return;
        
    success = tcitem.format(volume, mountPoint, fileSystem, item);
    return success;

def formatExistingVolume(volume, mountPoint, item = None):
    '''
    Mehod initiates user interaction and formating of the existing item
    :param volume: volume on thich perform formating
    :param mountPoint: mount point
    :param item: item on which perform formating
    '''
    confirmed = xbmcgui.Dialog().yesno(dialogHeader ,addon.getLocalizedString(50036), xbmc.getLocalizedString(561) +": " + item.filePath,  addon.getLocalizedString(50019));  # "Continue?" ,"All files in your container will be removed!", "File: " + item.filePath,  "Continue?"
    if confirmed :
        settingsDic =  getInformationFromUser(password = True, keyFilePath = True, fileSystem = True, item = item );
        if settingsDic == None:
            aborted();
            return;
        success = format(volume, mountPoint, settingsDic[consts.fileSystem], settingsDic[consts.password],
                          settingsDic[consts.keyFiles], item);
        tcitem.mount(volume, mountPoint, settingsDic[consts.password], settingsDic[consts.keyFiles]);
        if success and tcitem.isMounted(volume, mountPoint) == consts.mounted :
            tcitem.unmount(volume, mountPoint, item);
            # xbmc.executebuiltin("Notification(Truecrypt, " + addon.getLocalizedString(50037) + ", 5, " + __icon__ + ")");   # Container mounted successfully after formatting.
            xbmcgui.Dialog().ok(dialogHeader, addon.getLocalizedString(50062));
        elif success :
            xbmcgui.Dialog().ok(dialogHeader, addon.getLocalizedString(50038));   # "Failed to mount file after formatting."
        else :
            xbmcgui.Dialog().ok(dialogHeader, addon.getLocalizedString(50061));
        del settingsDic[consts.password], settingsDic[consts.keyFiles];
        return;

def changePassword(volume, item):
    '''
    Initiates user interaction and change of password.
    :param volume: volume on which task should be performed
    :param item: item on which task is performed (only to lock it in the menu)
    '''
    settingsDic =  getInformationFromUser(item = item, password = True, changePassword = True, keyFilePath = True );
    if settingsDic == None:
        aborted()
        return;
    
    xbmc.executebuiltin("Notification(Truecrypt, " + addon.getLocalizedString(50122) + ", 7, " + __icon__ + ")")
    success = tcitem.changePassword(volume,settingsDic[consts.password], settingsDic[consts.newPassword],
                                      settingsDic[consts.keyFiles], item);

    if success :
        xbmcgui.Dialog().ok(dialogHeader, addon.getLocalizedString(50067));  # Password changed successfully
        if item != None:
            item.setSettings(password = ""); # deletes old saved password

    else :
        xbmcgui.Dialog().ok(dialogHeader, addon.getLocalizedString(50068), tcitem.getErrorMessage());   # Error , Failed to change password
    del settingsDic[consts.password], settingsDic[consts.newPassword], settingsDic[consts.keyFiles];
    return;

def delete(item):
    '''
    Initiates user interaction and deletion of the volume.
    :param item: item on which task is performed
    '''
    
    confirmed = xbmcgui.Dialog().yesno(dialogHeader, addon.getLocalizedString(50069) + " " + xbmc.getLocalizedString(750), addon.getLocalizedString(50060)+": " + item.name, xbmc.getLocalizedString(561) +": " + item.filePath);    #"Delete file?", "Are you sure?", "Item: " + item.name,"File: " + item.filePath
    if confirmed :
        # @type item resources.lib.tcitem
        success = item.delete();
        if not success:
            xbmcgui.Dialog().ok(dialogHeader, addon.getLocalizedString(50059), tcitem.getErrorMessage());    #  "Failed to delete specified file."
        else:
            xbmcgui.Dialog().ok(dialogHeader, addon.getLocalizedString(50057));   #  "File deleted sucessfully.")
            item.resetSettings();
    sutilsxbmc.refreshCurrentListing();
    
def checkRequirements(item): 
    '''
    Method checks the requirements for for the item in order to allow tasks. Existemce of volume, sh script and mount point are 
    checked. If mount point is missinig it will create it if allowed in addon settings.  
    :param item: item for which check the requirements
    '''
    if not os.path.exists(tcitem.shellScript):
        Dialog = xbmcgui.Dialog().ok(dialogHeader, addon.getLocalizedString(50071));  #   The Setting for the Truecrypt script is wrong or missing.
        return False;
    if not os.path.exists(item.filePath):
        Dialog = xbmcgui.Dialog().ok(dialogHeader, addon.getLocalizedString(50072), addon.getLocalizedString(50160));  #   The Setting for the TC File / prati to mount is wrong or missing.
        return False;
    if  item.mountPoint == "" or not os.path.exists(item.mountPoint):
        if addon.getSetting( consts.createFolders ) == consts.trueString:
            os.makedirs(item.mountPoint);
        else: 
            Dialog = xbmcgui.Dialog().ok(dialogHeader, addon.getLocalizedString(50073));  # No mount point/drive was specified or doesn't exists
            return False;
    return True;

def checkVolumeLock(path):
    '''
    The methos will check if the volume is locked. The method is used when file is being unmounted
    from the main menu and not from item menu. This is done in order to avoid unmount of the volume 
    on which other processes of this addon are running,
    :param path: path of the volume to be checked
    '''
    path = tcitem.getRealFilePath(path);
    
    activeItems = tcitem.getTCitems(True);
    
    for item in activeItems:
        if item.isLocked():
            p = tcitem.getRealFilePath(item.filePath);
            if p == path:
                return True;
    
    return False;
    


def mountDrive(volume = None, mountPoint = None, item = None, mountAtStartup = False):
    '''
    The method gets information from user and initialize mounting.
    :param volume: volume to be mounted
    :param mountPoint: mount point
    :param item: item if available
    :param mountAtStartup: it tells if the mounting is done during start up.
    '''
    # create and exec command
    settingDic = getInformationFromUser(volumePath = True if volume == None else False,
                                        mountPoint = True if mountPoint == None else False,
                                        password = True, keyFilePath = True, item = item, mountAtStartup = mountAtStartup);
    if settingDic == None:
        return;
             
    tcitem.mount(filePath = settingDic[consts.volume] if volume == None else volume,
                  mountPoint = settingDic[consts.drive] if mountPoint == None else mountPoint,
                  password = settingDic[consts.password], keyFiles = settingDic[consts.keyFiles],
                  item = item);
    if addon.getSetting(consts.mountChecks) == consts.trueString:
        mounted = True if tcitem.isMounted(filePath = settingDic[consts.volume] if volume == None else volume, 
                                            mountPoint = settingDic[consts.drive] 
                                            if mountPoint == None else mountPoint) == consts.mounted else False ;
        if mounted :
            sutilsxbmc.refreshCurrentListing();
            xbmc.executebuiltin("Notification(Truecrypt, " + addon.getLocalizedString(50048) + ", 7, " + __icon__ + ")");   # The truecrypt drive is now mounted.
        else:
            errStr=tcitem.getErrorMessage();
            xbmcgui.Dialog().ok(dialogHeader,addon.getLocalizedString(50049) , errStr);   # "The truecrypt drive failed to mount."
    del settingDic[consts.password], settingDic[consts.keyFiles];


def getMountedVolumeAndMountPoint():
    '''
    The method inialzes searching for all mouted volumes and used mount points. It lets user select one of the found mounted volumes
    and returns volume path and mount point. It is used for general ummouting of device. 
    '''
    dic = tcitem.moutedFileListWithMoutPoints();
    array= [];
    if dic != None:
        keys = dic.keys();    
        for key in keys :
            array.append(key + " on " + dic[key]);
        array.append(xbmc.getLocalizedString(222));   # adds Cancel
    else:
        array.append(addon.getLocalizedString(50165));   # No volume is mounted        
    
        
    n = xbmcgui.Dialog().select(addon.getLocalizedString(50156), array);
      
    if n == -1 or n == (len(array) - 1):
        return (None, None);
    xbmc.log("Truecrypt: file: " + str(keys[n] + " mount point: " + keys[n]), level=xbmc.LOGDEBUG);
    return(keys[n], dic[keys[n]] );
        
    

def unmountDrive(volume = None, mountPoint = None, item = None):
    '''
    It initializes unmount of the device. In Case volume and mount point are not provided it will check for all mounted volumes and let
    user select which should be unmounted + checks if the volume is not locked.
    :param volume: path to the volume
    :param mountPoint: mount point
    :param item: item
    '''
    if volume == None or mountPoint == None:
        volume, mountPoint = getMountedVolumeAndMountPoint();
        if volume == None or mountPoint == None:
            return;
        if checkVolumeLock(volume):
            xbmcgui.Dialog().ok(dialogHeader, addon.getLocalizedString(50170), addon.getLocalizedString(50171));      #  Not proceeding with unmout    Volume is locked by other internal process.
            return;
        
    tcitem.unmount(filePath = volume, mountPoint = mountPoint);
    
    if addon.getSetting(consts.mountChecks) == consts.trueString:
        mounted = True if tcitem.isMounted(filePath = volume, mountPoint = mountPoint) == consts.mounted else False;
        if not mounted :
            xbmc.executebuiltin("Notification(Truecrypt, " + addon.getLocalizedString(50050) + ", 7, " + __icon__ + ")");
            sutilsxbmc.refreshCurrentListing();
        else:
            xbmc.log("TrueCrypt Drive Failed to unmount." + " " + tcitem.getErrorMessage(), level=xbmc.LOGDEBUG);
            xbmcgui.Dialog().ok(dialogHeader, addon.getLocalizedString(50055), tcitem.getErrorMessage());   #  "The truecrypt drive failed to unmount."

def addKeyFiles(volume = None, mountPoint = None, item = None):
    '''
    It will add key files to TC volume. It will ask user for the necessary data if needed.
    :param mountPoint: mount point 
    :param volume: path to the volume
    :param item: item on which perform the task (only to lock it in the menu)
    '''
    settingDic = getInformationFromUser(volumePath = True if volume == None else False,
                               mountPoint = True if mountPoint == None else False,
                               password = True, keyFilePath = True); 
    if settingDic == None:
        aborted();
        return;
    
    if tcitem.isMounted(filePath = settingDic[consts.volume] if volume == None else volume,
                         mountPoint = settingDic[consts.drive] if mountPoint == None else mountPoint) == consts.mounted:
        proceed = xbmcgui.Dialog().yesno(dialogHeader, addon.getLocalizedString(50104) + " " +
                                         addon.getLocalizedString(50105));
        if not proceed:
            return;
        else:
            tcitem.unmount(filePath = settingDic[consts.volume] if volume == None else volume,
                            mountPoint = settingDic[consts.drive] if mountPoint == None else mountPoint);
                            
    xbmc.executebuiltin("Notification(Truecrypt, " + addon.getLocalizedString(50122) + ", 7, " + __icon__ + ")");        
    success = tcitem.addKeyFiles(filePath = settingDic[consts.volume] if volume == None else volume,
                                  password = settingDic[consts.password], keyFiles = settingDic[consts.keyFiles],
                                  item = item);
    
    if success:
        xbmcgui.Dialog().ok(dialogHeader, addon.getLocalizedString(50106));
        if storeKeyFileUsage and item != None:
            getInformationFromUser(dic = settingDic, storeNewKeyFileNumber = True);
        if item  != None:
            item.setSettings(useKeyFiles = True if storeKeyFileUsage else False,
                             numberOfKeyFiles = str(settingDic[consts.keyFileNumber]) if storeKeyFileUsage and settingDic[consts.storeKeyFileInfo] else "-1",
                             keyFilesPath = "");
    else:
        xbmcgui.Dialog().ok(dialogHeader, addon.getLocalizedString(50107), tcitem.getErrorMessage());
        
    del settingDic[consts.password], settingDic[consts.keyFiles]
        
def removeKeyFiles(volume = None, mountPoint = None, item = None):
    '''
    It will remove used key files from TC file. It will ask user for the necessary data if needed.
    :param mountPoint: mount point 
    :param volume: path to the volume
    :param item: item on which perform the task (only to lock it in the menu)
    '''
    settingDic = getInformationFromUser(volumePath = True if volume == None else False,
                               mountPoint = True if mountPoint == None else False,
                               item = item , password = True, keyFilePath = True); 
    if settingDic == None:
        aborted();
        return;
    
    if tcitem.isMounted(filePath = settingDic[consts.volume] if volume == None else volume,
                         mountPoint = settingDic[consts.drive] if mountPoint == None else mountPoint) == consts.mounted:
        proceed = xbmcgui.Dialog().yesno(dialogHeader, addon.getLocalizedString(50104) + " " +
                                         addon.getLocalizedString(50105));
        if not proceed:
            return;
        else:
            tcitem.unmount(filePath = settingDic[consts.volume] if volume == None else volume,
                            mountPoint = settingDic[consts.drive] if mountPoint == None else mountPoint);
    
    xbmc.executebuiltin("Notification(Truecrypt, " + addon.getLocalizedString(50122) + ", 7, " + __icon__ + ")")   
    success = tcitem.removeKeyFiles(filePath = settingDic[consts.volume] if volume == None else volume, 
                                     password = settingDic[consts.password], keyFiles = settingDic[consts.keyFiles],
                                     item = item);                                     
        
    if success:
        xbmcgui.Dialog().ok(dialogHeader, addon.getLocalizedString(50106));
        if item != None:
            item.setSettings(useKeyFiles = False, numberOfKeyFiles = "-1", keyFilesPath = "");
    else:
        xbmcgui.Dialog().ok(dialogHeader, addon.getLocalizedString(50107), tcitem.getErrorMessage());
        
    del settingDic[consts.password], settingDic[consts.keyFiles];

def changeKeyFiles(volume = None, mountPoint = None, item = None):
    '''
    Method will change used key files. It will ask user for all necessary information when needed.
    :param mountPoint: mount point 
    :param volume: path to the volume
    :param item: item on which perform the task (only to lock it in the menu)
    '''
    
    settingDic = getInformationFromUser(volumePath = True if volume == None else False,
                               mountPoint = True if mountPoint == None else False,
                               item = item , password = True, keyFilePath = True, changeKeyFiles = True); 
    if settingDic == None:
        aborted();
        return;
    
    if tcitem.isMounted(filePath = settingDic[consts.volume] if volume == None else volume,
                         mountPoint = settingDic[consts.drive] if mountPoint == None else mountPoint) == consts.mounted:
        proceed = xbmcgui.Dialog().yesno(dialogHeader, addon.getLocalizedString(50104) + " " +
                                         addon.getLocalizedString(50105));
        if not proceed:
            return;
        else:
            tcitem.unmount(filePath = settingDic[consts.volume] if volume == None else volume,
                            mountPoint = settingDic[consts.drive] if mountPoint == None else mountPoint);
    
    xbmc.executebuiltin("Notification(Truecrypt, " + addon.getLocalizedString(50122) + ", 7, " + __icon__ + ")")                        
    success = tcitem.changeKeyFiles(filePath = settingDic[consts.volume] if volume == None else volume,
                                    password = settingDic[consts.password], oldKeyFiles = settingDic[consts.keyFiles], 
                                    newKeyFiles = settingDic[consts.newKeyFiles], item = item);                                    

    if success:                    
        xbmcgui.Dialog().ok(dialogHeader, addon.getLocalizedString(50106));
        if storeKeyFileUsage and item != None:
            getInformationFromUser(dic = settingDic, storeNewKeyFileNumber = True);
        if item != None:
            item.setSettings(useKeyFiles = True if storeKeyFileUsage else False,
                             numberOfKeyFiles = str(settingDic[consts.newKeyFileNumber]) if storeKeyFileUsage and settingDic[consts.storeKeyFileInfo] else "-1",
                             keyFilesPath = "");
    else:
        xbmcgui.Dialog().ok(dialogHeader, addon.getLocalizedString(50107), tcitem.getErrorMessage());    
    
    del settingDic[consts.password], settingDic[consts.keyFiles], settingDic[consts.newKeyFiles];

def createVolumeWithHiddenVolume():
    '''
    Method creates new volume with hidden volume. It will ask user for all needed information and will exit if the information is 
    not OK for this kind of volumes. Also, it will save the infomation in the item if it is allowed.
    '''
    item = pickItem(False);
    # getting information from user
    settingDic =  getInformationFromUser(newVolumeCreation = True, volumePath = True, mountPoint = True, iconPath = True,
                                          itemName = True, password = True, hidden = True, fileSystem = True, item = item);                                         
    
    if settingDic == None:
        aborted();
        return;
    useKeyFiles =  True if (not settingDic[consts.outerKeyFiles] == "" or not settingDic[consts.hiddenKeyFiles] == "") and storeKeyFileUsage else False;
    
    # saving information in item if allowed
    item.setSettings(name = settingDic[consts.itemName], filePath = settingDic[consts.volume],
                     drive = settingDic[consts.drive], active = True, icon = settingDic[consts.icon],
                     numberOfKeyFiles = "-1", useKeyFiles = useKeyFiles);
    
    
    # setting varialble name as its easier to work with than with dictionairy
    filePath = settingDic[consts.volume];    
    drive = settingDic[consts.drive];
        
    # outer volume parameters
    outerPass = settingDic[consts.outerPassword];
    outerKeyFiles = settingDic[consts.outerKeyFiles];
    outerSize =  settingDic[consts.outerSize];
    
    # hidden volume parameters
    hiddenPass = settingDic[consts.hiddenPassword];
    hiddenKeyFiles = settingDic[consts.hiddenKeyFiles];
    if hiddenPass == "" and hiddenKeyFiles == "":
        aborted();
        return;    
    
    hiddenSize = settingDic[consts.hiddenSize];
    
    if int(hiddenSize) >= int(outerSize):
        aborted(addon.getLocalizedString(50128));   # Size of hidden volume is bigger or the same as size of outer volume.
        return;
    
    fileSys = settingDic[consts.fileSystem] if settingDic[consts.fileSystem] != "" else "FAT32";
    randomDataGenerator = addon.getSetting(consts.randomNumberGenerator);
    
    item.lock(addon.getLocalizedString(50053));
    sutilsxbmc.refreshCurrentListing();
    xbmc.executebuiltin("Notification(Truecrypt, " + addon.getLocalizedString(50053) + ", 7, " + __icon__ + ")");
    
    success = tcitem.createVolumeWithHiddenVolume(filePath, drive, outerPass, outerKeyFiles, outerSize, 
                                                  hiddenPass, hiddenKeyFiles, hiddenSize, fileSys, randomDataGenerator);
    if success :
        xbmcgui.Dialog().ok(dialogHeader, addon.getLocalizedString(50063),addon.getLocalizedString(50157), addon.getLocalizedString(50158));
    else: 
        xbmcgui.Dialog().ok(dialogHeader, addon.getLocalizedString(50159));  # failed to create new volume
    
    item.unlock();
    sutilsxbmc.refreshCurrentListing();
    del outerPass, outerKeyFiles, hiddenPass, hiddenKeyFiles;
    del settingDic;

def mountAsHiddenProtected(item = None):
    '''
    Method will get information from the user and will initialize mounting of the drive with hidden volume protection.
    :param item: item on which perform the mount. It can be None
    '''
    
    settingDic = getInformationFromUser(volumePath = True if item == None else False,
                                        mountPoint = True if item == None else False,
                                        hidden = True, password = True, keyFilePath = True);
    volumePath = settingDic[consts.volume] if item == None else item.filePath;
    mountPoint = settingDic[consts.drive] if item == None else item.mountPoint;
    
    tcitem.mountAsHiddenProtected(volumePath, mountPoint, settingDic[consts.outerPassword], settingDic[consts.outerKeyFiles],
                                  settingDic[consts.hiddenPassword], settingDic[consts.hiddenKeyFiles]);
                                  
    if addon.getSetting(consts.mountChecks) == consts.trueString:
        mounted = True if tcitem.isMounted(filePath = volumePath, mountPoint = mountPoint) == consts.mounted else False;
        if mounted :
            sutilsxbmc.refreshCurrentListing();
            xbmc.executebuiltin(u"Notification(Truecrypt, " + addon.getLocalizedString(50048) + ", 7, " + __icon__ + ")");   # The truecrypt drive is now mounted.
        else:
            errStr=tcitem.getErrorMessage();
            xbmcgui.Dialog().ok(dialogHeader,addon.getLocalizedString(50049) , errStr);   # "The truecrypt drive failed to mount."
    del settingDic[consts.outerPassword], settingDic[consts.outerKeyFiles], settingDic[consts.hiddenPassword], settingDic[consts.hiddenKeyFiles];
    
    
def getInformationFromUser(itemName = False, newVolumeCreation = False, volumePath = False, mountPoint = False,
                            password = False, keyFileUsage = False, hidden = False, iconPath = False, item = None,
                            fileSystem = False, changePassword = False, changeKeyFiles = False, keyFilePath = False,
                            createKeyFile = False , active = consts.trueString, dic = None, storeNewKeyFileNumber = False, 
                            size = False, mountAtStartup = False):
    '''
    This method is a centralized way of getting user imputs. Based on the supplied parameters (booleans), it will ask user to provide data.
    it return dictionairy.
    :param itemName: item name
    :param newVolumeCreation: retruns all parameters needed during volume creation
    :param volumePath: path to the volume
    :param mountPoint: mount point
    :param password:
    :param keyFileUsage: tells if key files are used
    :param hidden: specifies that it is for hidden volume - more imputs are returned
    :param iconPath: ican path
    :param item: item whcih is connected with the request
    :param fileSystem: file system 
    :param changePassword: when changing password
    :param changeKeyFiles: when changing key files
    :param keyFilePath: path of the key files
    :param createKeyFile: returns parameters connected with new volume creation
    :param active: if item is active
    :param dic: dictionary into which data should be saved. If None, new dic is returned 
    :param storeNewKeyFileNumber: if key file path should be stored
    :param size: size of the volume
    :param mountAtStartup: if asked during start up mounting
    '''
    dic = dic if dic != None else {};
    name = None;
    if itemName:
        if item == None:
            name = sutilsxbmc.getStringFromUser(addon.getLocalizedString(50043), False, "");  #"Please enter display name"
        else:
            name = sutilsxbmc.getStringFromUser(addon.getLocalizedString(50043), False, item.name);  # "Please enter display name"
        if name =="":
            return;
        dic[consts.itemName]=name;
    
    if volumePath & newVolumeCreation:
        folder = sutilsxbmc.getFilePathFromUser(3, addon.getLocalizedString(50044));   # Select folder for new file"
        fileName = sutilsxbmc.getStringFromUser(xbmc.getLocalizedString(16013), False, name if name != None else ""); #16013 - Enter new filename
        if folder == "" or file =="":
            return None;
        filePath=os.path.join(folder, fileName);
        dic[consts.volume]=filePath;
        
        
    if volumePath and not newVolumeCreation:
        n = xbmcgui.Dialog().select(addon.getLocalizedString(50149), consts.arrayVolumeType);
        if consts.arrayVolumeType[n] == addon.getLocalizedString(50150): 
            filePath = sutilsxbmc.getFilePathFromUser(1, addon.getLocalizedString(50045));    # Select file
        elif consts.arrayVolumeType[n] == xbmc.getLocalizedString(222):
            filePath = None;
        else:
            filePath = choosePartition();
        if not filePath:
            return None;
        dic[consts.volume]=filePath;
    
    if mountPoint:
        drive = sutilsxbmc.getFilePathFromUser(3, addon.getLocalizedString(50046));     # Select mount point/drive
        if drive == "":
            return None;
        dic[consts.drive]=drive;
    
        
    if (password or changePassword or newVolumeCreation) and not hidden:  # also used when change of password will come 
        if newVolumeCreation:
            password = sutilsxbmc.getConfirmedPassword();
        elif item != None and item.isStoredPassword() :
            password = item.getPassword();
        elif mountAtStartup:
            password = sutilsxbmc.getStringFromUser(heading = addon.getLocalizedString(50146) + " " + item.name +
                                                    " (" +item.filePath + ")", hidden = True);    # Enter password for
        else:
            password = sutilsxbmc.getStringFromUser(heading = addon.getLocalizedString(50011), hidden = True);    # Enter password
        dic[consts.password] = password;
        
    if changePassword:
        dic[consts.newPassword] = sutilsxbmc.getConfirmedPassword(header1 = addon.getLocalizedString(50136));    # Enter new password
        
    if ((keyFileUsage and storeKeyFileUsage) or newVolumeCreation) and not hidden:
        numberOfKeyFiles = -1;
        keyFilesUsed = xbmcgui.Dialog().yesno(dialogHeader, addon.getLocalizedString(50098) if newVolumeCreation else addon.getLocalizedString(50095) );   # Would you like to use key files? /"Are key file(s) used?"
        storeKeyFileNumber = False;
        if keyFilesUsed and storeKeyFileUsage:
            storeKeyFileNumber = xbmcgui.Dialog().yesno(dialogHeader, addon.getLocalizedString(50096), addon.getLocalizedString(50097));  # "Would you like to store key files number?" , "Otherwise it will always ask for it."
            if storeKeyFileNumber:
                numberOfKeyFiles = getNumberOfKeyFiles();            
        dic[consts.storeKeyFileInfo] = storeKeyFileNumber;
        dic[consts.keyFileNumber]= "-1" if not storeKeyFileNumber else str(numberOfKeyFiles);  
        dic[consts.useKeyFiles]= consts.trueString if keyFilesUsed else consts.falseString;
        
    if (keyFilePath or changeKeyFiles or newVolumeCreation) and not hidden:
        if newVolumeCreation:
            if numberOfKeyFiles == -1 and  keyFilesUsed:
                numberOfKeyFiles = getNumberOfKeyFiles();
            path = getKeyFilesPathFromUser(numberOfKeyFiles);
        elif item != None and item.useKeyFiles:
            numberOfKeyFiles = item.numberOfKeyFiles
            if item.isStoredKeyFilesPath():                
                path = item.getKeyFilesPath();
            elif item.numberOfKeyFiles > 0:
                path = getKeyFilesPathFromUser(numberOfKeyFiles);
            elif item.numberOfKeyFiles == -1:
                numberOfKeyFiles = getNumberOfKeyFiles()
                path = getKeyFilesPathFromUser(numberOfKeyFiles);
        elif item != None and not item.useKeyFiles and storeKeyFileUsage:
            numberOfKeyFiles = "-1"
            path = "";
        else:
            numberOfKeyFiles = getNumberOfKeyFiles();
            path = getKeyFilesPathFromUser(numberOfKeyFiles);
        dic[consts.keyFiles] = path;
        dic[consts.keyFileNumber] = numberOfKeyFiles;
        
    if changeKeyFiles:
        newKeyFileNu = getNumberOfKeyFiles(header = addon.getLocalizedString(50137));
        newKeyPath = getKeyFilesPathFromUser(newKeyFileNu);
        if newKeyFileNu == "" or newKeyPath == "":
            return None;
        dic[consts.newKeyFiles] = newKeyPath;
        dic[consts.newKeyFileNumber] = str(newKeyFileNu);
    
    if storeNewKeyFileNumber:
        dic[consts.storeKeyFileInfo]  = xbmcgui.Dialog().yesno(dialogHeader, addon.getLocalizedString(50096), addon.getLocalizedString(50097));  # "Would you like to store key files number?" , "Otherwise it will always ask for it."
        
    if (newVolumeCreation or size) and not hidden:
        s = sutilsxbmc.getNumberFromUser(0, addon.getLocalizedString(50021));   # Enter size of outer volume in MB.
        if s == "" :
            return;
        size = (int(s) * 1024 * 1024);     
        dic[consts.size] = str(size);
    
    # get data for a hidden volume    
    if hidden:
        # outer volume parameters
        if password or newVolumeCreation:
            if newVolumeCreation:
                outerPass = sutilsxbmc.getConfirmedPassword(addon.getLocalizedString(50139), addon.getLocalizedString(50140)); # enter password for outer volume  / re-enter password for outer volume
            else:
                outerPass = sutilsxbmc.getStringFromUser(addon.getLocalizedString(50139), True);   # enter password for outer volume
            dic[consts.outerPassword] = outerPass;
         
        if keyFilePath or newVolumeCreation:
            outerKeyFilesNumber = getNumberOfKeyFiles(header = addon.getLocalizedString(50126)); # "Select number of key files for outer volume"
            outerKeyFiles = getKeyFilesPathFromUser(outerKeyFilesNumber);
            dic[consts.outerKeyFiles] = str(outerKeyFilesNumber);   
            dic[consts.outerKeyFiles] = outerKeyFiles;
            
        if dic[consts.outerPassword] == "" and dic[consts.outerKeyFiles] == "":
            return;  
        
        if newVolumeCreation:
            s = sutilsxbmc.getNumberFromUser(0, addon.getLocalizedString(50129));   # Enter size of outer volume in MB.
            if s == "" :
                return;
            outerSize = (int(s) * 1024 * 1024);     
            dic[consts.outerSize] = str(outerSize);
            
        # hidden volume parameters
        if password or newVolumeCreation:
            if newVolumeCreation:
                hiddenPass = sutilsxbmc.getConfirmedPassword(addon.getLocalizedString(50141), addon.getLocalizedString(50142));   # enter password for hidden volume / re-enter password for hidden volume
            else:
                hiddenPass = sutilsxbmc.getStringFromUser(addon.getLocalizedString(50141), True);  # enter password for hidden volume
            dic[consts.hiddenPassword] = hiddenPass;
        
        if keyFilePath or newVolumeCreation:   
            hiddenKeyFilesNumber = getNumberOfKeyFiles(header = addon.getLocalizedString(50127)); 
            hiddenKeyFiles = getKeyFilesPathFromUser(hiddenKeyFilesNumber);    # Select number of key files for hidden volume"
            dic[consts.hiddenKeyFiles] = str(hiddenKeyFilesNumber);   
            dic[consts.hiddenKeyFiles] = hiddenKeyFiles;
            
        if dic[consts.hiddenPassword] == "" and dic[consts.hiddenKeyFiles] == "":
            return;    
        
        if newVolumeCreation:
            s = sutilsxbmc.getNumberFromUser(0, addon.getLocalizedString(50130));   # Enter size of hidden volume in MB.
            if s == "" :
                return;
            hiddenSize = (int(s) * 1024 * 1024);
            dic[consts.hiddenSize] = str(hiddenSize);
            
                        
    if fileSystem or newVolumeCreation:
        fileSys= pickFileSystem(False if hidden else True);
        if fileSys == None:
            return;
        dic[consts.fileSystem] = fileSys;
    
    if iconPath:
        icon = sutilsxbmc.getFilePathFromUser(2, addon.getLocalizedString(50047));      # Select icon (optional)
        dic[consts.icon]=icon;
        
    dic[consts.active]=active;
    
    if createKeyFile:
        folder = sutilsxbmc.getFilePathFromUser(0, addon.getLocalizedString(50044));  # Select folder for new file
        if folder =="":
            return;        
        fileName = sutilsxbmc.getStringFromUser(xbmc.getLocalizedString(16013)); # Enter new file name
        if fileName =="":
            return;        
        dic[consts.keyFiles] = os.path.join(folder, fileName);
    
    return dic;

def aborted(message1 ="", message2=""):
    '''
    Informs user that operaion was borted
    :param message1: reason why 1 (optional)
    :param message2: reason why 2 (optional)
    '''    
    xbmcgui.Dialog().ok(dialogHeader, xbmc.getLocalizedString(16200), message1, message2); #   Operation was aborted

def pickItem(active = None):
    '''
    Method lets user decide which item should be used for the action and returns it.
    :param active: if active only items should be concidered. None means all items (even not assigned).
    '''
    items = tcitem.getTCitems(active);
    displayNames = [];
    displayNamesToItems = {};
    for item in items:
        tempName = item.name;
        tcFile= item.filePath;
        if not tcFile == "" :
            tempName += " ("+ addon.getLocalizedString(50052) + ": " + tcFile + ")"   # assigned file

        displayNames.append(tempName);
        displayNamesToItems[tempName] = item;
    
    displayNames.append(xbmc.getLocalizedString(222));   # adds Cancel
    displayNamesToItems[xbmc.getLocalizedString(222)] = None;
        
    selected = xbmcgui.Dialog().select(addon.getLocalizedString(50051), displayNames);   # "Select item:"
    selectedItem = displayNamesToItems.get(displayNames[selected]);

    return selectedItem;

def assignExistinVolume():
    '''
    It lets user assign existing volume to the chosen item through simple guide.
    '''
    item = pickItem(False);
    if item == None:
        return;
    
    settingDic = getInformationFromUser(item = item, itemName = True, volumePath = True, mountPoint = True, 
                                        iconPath = True, keyFileUsage = True if storeKeyFileUsage else False);
    if settingDic == None :
        aborted();
        return;
    item.setSettings(name = settingDic[consts.itemName], filePath = settingDic[consts.volume],  
                     drive = settingDic[consts.drive], active = True, icon = settingDic[consts.icon],
                     numberOfKeyFiles = -1 if not storeKeyFileUsage else settingDic[consts.keyFileNumber],
                     useKeyFiles = False if not storeKeyFileUsage else settingDic[consts.useKeyFiles]);

    sutilsxbmc.refreshCurrentListing();




def mountUnmount( volume, mountPoint, password, keyFiles):    
    '''
    Method preforms mounting and oumounting of the volume. This is done as a test if volume is fully funtional.
    Returns True if successfull 
    :param volume: path to the volume
    :param mountPoint: mount point
    :param password: password 
    :param keyFiles: key file path
    '''
    tcitem.mount(volume, mountPoint, password, keyFiles);
        
    if addon.getSetting(consts.mountChecks) == consts.trueString:
        if tcitem.isMounted(volume, mountPoint) == consts.mounted :
            xbmc.executebuiltin("Notification(Truecrypt, " + addon.getLocalizedString(50048) + ", 7, " + __icon__ + ")"); # mount successfull
            tcitem.unmount(volume, mountPoint);
            if tcitem.isMounted(volume, mountPoint) == consts.notMounted :
                xbmc.executebuiltin("Notification(Truecrypt, " + addon.getLocalizedString(50050) + ", 7, " + __icon__ + ")");  # drive unmounted...
                return True;
            else:
                return False;
        else:
            return False;
    else:
        xbmc.executebuiltin("Notification(Truecrypt, " + addon.getLocalizedString(50048) + ", 7, " + __icon__ + ")"); # mount successfull
        tcitem.unmount(volume, mountPoint);
        xbmc.executebuiltin("Notification(Truecrypt, " + addon.getLocalizedString(50050) + ", 7, " + __icon__ + ")");  # drive unmounted...
        return True;  # if checks are disabled, assert that it was sucessful...  

def createKeyFile():    
    '''
    Method initializes creation of key file and gets path from user.
    '''
    randomDataGenerator = addon.getSetting(consts.randomNumberGenerator);
    setting = getInformationFromUser(createKeyFile = True);
    if setting == None:
        return;
    
    success = tcitem.createKeyFile(setting[consts.keyFiles], randomDataGenerator);
    
    if  success:
        xbmcgui.Dialog().ok(dialogHeader, addon.getLocalizedString(50091));  #   Key file created successfuly.
        pass;
    else:
        xbmcgui.Dialog().ok(dialogHeader, addon.getLocalizedString(50088));  # Failed to create key file.
                           
def getKeyFilesPathFromUser(numberOfFiles):
    '''
    The method gets paths of the key files from the user and concatenates it.
    :param numberOfFiles: How many paths should be asked
    '''
  
    filesPaths = "";
    for x in range(0, numberOfFiles):
        filesPaths = (filesPaths + "," if len(filesPaths) > 0 else "") + sutilsxbmc.getFilePathFromUser(1, addon.getLocalizedString(50092) + str(x + 1));
    return filesPaths;

def getNumberOfKeyFiles(header=addon.getLocalizedString(50164)):     # select number of key files
    '''
    Method returns number of key files from user associated with volume. 
    :param header: dialog header (optional)
    '''
    arrayForNuOfKeyFiles = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];
    numberOfFiles = xbmcgui.Dialog().select(header, arrayForNuOfKeyFiles);
    return int(numberOfFiles);

def getKeyFileInformation(item = None, header=addon.getLocalizedString(50164)):   # select number of key files
    '''
    It returns paths to the all used key files as a string. It will ask user how many key files
    are used if needed (numberOfFiles = -1) and will trigger asking user for the files. In case key files are not used,
    it will return empty string.
    :param item: item for which key file information is needed (optional)
    :param header: dialogue header (optional)
    '''

    keyFilesPath = "";
    
    if item == None or item.useKeyFiles:
        
        if item != None and item.isStoredKeyFilesPath():
            keyFilesPath = item.getKeyFilesPath();             
        else:
            numberOfKeyFiles = -1 if item == None else int(item.numberOfKeyFiles);
            if numberOfKeyFiles == -1:
                numberOfKeyFiles = getNumberOfKeyFiles(header);
            if keyFilesPath == "":
                keyFilesPath = getKeyFilesPathFromUser(numberOfKeyFiles);   
                
    return keyFilesPath;

def choosePartition():
    '''
    It lets user decide which partition should be used. It will get all sdx and hdx partitions. After user chooses it,
    it will search for asociated /dev/disk/by-id to make the link persistent.
    '''
    partitions = tcitem.getPartitions();
    array = [];
    
    xbmc.log("Nuber of found partitions: " + str(len(partitions)), level=xbmc.LOGDEBUG);
    for partition in partitions:
        label = tcitem.getPartitionLabel(partition);
        array.append(partition + ("" if label == None else " (" + label + ")"));
        
    array.append(xbmc.getLocalizedString(222));   # adds Cancel  
      
    n = xbmcgui.Dialog().select(addon.getLocalizedString(50148), array);
    chosenPartition = None if n == -1 or n == (len(array) - 1) else "/dev/" + partitions[n];
    if chosenPartition == None:
        return;
    byId = tcitem.getPartitionById(chosenPartition);
    
    xbmc.log("truecrypt chosen partition: " + ("None" if chosenPartition == None else chosenPartition), level=xbmc.LOGDEBUG);
    xbmc.log("truecrypt partition by-id: " + ("None" if byId == None or byId == ""  else byId), level=xbmc.LOGDEBUG);    
    
    chosenPartition = byId if (byId != None and byId != "") else chosenPartition;
    return chosenPartition;
    
def createNewVolumeByType():
    '''
    Lets user decide what kind of volume (container) should be created - simple or with hidden volume
    '''
    array = [addon.getLocalizedString(50150), addon.getLocalizedString(50162)];     # "volume", "volume with hidden volume"
    array.append(xbmc.getLocalizedString(222));   # adds Cancel
    
    n = xbmcgui.Dialog().select(addon.getLocalizedString(50163), array);
    
    if n < 0:
        return;
    elif n == 0:
        createItemAndSimpleContainer();
    elif n == 1:
        createVolumeWithHiddenVolume();
        
    
# def guiTest():
#     choosePartition();
#     print("number of partitions: " + str(len(tcitem.getPartitions())));
#     print(xbmc.translatePath("special://home/addons"));
#     print(xbmc.translatePath("special://xbmc/addons"));
#     print(xbmc.translatePath("special://xbmcbin/addons"));
#     dic = getInformationFromUser(itemName = True, newVolumeCreation = False, volumePath = False, mountPoint = True,
#                            password = True, keyFilesPath = True, hidden = False, iconPath = False, item = None,
#                            fileSystem = True, active = consts.trueString );
#    print(str(dic));

def startUpMounts():
    '''
    This method performs mounting of chosen items at start up.
    '''
    activeItems = tcitem.getTCitems(True); # mount only active items
    xbmc.log("Truecrypt nu of active items at start up mounts:" + str(len(activeItems)), level=xbmc.LOGDEBUG); 
    for item in activeItems:
        if addon.getSetting(consts.mountChecks) == consts.trueString: # checks if mount checks are turned on
            if item.mountAtStartup and checkRequirements(item): # if item is marked for start up mount and requirements are OK
                mountStatus = tcitem.isMounted(item.filePath, item.mountPoint);
                if mountStatus == consts.notMounted: # mounts only when its not mounted, in case XBMC is restarted it won't try to mount it again
                    xbmc.log("Truecrypt mounting drive at start up: " + item.name, level=xbmc.LOGDEBUG);
                    mountDrive(volume = item.filePath, mountPoint = item.mountPoint, item = item, mountAtStartup = True); 
                elif  mountStatus == consts.mountPointInUse:
                    xbmc.log("Truecrypt - not mounting " + item.name + " due to mount point is already in use.", level=xbmc.LOGDEBUG);
        else: # mount checks are off, it will always try to mount it. Even on XBMC restart :(
            if item.mountAtStartup and checkRequirements(item):
                xbmc.log("Truecrypt mounting drive at start up wothout checking it mount status: " + item.name, level=xbmc.LOGDEBUG);
                mountDrive(volume = item.filePath, mountPoint = item.mountPoint, item = item, mountAtStartup = True); 
    

# script logic
# basic information for log
xbmc.log("Truecrypt plugin v " + addon.getAddonInfo("version"), level=xbmc.LOGDEBUG);
xbmc.log("Truecrypt number of params: " + str(len(sys.argv)), level=xbmc.LOGDEBUG);
xbmc.log("Truecrypt parameters passed to script: "+ str(sys.argv), level=xbmc.LOGDEBUG);

if len(sys.argv) <= 1: # this part is executed at XBMC startup, no needed parameters for creating XBMC folder were suplied.
    xbmc.log("Truecrypt initiation during XBMC start up.", level=xbmc.LOGDEBUG);
    tcitem.addExecDirToPath();
    startUpMounts();
else:  # creation of menu strutured as xbmc folders
    params = sutils.get_params();
    index = None;
    
    xbmc.log("Truecrypt initial params:" + str(params), level=xbmc.LOGDEBUG);
    
    try:
        index = int(params[consts.index]);
    except:
        pass;    
        
    if index == None : # creates initial folder structured menu if  index value is None
        activeItems = tcitem.getTCitems(True);
        
        if len(activeItems) > 0:
            addFolderItem(consts.fontBold + consts.colorBlue + addon.getLocalizedString(50039) + 
                          consts.colorEnd + consts.fontBoldEnd, -99);  # Select item:
            addAllActiveItemsToXBMCView(activeItems);
        addFolderItem(consts.fontBold + consts.colorBlue + addon.getLocalizedString(50040) +
                      consts.colorEnd + consts.fontBoldEnd, -99);   # Tasks:
        addFolderItem(addon.getLocalizedString(50001), -5);   # Mount
        addFolderItem(addon.getLocalizedString(50002), -6);   # Unmount
        if not dontStoreAnyInfo:
            addFolderItem(addon.getLocalizedString(50042), -1); #"Assign existing truecrypt file"
        addFolderItem(addon.getLocalizedString(50041), -2);  # Create new Truecrypt volume 
        addFolderItem(addon.getLocalizedString(50087), -3); # "Create key file"
#         addFolderItem("Gui test", -98); 
        xbmcplugin.endOfDirectory(int(sys.argv[1]));
    # Execute chosen task from the XBMC folder menu based on index value
    elif index == -1:
        assignExistinVolume();
    elif index == -2 :
        createNewVolumeByType();
    elif index == -3:
        createKeyFile(); 
    elif index == -4:
        createVolumeWithHiddenVolume();
    elif index == -5:
        mountDrive();
    elif index == -6:
        unmountDrive();
#     elif index == -98:
#         guiTest()       
    elif index == -99: 
        pass;
    else :   #  index values form 0 - to 9 are interpreted as click on the saved item in XBMC view so item actions re displayed.
        itemActions(index);
tcitem.destroyItems(); # clean created items
