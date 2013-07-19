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


import os.path;
import sys;
import xbmcgui;  # @UnresolvedImport
import xbmc;  # @UnresolvedImport
import xbmcaddon;  # @UnresolvedImport
import xbmcplugin;  # @UnresolvedImport
addon= xbmcaddon.Addon(id='plugin.program.truecrypt');
sys.path.append( os.path.join (addon.getAddonInfo('path'), 'resources','lib') );
import sutils;  # @UnresolvedImport
import tcitem;  # @UnresolvedImport
import sutilsxbmc;  # @UnresolvedImport

#reload(sys);
#sys.setdefaultencoding("utf-8");

# Script constants
__scriptname__ = "Mount TrueCrypt"
__author__ = "Peter Smorada"
__version__ = "0.8"
__home_ = addon.getAddonInfo('path');
__icon__ = os.path.join(__home_, "icon.png");

if addon.getSetting("debug") == "true":
    debug = True;
else:
    debug = False;

def addDir(item):
    """Method adds folder directly to XBMC."""
    u=sys.argv[0]+"?index="+ str(item.index);
    ok=True;
    
    # check if mount checking is active
    if addon.getSetting("performMountChecks") == "true":
        mounted = item.isMounted();
    else :
        mounted = False;  #
        
    locked = item.isLocked();
    addToName = "";
    # blocks add status to the name
    if mounted :
        addToName += addon.getLocalizedString(50056);   # mounted
    if locked and not addToName == "":
        addToName +=", " + addon.getLocalizedString(50064);
    elif locked :
        addToName += addon.getLocalizedString(50064);
    if mounted or locked :
        addToName = " (" + addToName + ")"

    name = item.name + addToName;
    listItem=xbmcgui.ListItem(name, iconImage="DefaultFolder.png", thumbnailImage=item.icon);
    ok=xbmcplugin.addDirectoryItem(handle=int(sys.argv[1]),url=u, listitem=listItem,isFolder=False);
    return ok;

def ACTIVE_ITEMS():
    i = 0;
    items = tcitem.getTCitems(True);
    for item in items:
        addDir(item);

def addAdditionalTask(name, index):
    u=sys.argv[0]+"?index="+ str(index);
    ok=True;
    liz=xbmcgui.ListItem(name, iconImage="DefaultFolder.png", thumbnailImage=addon.getAddonInfo('path') + "/icon.png");
    ok=xbmcplugin.addDirectoryItem(handle=int(sys.argv[1]),url=u, listitem=liz,isFolder=False);
    return ok;


def performAction(action, item ):
    if action == addon.getLocalizedString(50001) :   # Mount
        if debug:
            print("Truecrypt attempt to mount drive.");
        mountDrive(item);
    elif action == addon.getLocalizedString(50002) : # Unmount
        if debug:
            print("Truecrypt attempt to unmount drive");
        unmountDrive(item);
    elif action == addon.getLocalizedString(50003)  :     # "Deactivate"
        if debug:
            print("Truecrypt deactivating item.");
        item.deactivate();
        xbmcgui.Dialog().ok(addon.getLocalizedString(50012), addon.getLocalizedString(50013) + " " + addon.getLocalizedString(50014));  # Info , Item is deactivated. Use Addon settings to re-activate it."
        sutilsxbmc.refreshCurrentListing();
    elif action == addon.getLocalizedString(50004) :  #  "Reset settings"
        if debug:
            print("Truecrypt reseting item.");
        reset(item)
    elif action == xbmc.getLocalizedString(117): # delete
        if debug:
            print("Truecrypt deleting item.");
        delete(item);
    elif action == addon.getLocalizedString(50005):  # "Recreate container"
        if debug:
            print("Truecrypt recreating container.");
        recreateContainer(item);
    elif action == addon.getLocalizedString(50006) :    # "Format"
        if debug:
            print("Truecrypt formating container.");
        formatExistingContainer(item);
    elif action == addon.getLocalizedString(50007) :   # "Store password"
        if debug:
            print("Truecrypt password being stored.");
        setPassword(item);
    elif action == addon.getLocalizedString(50008):   # "Remove stored password"
        if debug:
            print("Truecrypt password being removed.");
        removePassword(item);
    elif action == addon.getLocalizedString(50066):    # Change password
        if debug:
            print("Truecrypt password being changed.");
        changePass(item);
    elif action == xbmc.getLocalizedString(222):   # cancel
        if debug:
            print("Truecrypt canceled.");
        pass;


