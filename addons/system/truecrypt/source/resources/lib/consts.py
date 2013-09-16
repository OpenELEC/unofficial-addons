# -*- coding: utf-8 -*-3
'''
This module is meant as constant data manager
Created on 29.7.2013

@author: Peter Smorada
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

import xbmcaddon;  # @UnresolvedImport
import xbmc;  # @UnresolvedImport

addonId = "plugin.program.truecrypt";
addon = xbmcaddon.Addon(id = addonId);
arrayVolumeType = [addon.getLocalizedString(50150), addon.getLocalizedString(50151), xbmc.getLocalizedString(222)];   # adds Cancel]; # truecrypt file , partition

# return values of is mounted method and their meaning
mounted = 0;
notMounted = 1;
mountPointInUse = 2;
unknownStatus = -1;

volume = "filePath";
drive = "drive";
password = "password";
newPassword = "newPass";
keyFiles = "keyFilesPath";
newKeyFiles = "new key files path";
size = "size";
outerVolume = "outer volume";
hiddenVolume = "hidden volume";
outerPassword = "outer password";
hiddenPassword = "hidden password";
outerKeyFiles = "outer key files paths";
hiddenKeyFiles = "hidden key files paths"
outerSize = "outer size";
hiddenSize = "hidden size";
fileSystem = "file system";
keyFileNumber = "keyFilesNumber";
newKeyFileNumber = "number of new key files";
useKeyFiles = "useKeyFiles";
icon = "icon";
active = "active";
itemName = "name";
storeKeyFileInfo = "store key file info";
index = "index";


# ids form settings.xml
# General
shellScript = "truecrypt";
createFolders = "createFolders";
riskyActions = "riskyActions";
passwordAndKeyFileManipulation = "passKeyManipulation";
mountChecks = "performMountChecks";
alternativeShellScriptUsage = "altShellScript"
alternativeShellScriptPath = "truecryptAlt";
debugMode = "debug";

# Security
dontStoreAnyInformation = "dontStoreAnything";
allowStoringPasswordAndKeyFile = "allowStorePassKey";
storeKeyFileInfo = "storeKeyFileUsage";
randomNumberGenerator = "randomNuGenerator";
printPassInDebug = "debugPrintPassword";
printKeyFilesInDebug = "debugPrintKeyfiles";

# item specific
mountAtStartup = "startupMount";
lock = "lock";
lockReason = "lckReason";

# shell script params
commandIsMounted = "ismounted";
commandMount = "mount";
commandMountHidden = "mountHidden";
commandUmount = "dismount";
commandAddKeyFiles = "addkeyfiles";
commandRemoveKeyFiles = "removekeyfiles";
commandChangeKeyFiles = "changekeyfiles";
commandChagePassword = "changepass";
commandFormat = "format";
commandCreateKeyFile = "createkey";
commandCreateContainer = "create";
commandCreateContWithHiddenVolume = "chv";
commandGetPartition = "gp";
commandGetParitionLabel = "gpl";
commandAddToPath = "path";
commandPartitionById = "by-id";
commandGetMountedFiles ="gmf";
commandGetMountPoint = "gmp";
commandCheckLink = "chlink";

# output to xbmc.log constants:
logStandardOut = "Truecrypt shell's std out:\n";
logErrorOut = "Truecrypt shell's err out:\n";
logExecutingScript = "Truecrypt executing shell script:\n";
logAlternativeScript = "Truecrypt: using alternative shell script.";

trueString = "true";
falseString = "false";

colorBlue = "[COLOR FF8ABEE2]";
colorShadeOfRed = "[COLOR FFD80000]"
colorShadeOfGreen = "[COLOR FF00FF00]"

colorEnd = "[/COLOR]";
fontBold = "[B]";
fontBoldEnd = "[/B]";
