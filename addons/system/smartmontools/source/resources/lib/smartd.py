'''
Created on 1.9.2013

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
import subprocess;
import xbmcaddon;  # @UnresolvedImport
import xbmc;  # @UnresolvedImport
import sutils;

addon= xbmcaddon.Addon(id = "plugin.program.smartmontools");

def startDaemon():
    cmd = "\"" + consts.smartdScript + "\" " + consts.commandStart;
    xbmc.log("smartmontools: starting daemon. " + cmd, level=xbmc.LOGDEBUG);
            
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();    
    
    xbmc.log(consts.logStandardOut + str(output), level=xbmc.LOGDEBUG);
    xbmc.log(consts.logErrorOut + str(errors), xbmc.LOGERROR if errors else xbmc.LOGDEBUG);
    
 
        
def stopDaemon():
    cmd = "\"" + consts.smartdScript + "\" " + consts.commandStop;
    
    xbmc.log("smartmontools: stopping daemon. " + cmd, level=xbmc.LOGDEBUG);
            
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();
    
    xbmc.log(consts.logStandardOut + str(output), level=xbmc.LOGDEBUG);
    xbmc.log(consts.logErrorOut + str(errors), xbmc.LOGERROR if errors else xbmc.LOGDEBUG);    

    
def reloadDaemonConfiguration():
    cmd = "\"" + consts.smartdScript + "\" " + consts.commandReload;
    
    xbmc.log("smartmontools: reloading daemon configuration. "  + cmd, level=xbmc.LOGDEBUG);
            
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate(); 
    
    xbmc.log(consts.logStandardOut + str(output), level=xbmc.LOGDEBUG);
    xbmc.log(consts.logErrorOut + str(errors), xbmc.LOGERROR if errors else xbmc.LOGDEBUG);   


def runDaemonTestNow():
    cmd = "\"" + consts.smartdScript + "\" " + consts.commandRunTestNowDeamon;
    
    xbmc.log("smartmontools: executing deamon test now. "  + cmd, level=xbmc.LOGDEBUG);
            
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();
    
    xbmc.log(consts.logStandardOut + str(output), level=xbmc.LOGDEBUG);
    xbmc.log(consts.logErrorOut + str(errors), xbmc.LOGERROR if errors else xbmc.LOGDEBUG);
        
def daemonRunning():
    cmd = "\"" + consts.smartdScript + "\" " + consts.commandStatus;
    
    xbmc.log("smartmontools: checking daemon status. "  + cmd, level=xbmc.LOGDEBUG);
            
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();
    
    xbmc.log(consts.logStandardOut + str(output), level=xbmc.LOGDEBUG);
    xbmc.log(consts.logErrorOut + str(errors), xbmc.LOGERROR if errors else xbmc.LOGDEBUG);    

    if output.find("is running") != -1:
        return True;
    else:
        return False;
    
def getLog():   
    xbmc.log("smartmontools: reading system log.", level=xbmc.LOGDEBUG);
    return sutils.readFileAsStringAndFilterShell(consts.fileSystemLog, consts.smartd);