def itemActions(index):
    item = tcitem.createTCitem(index);
    prerequisitiesOK = checkRequirements(item);
    prerequisitiesOK = True; # TODO: prerequisities should not be ignoted 
    if prerequisitiesOK:
        actions = [];
        if item.isLocked():
            actions.append(addon.getLocalizedString(50065));   #
        else:
            # check if perform mount checks and based on it appends menu
            if addon.getSetting("performMountChecks") == "true":
                if item.isMounted() :
                    actions.append(addon.getLocalizedString(50002));  # Unmount
                else:
                    actions.append(addon.getLocalizedString(50001));   # Mount
            else: # if no checks are performed both possibilities are added
                actions.append(addon.getLocalizedString(50001));   # Mount
                actions.append(addon.getLocalizedString(50002));  # Unmount                    

            if item.isStoredPassword():
                actions.append(addon.getLocalizedString(50008));          # "Remove stored password"
            else :
                actions.append(addon.getLocalizedString(50007));     # "Store password"

            actions.extend([addon.getLocalizedString(50003), addon.getLocalizedString(50004)]);   # "Deactivate", "Reset settings", Change password
            
            if addon.getSetting("performMountChecks") == "true":
                actions.append(addon.getLocalizedString(50066));  # Change password

            if addon.getSetting("riskyActions") == "true":
                actions.append(xbmc.getLocalizedString(117)); # Delete 
                # allow these operation only if checks are on
                if addon.getSetting("performMountChecks") == "true":
                    actions.append(addon.getLocalizedString(50006));
                    actions.append( addon.getLocalizedString(50005)) ;  #"Format", "Recreate container"
  
            actions.append(xbmc.getLocalizedString(222));   # adds Cancel

        n = xbmcgui.Dialog().select(addon.getLocalizedString(50009),actions);
        action = actions[n];
        performAction(action, item)
    del item;
    

def setPassword(item):
    confirmed = xbmcgui.Dialog().yesno(addon.getLocalizedString(50015), addon.getLocalizedString(50016),   # Store password? , It is possible to store password for this file.
addon.getLocalizedString(50017), addon.getLocalizedString(50018)); # This way you won't need to specify it when mounting., It's stored encoded, but be carefull when using this feature.
    if confirmed:
        password = sutilsxbmc.getStringFromUser(heading = addon.getLocalizedString(50011), hidden = True); # Enter password
        item.setPassword(password);
        del password;

def removePassword(item):
    confirmed = xbmcgui.Dialog().yesno(addon.getLocalizedString(50008), xbmc.getLocalizedString(750));   #Remove stored password, Are you sure?
    if confirmed:
        item.setSettings(password="");


def recreateContainer(item):
    confirmed = xbmcgui.Dialog().yesno(addon.getLocalizedString(50019) , addon.getLocalizedString(50020), xbmc.getLocalizedString(561) +": " + item.filePath,  addon.getLocalizedString(50019));  #"Continue?" ,"Your current truecrypt file will be removed.", "File: "   Continue?
    if confirmed :
        fileSystem = None;
        password = sutilsxbmc.getConfirmedPassword();
        s = sutilsxbmc.getNumberFromUser(0, addon.getLocalizedString(50021));
        if s == "" :
            return;
        size = str(int(s) * 1024 * 1024 * 1024);
        fileSystem = filesysToUse();
        xbmc.executebuiltin("Notification(Truecrypt, " + addon.getLocalizedString(50022)+ " , 5, " + __icon__ + ")");  # Creation of cantainer started.
        item.createNewFile(size, password);
        if not fileSystem == None:
            success = format(item, fileSystem, password);
        xbmc.executebuiltin("Notification(Truecrypt, " + addon.getLocalizedString(50023)+ " , 5, " + __icon__ + ")");   # Attempting to mount created file.
        mountUnmount(item, password);
        del password;

