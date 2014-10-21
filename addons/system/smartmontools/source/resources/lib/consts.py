'''
This module is meant as constant data manager
Created on

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


addonId = "plugin.program.smartmontools";
settingRunDaemonOnStartup = "runOnStartup";
settingDiskTypes = "diskTypes";
settingDBupdates = "updateDB";
settingLastDBupdateChecked = "lastDBupdateChecked";
settingDBupdateInterval = "dbUpdateInterval";
settingSmardPoupus = "showPopups"
settingSmartdStartupPopup = "showSmartdStartUpPopup";

binFolder = "/storage/.kodi/addons/plugin.program.smartmontools/bin/";
smartdScript = binFolder + "smartd-daemon";
script = binFolder + "smartmontools.sh";
updateScript = binFolder + "update-smart-drivedb";
commandStart = "start";
commandStop = "stop";
commandStatus = "status";
commandReload = "reload";
commandRunTestNowDeamon = "report";
commandDisks = "disks";
smartctl = "smartctl";
smartd = "smartd";

interfaceAta = "ata";
interfaceScsi = "scsi";
interfaceSata = "sata";

dialogHeader = "smartmontools";

fileDB = "/storage/.kodi/userdata/addon_data/plugin.program.smartmontools/drivedb.h";
fileDBDefault = "/storage/.kodi/addons/plugin.program.smartmontools/resources/default/drivedb.h";
fileDaemonConfig = "/storage/.kodi/userdata/addon_data/plugin.program.smartmontools/smartd.conf";
# fileDaemonConfigLink = "/storage/.config/smartd.conf"
fileDaemonConfigDefault = "/storage/.kodi/addons/plugin.program.smartmontools/resources/default/smartd.conf"
fileSystemLog = "/var/log/messages";

commandDBPart = "--drivedb=" + fileDB;
smartctlWithDB = smartctl + " " + commandDBPart;

paramDevice = "device";
paramDiskId = "id";
paramDiskType = "type"

paramAutoOfflineCollection="Auto offline collection";
paramShortTestDuration = "Short test duration";
paramLongTestDuration = "Long test duration";
paramConveyanceTestDuration = "Conveyance test duration";
paramDeviceIsSuported = "Device supported";
paramSmartAvailable = "SMART supported";
paramSmartEnabled = "SMART enabled";
paramSelfTestRunning = "Self-test running";
paramSelfTestRemaining = "Self-test remaining percentage";
paramSelfTestProgress = "Self-test progress percentage";
paramOverallHealth = "Overall health";
paramIndex = "index";

# test types
testShort = "short";
testLong = "long";
testOffline = "offline";
testConveyance = "conveyance";


deviceTypeList = ["auto", "ata", "scsi", "sat", "usbcypress", "usbjmicron", "usbsunplus", "marvell"];

logStandardOut = "smartmontools shell's std out:\n";
logErrorOut = "smartmontools shell's err out:\n";
logExecutingCommand = "smartmontools executing command: ";
logHeader = "smartmontools: ";
logSmartdHeader = "smartd log";
logSmartdHeader = "smartd: ";
logSmartctlHeader = "smartctl: ";
logXbmcLog = "XBMC log";

logTypeError = "error";
logTypeXerror = "xerror";
logTypeSelftest = "selftest";
logTypeXSelftest = "xselftest";
logTypeDirectory = "directory";
logTypeBackground = "background";
logTypeCurentTemperatureAndRanges = "scttempsts";
logTypeTemperatureHistory = "scttemphist";
logTypeDeviceStatistics = "devstat";
logTypeSATAPhyEventCounters = "sataphy";
logTypeSASProptocol = "sasphy";
logTypeSsd = "ssd";
logType = "";
logType = "";
logType = "";

logTypeToDescStringIdDic = {logTypeError:50041, logTypeXerror:50042, logTypeSelftest:50043,
                            logTypeXSelftest:50045, logTypeDirectory:50052, logTypeBackground:50047,
                            logTypeCurentTemperatureAndRanges:50048, logTypeTemperatureHistory:50049,
                            logTypeDeviceStatistics:50046, logTypeSATAPhyEventCounters:50050,
                            logTypeSASProptocol:50051, logTypeSsd:50053};
                            

availableLogsScsi = (logTypeError, logTypeSelftest, logTypeBackground, logTypeSASProptocol, logTypeSsd);
availableAta = (logTypeError, logTypeXerror,logTypeSelftest, logTypeXSelftest, logTypeDirectory,
                logTypeCurentTemperatureAndRanges, logTypeTemperatureHistory, logTypeDeviceStatistics,
                logTypeSATAPhyEventCounters, logTypeSsd);

sepTestOveral = "=== START OF READ SMART DATA SECTION ===";

regexOffLineDataCol = "Auto\sOffline\sData\sCollection:\s(.*)\.";
regexShortTestDuration = "Short\sself-test\sroutine.*?\(\s*(\d*)\)\sminutes";
regexLongTestDuration = "Extended\sself-test\sroutine.*?\(\s*(\d*)\)\sminutes";
regexConveyanceTestDuration = "Conveyance\sself-test\sroutine.*?\(\s*(\d*)\)\sminutes";
regexSmartAvailable = "SMART\ssupport\sis:\s*?(.*?)/s-";
regexSmartEnabled = "SMART\ssupport\sis:\s(\w*?)$";
regexTestRunning = "Self-test\sroutine\sin\sprogress.*?(\d*)%\sof\stest\sremaining";
regexOverallHealth = "SMART\soverall-health.*?result:\s(\w*)";
regexOverallHealthAlt = "SMART\sHealth\sStatus:\s(\w*)";
regexXbmcLogEntries = "\d\d:\d\d:\d\d\sT:\d+\s+\S*\s*[^\n]*?smartmontools.*?(?=\d\d:\d\d:\d\d\sT:\d+)";
#regexXbmcLogEntries1 = "\d\d:\d\d:\d\d\sT:\d+.*?(?!^\d\d:\d\d:\d\d\sT:\d+).*?program\.smartmontools.*?(?=\d\d:\d\d:\d\d\sT:\d+)"
#regexXbmcLogEntries = "(\d\d:\d\d:\d\d\sT:\d+)\s+\S*\s*[^\n]*?smartmontools.*?(?=\1)"
#regexXbmcLogEntries = "\d\d:\d\d:\d\d\sT:\d+\s+\S*\s*.*?smartmontools.*?(?=\d\d:\d\d:\d\d\sT:\d+)" 
#regexXbmcLogEntries = "(?P<timestamp>\d\d:\d\d:\d\d\sT:\d+)\s+\S*\s*[^\n]*?smartmontools.*?(?=(?P=timestamp))" 

responseUnknowDeviceString = "Please specify device type with the -d option.";
responseFailedToReadDevice = "Read Device Identity failed:";
responseMandatoryCommandFailed = "A mandatory SMART command failed: exiting."
responseSelfTestStarted = "Testing has begun.";
responseSmartEnabled = "SMART Enabled";
responseSmartDisabled = "SMART Disabled";
responseAutoOfflineEnabled = "SMART Automatic Offline Testing Enabled";
responseAutoOfflineDisabled = "SMART Automatic Offline Testing Disabled";

on = "on";
off = "off"



colorBlue = "[COLOR FF8ABEE2]";
colorShadeOfRed = "[COLOR FFD80000]"
colorShadeOfGreen = "[COLOR FF00FF00]"
colorOrange = "[COLOR FFFFA500]"
colorEnd = "[/COLOR]";
fontBold = "[B]";
fontBoldEnd = "[/B]";


