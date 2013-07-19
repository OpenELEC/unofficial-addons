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

import os;
import subprocess;
import xbmcaddon;  # @UnresolvedImport
import sutils;


__supportedTCFilesNum__=10;
__settings__ = xbmcaddon.Addon(id='plugin.program.truecrypt');
__tcitems = [];
debug = True if __settings__.getSetting("debug") == "true" else False;
debugLogPassword = True if __settings__.getSetting("debugPrintPassword") == "true" else False;

class TCitem:

    def __str__(self):
        return "TC item [name: " + self.name + ", file: " + self.filePath + ", mount point: " + self.mountPoint + "]";

    def __init__(self, name, filePath, mountPoint, active, index, icon="", password=""):
        self.name = name;
        self.filePath = filePath;
        self.mountPoint = mountPoint;
        self.active = active;
        self.password = password;
        self.icon = icon;
        self.index = index;
        self.errorMessage = "";

    def mount(self, password=""):
        cmd = "\"" + __settings__.getSetting( "truecrypt" ) + "\" "
        cmd +="\"mount\" " ;
        cmd += "\"" + self.filePath + "\" ";
        cmd += "\"" + self.mountPoint + "\" ";
        
        escapedPassword = sutils.escapeCharsForShell(password);
        
        if debug:
            print("Truecrypt executing shell script:\n" + cmd + ("\"" + escapedPassword  + "\"" if debugLogPassword else "\"*****\""));
        
        cmd += "\"" + escapedPassword + "\"";
        p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
        output, errors = p.communicate();
        
        if debug:
            print("Truecrypt shell's err out:\n" + str(errors));
            print("Truecrypt shell's std out:\n" + str(output));            

        auxmnt = str(output);
        __settings__.setSetting("tc_aux_mnt" + str(self.index), auxmnt);
        if errors != None:
            self.errorMessage= str(errors);
        else :
            self.errorMessage="";

    def isStoredPassword(self):
        if self.password == "" or self.password == None :
            return False;
        else:
            return True;

    def unmount(self):
        cmd = "\"" + __settings__.getSetting( "truecrypt" ) + "\"";
        cmd += " dismount ";
        cmd += "\"" + self.filePath + "\" ";
        cmd += "\"" + self.mountPoint + "\" ";
        cmd += "\"" + __settings__.getSetting("tc_aux_mnt" + str(self.index)) + "\"";
        
        if debug:
            print("Truecrypt executing shell script:\n" + cmd);
            
        p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
        output, errors = p.communicate();
        
        if debug:
            print("Truecrypt shell's err out:\n" + str(errors));
            print("Truecrypt shell's std out:\n" + str(output)); 
            
        if errors != None:
            self.errorMessage= str(errors);
        else :
            self.errorMessage="";

    def isMounted(self):
        cmd = "\"" + __settings__.getSetting( "truecrypt" ) + "\" ";
        cmd += "ismounted ";
        cmd += "\"" + self.filePath + "\" ";
        cmd += "\"" + self.mountPoint + "\"";
        
        if debug:
            print("Truecrypt executing shell script:\n" + cmd);

        p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
        output, errors = p.communicate();
        if debug:
            print("Truecrypt shell's err out:\n" + str(errors));
            print("Truecrypt shell's std out:\n" + str(output));
        returnCode = int(output[len(output)-2:]);
#        returnCode = 1;
        
            
        if returnCode == 0:
            return True;
        else :
            return False;

    def changePassword(self, oldPass="", newPass=""):
        self.lock();
        cmd = "\"" + __settings__.getSetting( "truecrypt" ) + "\" "
        cmd +="\"changepass\" " ;
        cmd += "\"" + self.filePath + "\" ";
        
        escapedOldPass = sutils.escapeCharsForShell(oldPass);
        escapedNewPass = sutils.escapeCharsForShell(newPass);
        
        if debug:
            print("Truecrypt executing shell script:\n" + cmd + ("\"" + escapedOldPass  + "\" " + "\"" + escapedNewPass + "\"" if debugLogPassword else "\"*****\" \"*****\""));
            
        cmd += "\"" + escapedOldPass + "\" ";
        cmd += "\"" + escapedNewPass + "\"";
 
        p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
        output, errors = p.communicate();
        
        if debug:
            print("Truecrypt shell's err out:\n" + str(errors));
            print("Truecrypt shell's std out:\n" + str(output));
            
        self.unlock();
        if errors != None:
            self.errorMessage= str(errors);
        else :
            self.errorMessage="";
        returnCode = int(output[len(output)-2:]);
#        returnCode = 1;

        if returnCode == 0:
            return True;
        else :
            return False;


    def format(self, fs):
        self.lock();
        cmd = "\"" + __settings__.getSetting( "truecrypt" ) + "\"";
        cmd += " format ";
        cmd += "\"" + self.filePath + "\" ";
        cmd += "\"" + self.mountPoint + "\" ";
        cmd += "\"" + __settings__.getSetting("tc_aux_mnt" + str(self.index)) + "\" ";
        cmd += fs;

        if debug:
            print("Truecrypt executing shell script:\n" + cmd)
        p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
        output, errors = p.communicate();
        
        if debug:
            print("Truecrypt shell's err out:\n" + str(errors));
            print("Truecrypt shell's std out:\n" + str(output));
            
        returnCode = int(output[len(output)-2:]);