def reset(item):
    confirmed = xbmcgui.Dialog().yesno(addon.getLocalizedString(50019) , addon.getLocalizedString(50023), addon.getLocalizedString(50023));  # "Continue?" ,"All settings for selected item will be removed. Continue?"
    if confirmed:
        item.resetSettings();
    sutilsxbmc.refreshCurrentListing();

def pickFileSystem():
    availableFS = ["FAT32", "ext4", "ext3", "ext2", "NTFS", xbmc.getLocalizedString(222)]; # Cancel
    selected = xbmcgui.Dialog().select(addon.getLocalizedString(50025), availableFS);    # Select file system:
    fileSystem = availableFS[selected];
    if fileSystem == xbmc.getLocalizedString(222):  # Cancel
        return None;
    return fileSystem;

def filesysToUse():
    format = xbmcgui.Dialog().yesno(addon.getLocalizedString(50027) , addon.getLocalizedString(50028), addon.getLocalizedString(50029)); # "Formatting" ,"Container will be formated with FAT32 by default.", "Would you like to choose other file system?"
    if format :
        fileSystem = pickFileSystem();
        return fileSystem;
    else :
        return None;

def format(item, fileSystem, password):
    if not item.isMounted() :
        item.mount(password);
        if not item.isMounted() :
            xbmcgui.Dialog().ok(xbmc.getLocalizedString(257), addon.getLocalizedString(50031), addon.getLocalizedString(50032))   # "Error", "Failed to mount file.", "Not proceeding with formatting."
            item.setSettings(active = True);
            return;


    success = item.format(fileSystem);
    return success;

def formatExistingContainer(item):
    confirmed = xbmcgui.Dialog().yesno(addon.getLocalizedString(50019) ,addon.getLocalizedString(50036), xbmc.getLocalizedString(561) +": " + item.filePath,  addon.getLocalizedString(50019));  # "Continue?" ,"All files in your container will be removed!", "File: " + item.filePath,  "Continue?"
    password = item.getPassword();
    if confirmed :
        if password == "" or password == None :
            password = sutilsxbmc.getStringFromUser(heading = addon.getLocalizedString(50011), hidden = True);  # "Enter password"
            
        fileSystem = pickFileSystem();
        if fileSystem == None :
            del password;
            return;
        success = format(item, fileSystem, password);
        item.mount(password);
        if success and item.isMounted() :
            item.unmount();
            # xbmc.executebuiltin("Notification(Truecrypt, " + addon.getLocalizedString(50037) + ", 5, " + __icon__ + ")");   # Container mounted successfully after formatting.
            xbmcgui.Dialog().ok(addon.getLocalizedString(512), addon.getLocalizedString(50062));
        elif success :
            xbmcgui.Dialog().ok(xbmc.getLocalizedString(257), addon.getLocalizedString(50038));   # "Error", "Failed to mount file after formatting."
        else :
            xbmcgui.Dialog().ok(xbmc.getLocalizedString(257), addon.getLocalizedString(50061));
        del password;
        return;

def changePass(item):
    oldPass = item.getPassword();
    if oldPass == "" or oldPass == None :
        oldPass = sutilsxbmc.getStringFromUser(heading = addon.getLocalizedString(50011), hidden = True);  # "Enter password"
    newPass = sutilsxbmc.getConfirmedPassword();
    success = item.changePassword(oldPass, newPass);

    if success :
        xbmcgui.Dialog().ok(addon.getLocalizedString(50012), addon.getLocalizedString(50067));  # Info , Password changed successfully
        item.setSettings(password = ""); # deletes old saved password

    else :
        xbmcgui.Dialog().ok(xbmc.getLocalizedString(257), addon.getLocalizedString(50068), item.getErrorMessage());   # Error , Failed to change password
    del oldPass;
    del newPass;
    return;

