'''
Created on 8.9.2013

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

import subprocess;
import sutils;
import xbmc;  # @UnresolvedImport
import consts;
import re;

def __createBasicExecutionString(deviceType = "auto"):
    '''
    It creates basic template for the execution string. It contains smartctl command with the link
    to the database and device type if other then auto
    :param deviceType: type of the device
    '''
    cmd = consts.binFolder + consts.smartctlWithDB + ("" if deviceType == "auto" else " --device=" + deviceType);
    return cmd

def executeSelfTest(testType, device, deviceType = "auto"):
    
    cmd = __createBasicExecutionString(deviceType) + " --test=" + testType + " " + device 
    
    xbmc.log(consts.logExecutingCommand + cmd, level=xbmc.LOGDEBUG);
    
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();
    
    xbmc.log(consts.logStandardOut + str(output), level=xbmc.LOGDEBUG);
    xbmc.log(consts.logErrorOut + str(errors), xbmc.LOGERROR if errors else xbmc.LOGDEBUG);
    
    return True if output.find(consts.responseSelfTestStarted) != -1 else False;
    
    
def cancelSelfTest(device, deviceType = "auto"):
    
    cmd = __createBasicExecutionString(deviceType) + " --abort " + device 
    
    xbmc.log(consts.logExecutingCommand + cmd, level=xbmc.LOGDEBUG);
    
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();
    
    xbmc.log(consts.logStandardOut + str(output), level=xbmc.LOGDEBUG);
    xbmc.log(consts.logErrorOut + str(errors), xbmc.LOGERROR if errors else xbmc.LOGDEBUG);
   
def getOverallHealthStatus(device, deviceType = "auto"):
    cmd = __createBasicExecutionString(deviceType) + " -H " + device
     
    xbmc.log(consts.logExecutingCommand + cmd, level=xbmc.LOGDEBUG);
    
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();
    
    xbmc.log(consts.logStandardOut + str(output), level=xbmc.LOGDEBUG);
    xbmc.log(consts.logErrorOut + str(errors), xbmc.LOGERROR if errors else xbmc.LOGDEBUG);
    
    if output:
        return output;
    else:
        return errors;
    
def getAllSmartDeviceInformation(device, deviceType = "auto"):
    cmd = __createBasicExecutionString(deviceType) + " --all " + device
     
    xbmc.log(consts.logExecutingCommand + cmd, level=xbmc.LOGDEBUG);
    
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();
    
    xbmc.log(consts.logStandardOut + str(output), level=xbmc.LOGDEBUG);
    xbmc.log(consts.logErrorOut + str(errors), xbmc.LOGERROR if errors else xbmc.LOGDEBUG);
    
    if output:
        return output;
    else:
        return errors;
    
def getAllDeviceformation(device, deviceType = "auto"):
    cmd = __createBasicExecutionString(deviceType) + " --xall " + device
     
    xbmc.log(consts.logExecutingCommand + cmd, level=xbmc.LOGDEBUG);
    
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();
    
    xbmc.log(consts.logStandardOut + str(output), level=xbmc.LOGDEBUG);
    xbmc.log(consts.logErrorOut + str(errors), xbmc.LOGERROR if errors else xbmc.LOGDEBUG);
    
    if output:
        return output;
    else:
        return errors;
    
def basicDriveInfo(device, deviceType = "auto"):
    cmd = __createBasicExecutionString(deviceType) + " -i " + device
     
    xbmc.log(consts.logExecutingCommand + cmd, level=xbmc.LOGDEBUG);
    
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();
    
    xbmc.log(consts.logStandardOut + str(output), level=xbmc.LOGDEBUG);
    xbmc.log(consts.logErrorOut + str(errors), xbmc.LOGERROR if errors else xbmc.LOGDEBUG);
    
    if output:
        return output;
    else:
        return errors;
    
def driveCapabilities(device, deviceType = "auto"):
    cmd = __createBasicExecutionString(deviceType) + " -c " + device
     
    xbmc.log(consts.logExecutingCommand + cmd, level=xbmc.LOGDEBUG);
    
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();
    
    xbmc.log(consts.logStandardOut + str(output), level=xbmc.LOGDEBUG);
    xbmc.log(consts.logErrorOut + str(errors), xbmc.LOGERROR if errors else xbmc.LOGDEBUG);
    
    if output:
        return output;
    else:
        return errors;
    
def getLog(logType, device, deviceType = "auto"):
    cmd = __createBasicExecutionString(deviceType) + " --log=" + logType + " " + device
     
    xbmc.log(consts.logExecutingCommand + cmd, level=xbmc.LOGDEBUG);
    
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();
    
    xbmc.log(consts.logStandardOut + str(output), level=xbmc.LOGDEBUG);
    xbmc.log(consts.logErrorOut + str(errors), xbmc.LOGERROR if errors else xbmc.LOGDEBUG);
    
    if output:
        return output;
    else:
        return errors;
    
def driveSmartAttributes(device, deviceType = "auto"):
    '''
    It return vendor specific SMART attribures.
    :param device:
    :param deviceType:
    '''
    cmd = __createBasicExecutionString(deviceType) + " -A " + device
     
    xbmc.log(consts.logExecutingCommand + cmd, level=xbmc.LOGDEBUG);
    
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();
    
    xbmc.log(consts.logStandardOut + str(output), level=xbmc.LOGDEBUG);
    xbmc.log(consts.logErrorOut + str(errors), xbmc.LOGERROR if errors else xbmc.LOGDEBUG);
    
    if output:
        return output;
    else:
        return errors;
    
def getDeviceLog(logType, device, deviceType = "auto"):
    cmd = __createBasicExecutionString(deviceType) + " --log="\
          + logType + " " + device
     
    xbmc.log(consts.logExecutingCommand + cmd, level=xbmc.LOGDEBUG);
    
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();
    
    xbmc.log(consts.logStandardOut + str(output), level=xbmc.LOGDEBUG);
    xbmc.log(consts.logErrorOut + str(errors), xbmc.LOGERROR if errors else xbmc.LOGDEBUG);
    
    if output:
        return output;
    else:
        return errors;

def enableSMART(enable, device, deviceType = "auto"):
    cmd = __createBasicExecutionString(deviceType) + " --smart=" + \
         (consts.on if enable else consts.off) + " " + device
     
    xbmc.log(consts.logExecutingCommand + cmd, level=xbmc.LOGDEBUG);
    
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();
    
    xbmc.log(consts.logStandardOut + str(output), level=xbmc.LOGDEBUG);
    xbmc.log(consts.logErrorOut + str(errors), xbmc.LOGERROR if errors else xbmc.LOGDEBUG);
    
    # check if command was successfull
    if enable:
        if output.find(consts.responseSmartEnabled) != -1:
            return True;
        else:
            return False;
    else:
        if output.find(consts.responseSmartDisabled) != -1:
            return True;
        else:
            return False;
        
def enableAutoOfflineTest(enable, device, deviceType = "auto"):
    cmd = __createBasicExecutionString(deviceType) + " --offlineauto=" + \
         (consts.on if enable else consts.off) + " " + device
     
    xbmc.log(consts.logExecutingCommand + cmd, level=xbmc.LOGDEBUG);
    
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();
    
    xbmc.log(consts.logStandardOut + str(output), level=xbmc.LOGDEBUG);
    xbmc.log(consts.logErrorOut + str(errors), xbmc.LOGERROR if errors else xbmc.LOGDEBUG);
    
    # check if command was successfull
    if enable:
        if output.find(consts.responseAutoOfflineEnabled) != -1:
            return True;
        else:
            return False;
    else:
        if output.find(consts.responseAutoOfflineDisabled) != -1:
            return True;
        else:
            return False;
        
    

def getStatusInfo(device, deviceType = "auto"):
    cmd = __createBasicExecutionString(deviceType) + " -ciH " + device
     
    xbmc.log(consts.logExecutingCommand + cmd, level=xbmc.LOGDEBUG);
    
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();
    
    xbmc.log(consts.logStandardOut + str(output), level=xbmc.LOGDEBUG);
    xbmc.log(consts.logErrorOut + str(errors), xbmc.LOGERROR if errors else xbmc.LOGDEBUG);
    
    dic = {};
    
    deviceSuported = False if (output.find(consts.responseUnknowDeviceString) != -1 
                               or output.find(consts.responseFailedToReadDevice) != -1
                               or output.find(consts.responseMandatoryCommandFailed) != -1) else True;
    
    dic[consts.paramDeviceIsSuported] = deviceSuported;    
    if deviceSuported:
        
        match = sutils.findMatch(output, consts.regexSmartAvailable, re.MULTILINE, 1);
        if match != None:
            dic[consts.paramSmartAvailable] = True if match.find("Available") != -1 else False;
        
        match = sutils.findMatch(output, consts.regexSmartEnabled, re.MULTILINE, 1);
        if match != None:
            dic[consts.paramSmartEnabled] = True if match.find("Enabled") != -1 else False;
        
        match = sutils.findMatch(output, consts.regexOffLineDataCol, re.MULTILINE, 1);
        if match != None:
            dic[consts.paramAutoOfflineCollection] = False if match.find("Disabled") != -1 else True;
            
        match = sutils.findMatch(output, consts.regexShortTestDuration, re.DOTALL |re.MULTILINE, 1);
        if match != None:
            dic[consts.paramShortTestDuration] = match;
        
        match = sutils.findMatch(output, consts.regexLongTestDuration, re.DOTALL |re.MULTILINE, 1);
        if match != None:
            dic[consts.paramLongTestDuration] = match;
            
        match = sutils.findMatch(output, consts.regexConveyanceTestDuration, re.DOTALL |re.MULTILINE, 1);
        if match != None:
            dic[consts.paramConveyanceTestDuration] = match;
            
        match = sutils.findMatch(output, consts.regexTestRunning, re.DOTALL |re.MULTILINE, 1);
        if match != None:
            dic[consts.paramSelfTestRunning] = True;
            dic[consts.paramSelfTestRemaining] = match;
            dic[consts.paramSelfTestProgress] = str(100 - int(match)); 
        else:
            dic[consts.paramSelfTestRunning] = False;
        
        match = sutils.findMatch(output, consts.regexOverallHealth, re.DOTALL |re.MULTILINE, 1);
        if not match:
            match = sutils.findMatch(output, consts.regexOverallHealthAlt, re.DOTALL |re.MULTILINE, 1);
        if match != None:
            dic[consts.paramOverallHealth] = match;
                          
    xbmc.log(consts.logHeader + "found params -" + str(dic) , level=xbmc.LOGDEBUG);
    return dic;
    