#        returnCode = 0;        
            
        self.unlock();
        if errors != None:
            self.errorMessage= str(errors);
        else :
            self.errorMessage="";
        if returnCode == 0:
            return True;
        else :
            return False;

    def createNewFile(self, size, password):
        self.lock();
        cmd = "\"" + __settings__.getSetting( "truecrypt" ) + "\" create" + " \"" + self.filePath + "\" \"" + self.mountPoint + "\" \""; 
        
        escapedPassword = sutils.escapeCharsForShell(password);
        
        if debug:
            print("Truecrypt executing shell script:\n" + cmd + (escapedPassword + "\" "  if debugLogPassword else "******\" ") + str(size));

        cmd = cmd + escapedPassword + "\" " + str(size);
        
        p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
        output, errors = p.communicate();
        if debug:
            print("Truecrypt shell's err out:\n" + str(errors));
            print("Truecrypt shell's std out:\n" + str(output));
            
        self.unlock();
        if not output == None:
            print(str(output));
        if not errors == None:
            print(str(errors))  

    def __findTcAuxMnt(self, sourceStr):
        print("fond: " + sourceStr);
        if sourceStr == "" or sourceStr == None :
            return "";
        else:
            return sourceStr;

    
    def delete(self):
        try :
            os.remove(self.filePath);
        except OSError, arg:
            self.errorMessage = str(arg);
            return False;
        if os.path.exists(self.filePath):
            return False;
        else:
            return True;
        
    def remove_tc_aux_mnt(self):
        __settings__.setSetting("tc_aux_mnt" + str(self.index), "");

    def readSettings(self):
        strI= str(self.index) ;
        self.name = __settings__.getSetting("name" + strI);
        self.filePath = __settings__.getSetting("filePath" + strI);
        self.mountPoint = __settings__.getSetting("mountPoint" + strI);
        self.active = __settings__.getSetting("active" + strI);
        self.__password = __settings__.getSetting("password " + strI);
        self.icon = __settings__.getSetting("icon " + strI);


    def deactivate(self):
        __settings__.setSetting("active" + str(self.index), "false");

    def resetSettings(self):
        strI = str(self.index);
        __settings__.setSetting("name" + strI, "Item " + strI);
        __settings__.setSetting("filePath" +  strI, "");
        __settings__.setSetting("drive" + strI, "");
        __settings__.setSetting("active" + strI, "false");
        __settings__.setSetting("password" + strI, "")
        __settings__.setSetting("icon" + strI, "");
        __settings__.setSetting("passordUse" + strI, "false");


    def setSettings(self, name = None, filePath = None, drive = None, active = None,
    password = None, icon = None):
        strI = str(self.index);
        if not name == None :
            __settings__.setSetting("name" + strI, name);
            self.name = name;

        if not filePath == None:
            __settings__.setSetting("filePath" +  strI, filePath);
            self.filePath = filePath;

        if not drive == None :
            __settings__.setSetting("drive" + strI, drive);
            self.mountPoint = drive;

        if active == None:
            pass;
        elif active == "true" or active == True :
            __settings__.setSetting("active" + strI, "true");
            self.active=True;
        else :
            __settings__.setSetting("active" + strI, "false");
            self.active=False;

        if not icon == None :
            __settings__.setSetting("icon" + strI, icon);
            self.icon = icon;

        if password == None:
            pass;
        elif password == "":
            __settings__.setSetting("password" + strI, password);
        else :
            self.setPassword(password);


    def setPassword(self, password):
        encodedPassword = sutils.encodeStr(password);
        self.password = encodedPassword;
        __settings__.setSetting("password" + str(self.index), encodedPassword);

    def lock(self):
        __settings__.setSetting("lock" + str(self.index), "true");

    def unlock(self):
        __settings__.setSetting("lock" + str(self.index), "false");

    def isLocked(self):
        if __settings__.getSetting("lock" + str(self.index)) == "true" :
            return True;
        else :
            return False;
        
    def getPassword(self):
        if self.password == "" or self.password == None :
            self.password =__settings__.getSetting("password" + str(self.index));
            if self.password == "" :
                return None;
        return sutils.decodeStr(self.password);

    def setDicSettings(self, dictionary, removePrevious = False):
        if removePrevious:
            self.resetSettings();

        strI = str(self.index);
        for key in dictionary:
            if key == "password":
                self.setPassword(dictionary.get(key));
            else:
                __settings__.setSetting(key + strI,  dictionary.get(key));
        self.readSettings();

    def getErrorMessage(self):
        return self.errorMessage;

def createTCitem(index):
    strI = str(index);
    name = __settings__.getSetting("name" + strI);
    filePath = __settings__.getSetting("filePath" +  strI);
    mountPoint = __settings__.getSetting("drive" + strI);
    a = __settings__.getSetting("active" + strI);
    if a == "true":
        active = True;
    else :
        active = False;
    password = __settings__.getSetting("password" + strI)
    icon = __settings__.getSetting("icon" + strI);
    item = TCitem(name, filePath, mountPoint, active,index, icon, password)
    __tcitems.append(item);
    return item;

def getTCitems(active = None):
    """
    Mehod returns TCItem objects. If no parameter or None is suplied it will return all objects.
    If True is supplied, it will return active items. If False is supplied, it will return inactive objects.
    """
    items = [];
    i = 0;
    if active == None :
        while i < __supportedTCFilesNum__:
            items.append(createTCitem(i));
            i += 1;
    else:
        if active:
            s = "true";
        else:
            s = "false"
        while i < __supportedTCFilesNum__ :
            activeStr = __settings__.getSetting("active" + str(i));
            if s == activeStr :
                items.append(createTCitem(i));
            i += 1;
    return items;

def destroyItems():
    for item in __tcitems:
        del item.password;
        del item;