def delete(item):
    confirmed = xbmcgui.Dialog().yesno(addon.getLocalizedString(50069), xbmc.getLocalizedString(750), addon.getLocalizedString(50060)+": " + item.name, xbmc.getLocalizedString(561) +": " + item.filePath);    #"Delete file?", "Are you sure?", "Item: " + item.name,"File: " + item.filePath
    if confirmed :
        # @type item resources.lib.tcitem
        success = item.delete();
        if not success:
            xbmcgui.Dialog().ok(addon.getLocalizedString(50058), addon.getLocalizedString(50059), item.getErrorMessage());    # "Failed", "Failed to delete specified file."
        else:
            xbmcgui.Dialog().ok(addon.getLocalizedString(50038), addon.getLocalizedString(50057));   # "Info", "File deleted sucessfully.")
            item.resetSettings();
    sutilsxbmc.refreshCurrentListing();
    
def checkRequirements(item):
    if not os.path.exists(addon.getSetting( "truecrypt" )):
        Dialog = xbmcgui.Dialog().ok(addon.getLocalizedString(50070), addon.getLocalizedString(50071));  # Wrong/Missing Setting   The Setting for the Truecrypt script is wrong or missing.
        return False;
    if not os.path.exists(item.filePath):
        Dialog = xbmcgui.Dialog().ok(addon.getLocalizedString(50070), addon.getLocalizedString(50072));  # Wrong/Missing Setting   The Setting for the TC File to mount is wrong or missing.
        return False;
    if  item.mountPoint == "" or not os.path.exists(item.mountPoint):
        if addon.getSetting( "createFolders" ) == "true":
            os.makedirs(item.mountPoint);
        else: 
            Dialog = xbmcgui.Dialog().ok(addon.getLocalizedString(50070), addon.getLocalizedString(50073));  # No mount point/drive was specified or doesn't exists
            return False;
    return True;

def mountDrive(item):
    # create and exec command
    password = item.getPassword();
    if password == None or password == "":
        password = sutilsxbmc.getStringFromUser(heading = addon.getLocalizedString(50011), hidden = True);    # Enter password
        if password == None or password == "":
            aborted();
            return;
    item.mount(password);
    if addon.getSetting("performMountChecks") == "true":
        mounted = item.isMounted();
        if mounted :
            sutilsxbmc.refreshCurrentListing();
    #        xbmc.executebuiltin(u"Notification(Truecrypt, " + addon.getLocalizedString(50048).decode('utf-8') + ", 5, " + __icon__ + ")");   # The truecrypt drive is now mounted.
        else:
            errStr=item.getErrorMessage();
            xbmcgui.Dialog().ok(addon.getLocalizedString(50030),addon.getLocalizedString(50049) , errStr);   # Truecrypt Error", "The truecrypt drive failed to mount."
    del password;


def unmountDrive(item):
    item.unmount();
    if addon.getSetting("performMountChecks") == "true":
        mounted = item.isMounted();
        if not mounted :
    #        xbmc.executebuiltin("Notification(Truecrypt, " + addon.getLocalizedString(50050) + ", 5, " + __icon__ + ")");
            sutilsxbmc.refreshCurrentListing();
            item.remove_tc_aux_mnt();
        else:
            if debug:
                print("TrueCrypt Drive Failed to unmount." + " " + item.getErrorMessage());
            xbmcgui.Dialog().ok(addon.getLocalizedString(50030), addon.getLocalizedString(50049), item.getErrorMessage());   # "Truecrypt Error", "The truecrypt drive failed to unmount."

