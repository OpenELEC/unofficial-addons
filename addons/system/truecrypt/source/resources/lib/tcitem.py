# -*- coding: utf-8 -*-
'''
This module provides methods for executing TrueCryot tasks through the shell script. It also provides
a data model class for storing information based on stored addon settings. 
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

import os;
import subprocess;
import xbmcaddon;  # @UnresolvedImport
import sutils;
import sutilsxbmc;
import xbmc;  # @UnresolvedImport
import consts;



__supportedTCFilesNum__=10; # number of supported items connected with addon settings
__settings__ = xbmcaddon.Addon(id = consts.addonId);
__tcitems = []; #  all created items are stored in this list

# loading settings from the addon settings
debugLogPassword = True if __settings__.getSetting(consts.printPassInDebug) == consts.trueString else False;
debugLogKeyFiles = True if __settings__.getSetting(consts.printKeyFilesInDebug) == consts.trueString else False;
dontStoreAnyInfo = True if  __settings__.getSetting(consts.dontStoreAnyInformation) == consts.trueString else False;


# set up script to use
if __settings__.getSetting(consts.alternativeShellScriptUsage) == consts.trueString:
    shellScript = __settings__.getSetting(consts.alternativeShellScriptPath);
    xbmc.log(msg=consts.logAlternativeScript, level=xbmc.LOGWARNING);        
else:
    shellScript = __settings__.getSetting(consts.shellScript);

class TCitem:
    '''
    This class represents a data model for the stored items in the addon settings.  
    '''

    def __str__(self):
        return "TC item [name: " + self.name + ", volume: " + self.filePath + ", mount point: " + self.mountPoint + " , mount at start up: " + str(self.mountAtStartup) +"]";

    def __init__(self, name, filePath, mountPoint, active, index, icon="", password="", useKeyFiles = False,
                 nuOfKeyFiles = -1, keyFilesPath = "", mountAtStartup = False):
        self.name = name;
        self.filePath = filePath;
        self.mountPoint = mountPoint;
        self.active = active;
        self.__password = password;
        self.icon = icon;
        self.index = index;
        self.useKeyFiles = useKeyFiles;
        self.numberOfKeyFiles = nuOfKeyFiles;
        self.__keyFilesPath = keyFilesPath;
        self.mountAtStartup = mountAtStartup;
        self.errorMessage = "";
        xbmc.log("Truecrypt creation of tcitem: " + self.__str__(), level=xbmc.LOGDEBUG)
    
    def isStoredPassword(self):
        '''
        Returns true if the password is stored in addon settings.
        '''
        if self.__password == "" or self.__password == None :
            return False;
        else:
            return True;
        
    def isStoredKeyFilesPath(self):
        '''
        Returns true if key files path is stored in the addon settings.
        '''
        if self.__keyFilesPath == "" or self.__keyFilesPath == None :
            return False;
        else:
            return True;


    def isMounted(self):
        '''
        Method checks if the mount status of the item. It returns integer which represents 
        current mount status.
        '''
        return isMounted(self.filePath, self.mountPoint);

        
    def delete(self):
        '''
        This method deletes the truecrypt file. Returns true if successful.
        '''
        try :
            os.remove(self.filePath);
        except OSError, arg:
            self.errorMessage = str(arg);
            return False;
        if os.path.exists(self.filePath):
            return False;
        else:
            return True;
        

    def readSettings(self):
        '''
        It reads settings for the given item from the addon settings and stores them in instance variables.
        '''
        strI= str(self.index) ;
        self.name = __settings__.getSetting(consts.itemName + strI);
        self.filePath = __settings__.getSetting(consts.volume + strI);
        self.mountPoint = __settings__.getSetting(consts.drive + strI);
        self.active = __settings__.getSetting(consts.active + strI);
        self.__password = __settings__.getSetting(consts.password + strI);
        self.icon = __settings__.getSetting(consts.icon + strI);
        self.__keyFilesPath = __settings__.getSetting(consts.keyFiles + strI);
        self.numberOfKeyFiles = __settings__.getSetting(consts.keyFileNumber + strI);
        self.useKeyFiles = __settings__.getSetting(consts.useKeyFiles + strI);
        self.mountAtStartup = True if __settings__.getSetting(consts.mountAtStartup + strI) == consts.trueString else False;


    def deactivate(self):
        '''
        It marks the item as not active in the addon settings. Afterwards it will not be shown in the XBMC folder view. 
        '''
        __settings__.setSetting(consts.active + str(self.index), consts.falseString);

    def resetSettings(self):
        '''
        It will remove all addon stored settings for this item. 
        '''
        strI = str(self.index);
        __settings__.setSetting(consts.itemName + strI, "Item " + strI); # TODO: possibility to localize word item
        __settings__.setSetting(consts.volume +  strI, "");
        __settings__.setSetting(consts.drive + strI, "");
        __settings__.setSetting(consts.active + strI, consts.falseString);
        __settings__.setSetting(consts.password + strI, "")
        __settings__.setSetting(consts.icon + strI, "");
        __settings__.setSetting(consts.keyFiles + strI, "");
        __settings__.setSetting(consts.keyFileNumber + strI, "-1");
        __settings__.setSetting(consts.useKeyFiles + strI, consts.falseString);
        __settings__.setSetting(consts.mountAtStartup + strI, consts.falseString);


    def setSettings(self, name = None, filePath = None, drive = None, active = None,
                    password = None, icon = None, useKeyFiles = None, numberOfKeyFiles = None,
                    keyFilesPath = None, mountAtStartUp = None):
        '''
        The methos is responsible for saving settings in the variables and in the addon settings (only in case it is allowed in addon settings). 
        :param name: display name of the item
        :param filePath: path to the truecrypt volume
        :param drive: mount point 
        :param active: if the item should be shown in the XBMC folder view
        :param password: supplied only if password should be saved (it gets encoded)
        :param icon: custon icon
        :param useKeyFiles: tells whether key files are used with this item
        :param numberOfKeyFiles: stores nu. of key files, -1 means that guide should always ask for it
        :param keyFilesPath: supplied only if key file path should be saved (it gets encoded)
        :param mountAtStartUp:if the mount should be performed on start up
        '''
        strI = str(self.index);
        if not name == None :
            if not dontStoreAnyInfo:
                __settings__.setSetting(consts.itemName + strI, name);
            self.name = name;

        if not filePath == None:
            if not dontStoreAnyInfo:
                __settings__.setSetting(consts.volume +  strI, filePath);
            self.filePath = filePath;

        if not drive == None :
            if not dontStoreAnyInfo:
                __settings__.setSetting(consts.drive + strI, drive);
            self.mountPoint = drive;

        if active == None:
            pass;
        elif active == consts.trueString or active == True :
            if not dontStoreAnyInfo:
                __settings__.setSetting(consts.active + strI, consts.trueString);
            self.active=True;
        else :
            if not dontStoreAnyInfo:
                __settings__.setSetting(consts.active + strI, consts.falseString);
            self.active=False;

        if not icon == None :
            if not dontStoreAnyInfo:
                __settings__.setSetting(consts.icon + strI, icon);
            self.icon = icon;

        if password == None:
            pass;
        elif password == "":
            __settings__.setSetting(consts.password + strI, password);
        else :
            if not dontStoreAnyInfo:
                self.setPassword(password);
            
        if useKeyFiles == None:
            pass;
        elif useKeyFiles == consts.trueString or useKeyFiles == True:
            if not dontStoreAnyInfo:
                __settings__.setSetting(consts.useKeyFiles + strI, consts.trueString);
        else:
            if not dontStoreAnyInfo:
                __settings__.setSetting(consts.useKeyFiles + strI, consts.falseString);
            
        if not numberOfKeyFiles == None:
            if not dontStoreAnyInfo:
                __settings__.setSetting(consts.keyFileNumber + strI, str(numberOfKeyFiles));
            
        if keyFilesPath == None:
            pass;
        elif keyFilesPath == "":
            __settings__.setSetting(consts.keyFiles + strI, keyFilesPath);
        else :
            if not dontStoreAnyInfo:
                self.setKeyFilesPath(keyFilesPath);
            
        if mountAtStartUp == None:
            pass;
        elif mountAtStartUp == consts.trueString or mountAtStartUp == True :
            if not dontStoreAnyInfo:
                __settings__.setSetting(consts.mountAtStartup + strI, consts.trueString);
            self.mountAtStartup = True;
        else :
            if not dontStoreAnyInfo:
                __settings__.setSetting(consts.mountAtStartup + strI, consts.falseString);
            self.mountAtStartup=False;

    def setPassword(self, password):
        '''
        It saves the password in the addon settings in encoded form.
        :param password: password to be saved
        '''
        encodedPassword = sutils.encodeStr(password);
        self.__password = encodedPassword;
        __settings__.setSetting(consts.password + str(self.index), encodedPassword);
        
    def setKeyFilesPath(self, path):
        '''
        It saves the key files path in the addon settings in encoded form.
        :param path: path to be saved
        '''
        encodedPath = sutils.encodeStr(path);
        self.__keyFilesPath = encodedPath;
        __settings__.setSetting(consts.keyFiles + str(self.index), encodedPath);

    def lock(self, reason=""):
        '''
        This method provides a lock mechanism when long lasting tasks are started to avoid user to make any unwanted 
        changes or damaging the file. Lock information is stored in addon settings.
        :param reason: optional reason why the item is locked
        '''
        __settings__.setSetting(consts.lock + str(self.index), consts.trueString);
        if reason != "":
            __settings__.setSetting(consts.lockReason + str(self.index), reason);

    def unlock(self):
        '''
        It unlocks the item after certain tasks.
        '''
        __settings__.setSetting(consts.lock + str(self.index), consts.falseString);
        __settings__.setSetting(consts.lockReason + str(self.index), "");

    def isLocked(self):
        '''
        It returns if this item is locked to avoid execution of other tasks.
        '''
        if __settings__.getSetting(consts.lock + str(self.index)) == consts.trueString :
            return True;
        else :
            return False;
        
    def getLockReason(self):
        '''
        It returns the reason for locking the item.
        '''
        return __settings__.getSetting(consts.lockReason + str(self.index))
        
    def getPassword(self):
        '''
        It returns decoded password for this item or None if it is not stored.
        '''
        if self.__password == "" or self.__password == None :
            self.__password =__settings__.getSetting(consts.password + str(self.index));
            if self.__password == "" :
                return None;
        return sutils.decodeStr(self.__password);
    
    def getKeyFilesPath(self):
        '''
        It returns decoded key files path for this item or None if it is not stored.
        '''
        if self.__keyFilesPath == "" or self.__keyFilesPath == None :
            self.__keyFilesPath =__settings__.getSetting(consts.keyFiles + str(self.index));
            if self.__keyFilesPath == "" :
                return None;
        return sutils.decodeStr(self.__keyFilesPath);

#     def setDicSettings(self, dictionary, removePrevious = False):
#         if removePrevious:
#             self.resetSettings();
# 
#         strI = str(self.index);
#         for key in dictionary:
#             if key == "password":
#                 self.setPassword(dictionary.get(key));
#             elif key == "keyFilesPath":
#                 self.setKeyFilesPath(dictionary.get(key));
#             else:
#                 __settings__.setSetting(key + strI,  dictionary.get(key));
#         self.readSettings();

    def getErrorMessage(self):
        '''
        It returns the error message from last shell script call if there is any.
        '''
        return getErrorMessage();
    
    def destroy(self):
        '''
        It removes password and keyfiles path out of the scope.
        '''
        del self.__password;
        del self.__keyFilesPath;
 
 
def getErrorMessage():
    '''
    It returns the error message from last shell script call if there is any.
    '''
    return errout;
 
def setErrorMessage(err):
    '''
    It saves the error messages from last shell script call in the instance variable.
    :param err: message to be saved
    '''
    global errout;
    errout = err;
 
def isMounted(filePath, mountPoint):
    '''
    The method checks the mount status of the truecrypt volume. It returns integer representing the one of 3 states:
    mounted, not mounted or mount point is used by other volume
    :param filePath: volume path
    :param mountPoint: mount point
    '''
    cmd = "\"" + shellScript + "\" ";
    cmd += consts.commandIsMounted + " ";
    cmd += "\"" + filePath + "\" ";
    cmd += "\"" + mountPoint + "\"";
    

    xbmc.log(msg=consts.logExecutingScript + cmd, level=xbmc.LOGDEBUG);

    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();
    
    xbmc.log(consts.logStandardOut + str(output), level=xbmc.LOGDEBUG);
    xbmc.log(consts.logErrorOut + str(errors), xbmc.LOGERROR if errors else xbmc.LOGDEBUG);
    
    returnCode = int(output[len(output)-2:]);
#        returnCode = 1;    
    return returnCode;
           
def mount(filePath, mountPoint, password="", keyFiles = "", item = None):
    '''
    Method executes mounting of the volume it through the shell script.
    :param filePath: volume path 
    :param mountPoint: mount point
    :param password: password
    :param keyFiles: path to the key files
    :param item: item is no longer needed
    '''
    cmd = "\"" + shellScript + "\" "
    cmd += consts.commandMount + " " ;
    cmd += "\"" + filePath + "\" ";
    cmd += "\"" + mountPoint + "\" ";
    
    escapedPassword = sutils.escapeCharsForShell(password);
    
    # this is command for the debug log only 
    tempcmd = consts.logExecutingScript + cmd + ("\"" + escapedPassword  + "\"" if debugLogPassword else "\"*****\"") + (" \"" + keyFiles  + "\"" if debugLogKeyFiles else " \"*****\"");
    xbmc.log(consts.logExecutingScript + tempcmd, level=xbmc.LOGDEBUG);
    
    cmd += "\"" + escapedPassword + "\" ";
    cmd += "\"" + keyFiles + "\"";
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();
    
    xbmc.log(consts.logStandardOut + str(output), level=xbmc.LOGDEBUG);
    xbmc.log(consts.logErrorOut + str(errors), xbmc.LOGERROR if errors else xbmc.LOGDEBUG);
    

    # auxmnt = str(output);
    # __settings__.setSetting("tc_aux_mnt" + str(self.index), auxmnt);
    if errors != None:
        setErrorMessage(str(errors))

        
def mountAsHiddenProtected(filePath, mountPoint, passwordOuter="", keyFilesOuter = "", passwordHidden = "", 
                           keyFilesHidden ="", item = None):
    '''
    Method executes mounting of the volume with hidden volume protection it through the shell script.
    :param filePath: path to the volume
    :param mountPoint: mount point
    :param passwordOuter: password for the outer volume
    :param keyFilesOuter: key files path for the outer volume
    :param passwordHidden: password for the hidden volume
    :param keyFilesHidden: key files path for the hidden volume
    :param item: no longer needed
    '''
    cmd = "\"" + shellScript + "\" "
    cmd += consts.commandMountHidden + " " ;
    cmd += "\"" + filePath + "\" ";
    cmd += "\"" + mountPoint + "\" ";
    
    escapedPasswordOuter = sutils.escapeCharsForShell(passwordOuter);
    escapedPasswordHidden = sutils.escapeCharsForShell(passwordHidden);
    
    # this is command for the debug log only 
    tempcmd = cmd + ("\"" + escapedPasswordOuter  + "\"" if debugLogPassword else "\"*****\"") + (" \"" + keyFilesOuter  + "\"" if debugLogKeyFiles else " \"*****\"") + (" \"" + escapedPasswordHidden  + "\"" if debugLogPassword else "\"*****\"") + (" \"" + keyFilesHidden  + "\"" if debugLogKeyFiles else " \"*****\" ") ;
    xbmc.log(consts.logExecutingScript + tempcmd, level=xbmc.LOGDEBUG);
    
    cmd += "\"" + escapedPasswordOuter + "\" ";
    cmd += "\"" + keyFilesOuter + "\" ";
    cmd += "\"" + escapedPasswordHidden + "\" ";
    cmd += "\"" + keyFilesHidden + "\"";
    
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();
    
    xbmc.log(consts.logStandardOut + str(output), level=xbmc.LOGDEBUG);
    xbmc.log(consts.logErrorOut + str(errors), xbmc.LOGERROR if errors else xbmc.LOGDEBUG);
    
    if errors != None:
        setErrorMessage(str(errors))

def unmount(filePath = "", mountPoint = "", item = None):
    '''
    Method executes unmounting of the volume though the shell script.
    :param filePath: path to the volume
    :param mountPoint: mount point
    :param item: item is no longer needed
    '''
    cmd = "\"" + shellScript + "\"";
    cmd += " " + consts.commandUmount + " ";
    cmd += "\"" + filePath + "\" ";
    cmd += "\"" + mountPoint + "\" ";
    
    xbmc.log(consts.logExecutingScript + cmd, level=xbmc.LOGDEBUG);
        
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();
    
    xbmc.log(consts.logStandardOut + str(output), level=xbmc.LOGDEBUG);
        
    if errors != None:
        xbmc.log(consts.logErrorOut + str(errors), level=xbmc.LOGERROR);
        setErrorMessage(str(errors))

            
def addKeyFiles(filePath, password, keyFiles, item = None):
    '''
    The method executes adding of key files to the volume through shell script.
    :param filePath: path to the volume
    :param password: password
    :param keyFiles: key file path
    :param item: item on which task is executed (only for lock reasons)
    '''
    if item != None:
        item.lock(__settings__.getLocalizedString(50122));
        sutilsxbmc.refreshCurrentListing();
    cmd = "\"" + shellScript + "\" "
    cmd +="\"" + consts.commandAddKeyFiles + "\" " ;
    cmd += "\"" + filePath + "\" ";
    
    escapedPassword = sutils.escapeCharsForShell(password);
    
    tempcmd = consts.logExecutingScript + cmd + ("\"" + escapedPassword  + "\"" if debugLogPassword else "\"*****\"") + (" \"" + keyFiles  + "\"" if debugLogKeyFiles else " \"*****\"");
    xbmc.log(consts.logExecutingScript + tempcmd, level=xbmc.LOGDEBUG);
    
    cmd += "\"" + escapedPassword + "\" ";
    cmd += "\"" + keyFiles + "\"";
    
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();
    
    xbmc.log(consts.logStandardOut + str(output), level=xbmc.LOGDEBUG);
    xbmc.log(consts.logErrorOut + str(errors), xbmc.LOGERROR if errors else xbmc.LOGDEBUG);
        
    if item != None:
        item.unlock();
        
    if errors:
        setErrorMessage(str(errors))
    
    returnCode = int(output[len(output)-2:]);
                
    if returnCode == 0:
        return True;
    else :
            return False;
        
def removeKeyFiles(filePath, password, keyFiles, item = None):
    '''
    The method executes removal of key files from the volume through shell script.
    :param filePath: path to the volume
    :param password: password
    :param keyFiles: key file path
    :param item: item on which task is executed (only for lock reasons)
    '''
    if item != None:
        item.lock(__settings__.getLocalizedString(50122));
        sutilsxbmc.refreshCurrentListing();
    cmd = "\"" + shellScript + "\" "
    cmd += "\"" + consts.commandRemoveKeyFiles +  "\" " ;
    cmd += "\"" + filePath + "\" ";
    
    escapedPassword = sutils.escapeCharsForShell(password);
    
    # this is command for the debug log only 
    tempcmd = consts.logExecutingScript + cmd + ("\"" + escapedPassword  + "\"" if debugLogPassword else "\"*****\"") + (" \"" + keyFiles  + "\"" if debugLogKeyFiles else " \"*****\"");
    xbmc.log(consts.logExecutingScript + tempcmd, level=xbmc.LOGDEBUG);
    
    cmd += "\"" + escapedPassword + "\" ";
    cmd += "\"" + keyFiles + "\"";
    
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();
    
    xbmc.log(consts.logStandardOut + str(output), level=xbmc.LOGDEBUG);
    xbmc.log(consts.logErrorOut + str(errors), xbmc.LOGERROR if errors else xbmc.LOGDEBUG);
            
    if item != None:
        item.unlock();
        
    if errors:
        setErrorMessage(str(errors))
        
    returnCode = int(output[len(output)-2:]);
                
    if returnCode == 0:
        return True;
    else :
        return False;
        
def changeKeyFiles(filePath, password, oldKeyFiles, newKeyFiles, item = None):
    '''
    The method executes changing of key files in the volume through shell script.
    :param filePath: path to the volume
    :param password: password
    :param keyFiles: key file path
    :param item: item on which task is executed (only for lock reasons)
    '''
    if item != None:
        item.lock(__settings__.getLocalizedString(50122));
        sutilsxbmc.refreshCurrentListing();
        
    cmd = "\"" + shellScript + "\" "
    cmd +="\"" + consts.commandChangeKeyFiles +  "\" " ;
    cmd += "\"" + filePath + "\"";
    
    escapedPassword = sutils.escapeCharsForShell(password);
    
    # this is command for the debug log only 
    tempcmd = consts.logExecutingScript + cmd + (" \"" + escapedPassword  + "\"" if debugLogPassword else "\"*****\"") + (" \"" + oldKeyFiles  + "\"" if debugLogKeyFiles else " \"*****\"") + (" \"" + newKeyFiles  + "\"" if debugLogKeyFiles else " \"*****\"");
    xbmc.log(consts.logExecutingScript + tempcmd, level=xbmc.LOGDEBUG);
    
    cmd += " \"" + escapedPassword + "\"";
    cmd += " \"" + oldKeyFiles + "\"";
    cmd += " \"" + newKeyFiles + "\"";
    
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();
    
    xbmc.log(consts.logStandardOut + str(output), level=xbmc.LOGDEBUG);
    xbmc.log(consts.logErrorOut + str(errors), xbmc.LOGERROR if errors else xbmc.LOGDEBUG);
    
    if item != None:    
        item.unlock();
        
    if errors:
        setErrorMessage(str(errors))
    
    returnCode = int(output[len(output)-2:]);
                
    if returnCode == 0:
        return True;
    else :
        return False;

def changePassword(filePath, oldPass="", newPass="", keyFiles="", item = None):
    '''
    The method executes changing of password in the volume through shell script.
    :param filePath: path to the volume
    :param oldPass: password to be changed
    :param newPass: new password
    :param keyFiles: key file path
    :param item: item on which task is executed (only for lock reasons)
    '''
    if item != None:
        item.lock(__settings__.getLocalizedString(50122));
        sutilsxbmc.refreshCurrentListing();
        
    cmd = "\"" + shellScript + "\" "
    cmd +="\"" + consts.commandChagePassword + "\" " ;
    cmd += "\"" + filePath + "\" ";
    
    escapedOldPass = sutils.escapeCharsForShell(oldPass);
    escapedNewPass = sutils.escapeCharsForShell(newPass);
    
    # this is command for the debug log only 
    tempcmd = consts.logExecutingScript + cmd + ("\"" + escapedOldPass  + "\" " + "\"" + escapedNewPass + "\"" if debugLogPassword else "\"*****\" \"*****\"") + (" \"" + keyFiles  + "\"" if debugLogKeyFiles else " \"*****\"");
    xbmc.log(consts.logExecutingScript + tempcmd, level=xbmc.LOGDEBUG);
        
    cmd += "\"" + escapedOldPass + "\" ";
    cmd += "\"" + escapedNewPass + "\"";
    cmd += " \"" + keyFiles + "\"";
    
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();
    
    xbmc.log(consts.logStandardOut + str(output), level=xbmc.LOGDEBUG);
    xbmc.log(consts.logErrorOut + str(errors), xbmc.LOGERROR if errors else xbmc.LOGDEBUG);
        
    if item != None:   
        item.unlock();
    if errors:
        setErrorMessage(str(errors))

    returnCode = int(output[len(output)-2:]);
    #        returnCode = 1;
    
    if returnCode == 0:
        return True;
    else :
        return False;


def format(filePath, mountPoint, fs, item = None):
    '''
    Method executes formating of the volume through the shell script. Volume has to be mounted first.
    :param filePath: path to the volume
    :param mountPoint: mount point
    :param fs: file system
    :param item: item which it concerns (only for lock reasons)
    '''
    if item != None:
        item.lock(__settings__.getLocalizedString(50006));
        sutilsxbmc.refreshCurrentListing();
        
    cmd = "\"" + shellScript + "\"";
    cmd += " " + consts.commandFormat + " ";
    cmd += "\"" + filePath + "\" ";
    cmd += "\"" + mountPoint + "\" ";
    cmd += "\"\" ";    #\"" + __settings__.getSetting("tc_aux_mnt" + str(self.index)) + "\" ";
    cmd += fs;

    xbmc.log(consts.logExecutingScript + cmd, level=xbmc.LOGDEBUG);

    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();
    
    xbmc.log(consts.logStandardOut + str(output), level=xbmc.LOGDEBUG);
    xbmc.log(consts.logErrorOut + str(errors), xbmc.LOGERROR if errors else xbmc.LOGDEBUG);
    
    returnCode = int(output[len(output)-2:]);
#        returnCode = 0;  
      
    if item != None:    
        item.unlock();
    if errors != None:
        setErrorMessage(str(errors))
        
    if returnCode == 0:
        return True;
    else :
        return False;

def createNewFile(filePath, mountPoint, size, password, keyFiles="", randomNumberGenerator="/dev/random", item = None):
    '''
    This method executes creation of new simple volume through shell script.
    :param filePath: path to the volume
    :param mountPoint: mount point
    :param size: size of the file in MB
    :param password: password
    :param keyFiles: key file path
    :param randomNumberGenerator: ramdomness generator, default is /dev/ramdom can also be a user chosen file
    :param item: item it concerns (only for lock purposes) 
    '''
    if item != None:
        item.lock(__settings__.getLocalizedString(50123));
        
    cmd = "\"" + shellScript + "\" " + consts.commandCreateContainer + " \"" + filePath + "\" \"" + mountPoint + "\" \""; 
    
    escapedPassword = sutils.escapeCharsForShell(password);
    
    # this is command for the debug log only
    tempcmd =  cmd + (escapedPassword + "\" "  if debugLogPassword else "******\" ");
    tempcmd = tempcmd + str(size) 
    tempcmd = tempcmd + (" \"" + keyFiles  + "\"" if debugLogKeyFiles else " \"*****\"");
    tempcmd = tempcmd +  " " +  randomNumberGenerator;
    xbmc.log(consts.logExecutingScript + tempcmd, level=xbmc.LOGDEBUG);

    cmd = cmd + escapedPassword + "\" " + str(size) + " \"" + keyFiles + "\" " + randomNumberGenerator;
    
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();
    
    xbmc.log(consts.logStandardOut + str(output), level=xbmc.LOGDEBUG);
    xbmc.log(consts.logErrorOut + str(errors), xbmc.LOGERROR if errors else xbmc.LOGDEBUG);
            
    if item != None:    
        item.unlock();
        

def createTCitem(index):
    '''
    The method creates tcitem object based on the specified index
    :param index: index of the item to be created
    '''
    strI = str(index);
    name = __settings__.getSetting(consts.itemName + strI);
    filePath = __settings__.getSetting(consts.volume +  strI);
    mountPoint = __settings__.getSetting(consts.drive + strI);
    active = True if __settings__.getSetting(consts.active + strI) == consts.trueString else False;
    password = __settings__.getSetting(consts.password + strI)
    icon = __settings__.getSetting(consts.icon + strI);
    useKeyFiles = True if __settings__.getSetting(consts.useKeyFiles + strI) == consts.trueString else False;
    nuOfKeyFiles = int(__settings__.getSetting(consts.keyFileNumber + strI));
    keyFilesPath = __settings__.getSetting(consts.keyFiles + strI);
    mountAtStartup = True if __settings__.getSetting(consts.mountAtStartup + strI) == consts.trueString else False;
    item = TCitem(name, filePath, mountPoint, active,index, icon, password, useKeyFiles,
                  nuOfKeyFiles, keyFilesPath, mountAtStartup);
    __tcitems.append(item);
    return item;

def getTCitems(active = None):
    '''
    Method creates and returns TCItem objects. 
    :param active:If no parameter or None is supplied it will return all objects. If True is supplied, it will return active items. If False is supplied, it will return inactive objects
    '''
    items = [];
    i = 0;
    if active == None :
        while i < __supportedTCFilesNum__:
            items.append(createTCitem(i));
            i += 1;
    else:
        if active:
            s = consts.trueString;
        else:
            s = consts.falseString
        while i < __supportedTCFilesNum__ :
            activeStr = __settings__.getSetting(consts.active + str(i));
            if s == activeStr :
                items.append(createTCitem(i));
            i += 1;
    return items;

def getNumberOfItems(active = None):
    '''
    Returns number of items
    :param active: If no parameter or None is supplied it will return all objects. If True is supplied, it will return active items. If False is supplied, it will return inactive objects
    '''
    return len(getTCitems(active));

def createKeyFile(filePath, randomNumberGenerator = ""):
    '''
    Method executes creation of a key file through shell script
    :param filePath: path to the key file
    :param randomNumberGenerator: randomness generator to be used. Default is /dev/random. Any user file can be used
    '''
    cmd = "\"" + shellScript + "\" " + consts.commandCreateKeyFile + " " + filePath + " " + randomNumberGenerator ;
    
    xbmc.log(consts.logExecutingScript + cmd, level=xbmc.LOGDEBUG); 
        
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();
    
    xbmc.log(consts.logStandardOut + str(output), level=xbmc.LOGDEBUG);
    xbmc.log(consts.logErrorOut + str(errors), xbmc.LOGERROR if errors else xbmc.LOGDEBUG);
        
    returnCode = int(output[len(output)-2:]);
           
    if returnCode == 0:
        return True;
    else :
        return False
    
def createVolumeWithHiddenVolume(filePath, mountPoint, passOuter, keysOuter, sizeOuter, passHidden, keysHidden,
                                 sizeHidden, fileSys, randomDataGenerator ="/dev/random"):   
    '''
    The method executes creation of truecrypt volume with hidden volume though shell script
    :param filePath: path to the volume
    :param mountPoint: mount point
    :param passOuter: pass for the outer volume
    :param keysOuter: key files path for the outer volume
    :param sizeOuter: size of the outer volume
    :param passHidden: pass for the hidden volume
    :param keysHidden: key file path fot the hidden volume
    :param sizeHidden: size of the hidden volume
    :param fileSys: file system to be used. ntfs makes problems and usually damages the volume
    :param randomDataGenerator:randomness generator to be used. Default is /dev/random. Any user file can be used
    '''
    escapedOuterPass =  sutils.escapeCharsForShell(passOuter);
    escapedHiddenPass = sutils.escapeCharsForShell(passHidden);
    
    pathPartPfCmd =  "\"" + shellScript + "\" " + consts.commandCreateContWithHiddenVolume + " \"" + filePath + "\" \"" + mountPoint + "\"";
    passPartOfCmd1 = "\"" + escapedOuterPass +"\" \"" +  keysOuter + "\"";
    passPartOfCmd2 = "\"" + escapedHiddenPass +"\" \"" + keysHidden + "\"";
    lastPartOfCmd = str(sizeHidden) + " " + fileSys + " " + randomDataGenerator;
    
    # string for use in debug print    
    hiddenPassKey = ("\"" + escapedOuterPass  + "\"" if debugLogPassword else "\"*****\"") + " " + ("\"" + keysOuter  + "\"" if debugLogKeyFiles else " \"*****\"") + " " + str(sizeOuter) + " " + ("\"" + passHidden  + "\"" if debugLogPassword else "\"*****\"") + " " + ("\"" + keysHidden  + "\"" if debugLogKeyFiles else " \"*****\"");
    
    # real command string
    cmd = pathPartPfCmd + " " + passPartOfCmd1 + " " + str(sizeOuter) + " " + passPartOfCmd2 + " " + lastPartOfCmd; 

    # string for use in debug print        
    tempcmd = consts.logExecutingScript +  pathPartPfCmd + " " + hiddenPassKey + " " + lastPartOfCmd;
    xbmc.log(consts.logExecutingScript + tempcmd, level=xbmc.LOGDEBUG); 
        
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();
    
    xbmc.log(consts.logStandardOut + str(output), level=xbmc.LOGDEBUG);
    xbmc.log(consts.logErrorOut + str(errors), xbmc.LOGERROR if errors else xbmc.LOGDEBUG);
        
    returnCode = int(output[len(output)-2:]);
           
    if returnCode == 0:
        return True;
    else :
        return False
    
def getPartitions():
    '''
    The method returns all(sdXY, hdXY) available partitions in /dev, through shell script as a list. 
    '''
    cmd = "\"" + shellScript + "\" " + consts.commandGetPartition;
    
    xbmc.log(consts.logExecutingScript + cmd, level=xbmc.LOGDEBUG);
        
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();
    
    xbmc.log(consts.logStandardOut + str(output), level=xbmc.LOGDEBUG);
    xbmc.log(consts.logErrorOut + str(errors), xbmc.LOGERROR if errors else xbmc.LOGDEBUG);
    
    return output.split();

def getPartitionLabel(partition):
    '''
    Method returns partition label if available though shell script
    :param partition: partition for which label should be returned
    '''
    cmd = "\"" + shellScript + "\" " + consts.commandGetParitionLabel + " " + partition;
    
    xbmc.log(consts.logExecutingScript + cmd, level=xbmc.LOGDEBUG);
        
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();
    
    xbmc.log(consts.logStandardOut + str(output), level=xbmc.LOGDEBUG);
    xbmc.log(consts.logErrorOut + str(errors), xbmc.LOGERROR if errors else xbmc.LOGDEBUG);
    
    return None if output == None or output == "" else output;

def getPartitionById(partition):
    '''
    Method returns /dev/disk/by-id identification of the partition to make persitent links if disks are mounted 
    in different order
    :param partition: partition for which id is returned
    '''
    cmd = "\"" + shellScript + "\" " + consts.commandPartitionById + " " + partition;
    
    xbmc.log(consts.logExecutingScript + cmd, level=xbmc.LOGDEBUG);
       
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();
    
    xbmc.log(consts.logStandardOut + str(output), level=xbmc.LOGDEBUG);
    xbmc.log(consts.logErrorOut + str(errors), xbmc.LOGERROR if errors else xbmc.LOGDEBUG);
    
    return None if output == None or output == "" else output;

def addExecDirToPath():
    '''
    Adds truecrypt executables and shell script on the PATH-
    '''
    cmd = "\"" + shellScript + "\" " + consts.commandAddToPath;
    
    xbmc.log(consts.logExecutingScript + cmd, level=xbmc.LOGDEBUG);
      
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();
    
    xbmc.log(consts.logErrorOut + str(errors), xbmc.LOGERROR if errors else xbmc.LOGDEBUG);
    

def moutedFileListWithMoutPoints():
    '''
    The method returns dictionary containing all mounted volumes and their mount points through the usage of 
    shell script. Key is mounted volume and value is mounted file.
    '''
    map ={};
    # getting mounted files
    cmd = "\"" + shellScript + "\" " + consts.commandGetMountedFiles;
     
    xbmc.log(consts.logExecutingScript + cmd, level=xbmc.LOGDEBUG);
       
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();
    
    xbmc.log(consts.logStandardOut + str(output), level=xbmc.LOGDEBUG);
    xbmc.log(consts.logErrorOut + str(errors), xbmc.LOGERROR if errors else xbmc.LOGDEBUG);
     
    if output == None or output == "":
        return None;
    fileList = output.splitlines();
    
    # getting mount points for every mounted volume 
    for f in fileList:
        cmd = "\"" + shellScript + "\" " + consts.commandGetMountPoint + " " + f
     
        xbmc.log(consts.logExecutingScript + cmd, level=xbmc.LOGDEBUG);
       
        p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
        output, errors = p.communicate();
         
        xbmc.log(consts.logStandardOut + str(output), level=xbmc.LOGDEBUG);
        xbmc.log(consts.logErrorOut + str(errors), xbmc.LOGERROR if errors else xbmc.LOGDEBUG);
         
        map[f.rstrip()] = output.rstrip();
        
    return map;


def getRealFilePath(path):
    '''
    The method for real file path insted of hard/soft links. It returns real path for the file.
    This is particlary useful when comparing files. In addon settings can be a link while truecrypt list feature
    shows real file. 
    :param path: path which should be checked.
    '''
    
    cmd = "\"" + shellScript + "\" " + consts.commandCheckLink + " \"" + path + "\"";
     
    xbmc.log(consts.logExecutingScript + cmd, level=xbmc.LOGDEBUG);  
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();
    
    xbmc.log(consts.logStandardOut + str(output), level=xbmc.LOGDEBUG);
    xbmc.log(consts.logErrorOut + str(errors), xbmc.LOGERROR if errors else xbmc.LOGDEBUG);
    return output;
    

def destroyItems():
    '''
    This method will remove passwords and key files path out of the scope from all created items.
    '''
    for item in __tcitems:
        item.destroy();
        del item;