def getSettingsForContainer(newContainer = False, item = None, active = "true"):
    if item == None:
        name = sutilsxbmc.getStringFromUser(addon.getLocalizedString(50043), False, "");  #"Please enter display name"
    else:
        name = sutilsxbmc.getStringFromUser(addon.getLocalizedString(50043), False, item.name);  # "Please enter display name"
    if name =="":
        return;
    if newContainer:
        folder = sutilsxbmc.getFilePathFromUser(3, addon.getLocalizedString(50044));   # Select folder for new file"
        file = sutilsxbmc.getStringFromUser(xbmc.getLocalizedString(16013), False, name); #16013 - Enter new filename
        if folder == "" or file =="":
            return None;
        filePath=os.path.join(folder, file);
    else:
        filePath = sutilsxbmc.getFilePathFromUser(1, addon.getLocalizedString(50045));    # Select file
    if filePath == "":
        return None;
    drive = sutilsxbmc.getFilePathFromUser(3, addon.getLocalizedString(50046));     # Select mount point/drive
    if drive == "":
        return None;
    icon = sutilsxbmc.getFilePathFromUser(2, addon.getLocalizedString(50047));      # Select icon (optional)
    dic ={};
    dic["name"]=name;
    dic["filePath"]=filePath;
    dic["drive"]=drive;
    dic["icon"]=icon;
    dic["active"]=active;
    return dic;

def aborted():
    xbmcgui.Dialog().ok(xbmc.getLocalizedString(10511), xbmc.getLocalizedString(16200)); # System information   Operation was aborted

def pickItem(active = None):
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
    selected = xbmcgui.Dialog().select(addon.getLocalizedString(50051), displayNames);   # "Select item:"
    selectedItem = displayNamesToItems.get(displayNames[selected]);
    return selectedItem;

def assignExistinContainer():
    item = pickItem(False);
    settingDic = getSettingsForContainer(item = item);
    if settingDic == None :
        return;
    item.setDicSettings(settingDic);
#    selectedItem.setContainerSettings(name =name, filePath = filePath, drive = mountPoint, icon = icon, active = True);
    sutilsxbmc.refreshCurrentListing();


def createContainerAndItem():
    item = pickItem(False);
    settingDic = getSettingsForContainer(True, item);
    if settingDic== None:
        aborted()
        return;
    s = sutilsxbmc.getNumberFromUser(0, addon.getLocalizedString(50021));   # Enter size in GB.
    if s == "" :
        aborted()
        return;
    size = str(int(s) * 1024 * 1024 * 1024)
    password = sutilsxbmc.getConfirmedPassword();
    fileSystem = filesysToUse();
    item.setDicSettings(settingDic, True);
    xbmc.executebuiltin("Notification(Truecrypt, " + addon.getLocalizedString(50021) + ", 5, " + __icon__ + ")");  # Creation of cantainer started.
    item.createNewFile(size, password);
    if not fileSystem == None :
        format(item, fileSystem, password);
    xbmc.executebuiltin("Notification(Truecrypt, " + addon.getLocalizedString(50054) + ", 5, " + __icon__ + ")"); # Attempting to mount created file.
    success = mountUnmount(item, password);
    if success :
        xbmcgui.Dialog().ok(xbmc.getLocalizedString(10511), addon.getLocalizedString(50063));
    sutilsxbmc.refreshCurrentListing();
    del password;


def mountUnmount(item, password):
    item.mount(password);
    
    if addon.getSetting("performMountChecks") == "true":
        if item.isMounted() :
            item.unmount();
            if not item.isMounted() :
                return True;
            else:
                return False;
        else:
            return False;
    else:
        item.unmount();
        return True;  # if checks are disabled, assert that it was sucessful...  


params = sutils.get_params();
index = None;

if debug:
    print("Truecrypt initial params:" + str(params));

try:
    index = int(params["index"]);
except:
    pass;

if debug:
    print("Truecrypt parameters passed to script: "+ str(sys.argv));
    
if index == None :
    addAdditionalTask("[B]" +addon.getLocalizedString(50039) + "[/B]", -99);  # Select item:
    ACTIVE_ITEMS();
    addAdditionalTask("[B]" +addon.getLocalizedString(50040) + "[/B]", -99);   # Additional tasks:
    addAdditionalTask(addon.getLocalizedString(50042), -1); #"Assign existing truecrypt file"
    addAdditionalTask(addon.getLocalizedString(50041), -2);  # Create new Truecrypt container
    xbmcplugin.endOfDirectory(int(sys.argv[1]));
elif index == -1:
    assignExistinContainer();
elif index == -2 :
    createContainerAndItem();
elif index == -99:
    pass;
else :
    itemActions(index);
tcitem.destroyItems();
