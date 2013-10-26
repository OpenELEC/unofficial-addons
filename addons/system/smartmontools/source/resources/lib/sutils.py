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

import datetime;
import re;
import urllib2;
import sys;
import random;
import subprocess

shellCharsToBeEscaped = ["$", "\"", "\\", "`"];

def getDaysFromToday(numDays):
    dt = datetime.date.today();
    print(dt);
    i = 0;
    dictionary = {i : dt};
    if numDays > 0 :
        while i < numDays:
            i += 1;
            dictionary[i] = dt + datetime.timedelta(days=i);
    else:
        while i> numDays:
            i -= 1;
            dictionary[i] = dt + datetime.timedelta(days=i);
    return dictionary;

def findAllMatches(string, pattern, flag = re.MULTILINE | re.DOTALL):
    regex = re.compile(pattern , flag);
    list = regex.findall(string);
    re.purge();
    return list;

def findMatch(string, pattern, flag = re.MULTILINE | re.DOTALL, group = 0):
    m = re.search(pattern, string, flag);
    if m != None:
        match = m.group(group);
        print(match);
        return match;
    else:
        return None;

def createRequest(url, ParamDictionary={}):
    ""
    paramString = "";
    for key in ParamDictionary.keys():
        if paramString == "" :
            paramString = '?' + key + '=' + ParamDictionary.get(key);
        else :
            paramString = paramString + '&' + key + '=' + ParamDictionary.get(key);
    return urllib2.Request(url + paramString);

def getResponseBytes(request):
    ""
    response = urllib2.urlopen(request);
    string = response.read();
    print();
    response.close();
    return string;

def downloadFile(url, filePath, userAgent = None, sendStatusTo = None):

    request= createRequest(url);
    if not userAgent==None:
        request.add_header('User-Agent', userAgent);
    responce = urllib2.urlopen(request);
    downloadedFile = open(filePath, 'wb')
    meta = responce.info()
    fileSize = int(meta.getheaders("Content-Length")[0])
    print ("Downloading: %s Bytes: %s" % (filePath, fileSize));

    downloaded = 0;
    blockSize = 8192
    while True:
        buff = responce.read(blockSize)
        if not buff:
            break

        downloaded += len(buff)
        downloadedFile.write(buff);
        status = downloaded * 100. / fileSize
        if not sendStatusTo == None :
            sendStatusTo.receiveStatus(status);
    downloadedFile.close()

def get_params(string = None):
    param={};
    paramstring=sys.argv[2] if string == None else string;
    if len(paramstring)>=2:
        params=sys.argv[2] if string == None else string;
        cleanedparams=params.replace('?','');
        if (params[len(params)-1]=='/'):
            params=params[0:len(params)-2]
        pairsofparams=cleanedparams.split('&');
        param={};
        for i in range(len(pairsofparams)):
            splitparams={};
            splitparams=pairsofparams[i].split('=');
            if (len(splitparams))==2:
                param[urllib2.unquote(splitparams[0])]=urllib2.unquote(splitparams[1]);
    return param;

def encodeStr(sourceStr):
    i = 0;
    array=[];
    tempStr = "";
    for a in sourceStr:
        j = ord(a);
        k = i % 4;
        if k == 0:
            j += 1;
        elif k == 1:
            j -= 1;
        elif k == 2:
            j += 2;
        else:
            j -= 2;
        array.append(chr(j));
        i+=1;
    array.reverse();
    for a in array:
        tempStr += a;

    strLen= len(tempStr);
    half = int(strLen / 2);
    retHalf1 = tempStr[0:half];
    retHalf2 = tempStr[half:]
    retStr = chr(random.randint(35, 122)) + retHalf1 + chr(random.randint(35, 122)) + chr(random.randint(35, 122)) + retHalf2 + chr(random.randint(35, 122));
    return retStr;

def decodeStr(sourceString):
    tempStr = sourceString[1: len(sourceString)-1];
    strLen= len(tempStr) - 2;
    sourceString= tempStr[0:int(strLen / 2)] + tempStr[int(strLen / 2) + 2:];
    i = 0;
    retStr="";
    array=[];
    for c in sourceString:
        array.append(c);
    array.reverse();

    for a in array:
        j = ord(a);
        k = i % 4;
        if k == 0:
            j -= 1;
        elif k == 1:
            j += 1;
        elif k == 2:
            j -= 2;
        else:
            j += 2;
        retStr += chr(j);
        i+=1;
    return retStr;

def isFileExecutableByOwner(path):
    cmd = "ls -l " + path;
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();
    
    if output and output[3] == "x":
        return True;
    else:
        return False;
    
def addExecPermissions(path, recursive = False):
    cmd = "chmod " + ("-R " if recursive else "") + "+x " + path;
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();

def escapeCharsForShell(string):
    """Method escapes special characters in string to be used in linux shell."""    
    tempStr = ""
    
    for a in string:
        for i in range(0, len(shellCharsToBeEscaped)):
            if a == shellCharsToBeEscaped[i]:
                tempStr = tempStr + "\\" + a;
                break;
            if i == (len(shellCharsToBeEscaped) -1):
                tempStr = tempStr + a;
    return tempStr;

def readFileAsString(path):
    with open (path, "r") as f:
        text = f.read();
        return text;
    
def readFileAsStringShell(path):
    cmd = "cat \"" + path + "\"";            
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();
    return output;

def readFileAsStringAndFilterShell(path, searchString, regex = False):
    cmd = "cat \"" + path + "\" | grep " +("-E " if regex else "") +  "\"" +  searchString + "\"";            
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True);
    output, errors = p.communicate();
    return output;

#print(escapeCharsForShell("$'dfsa&%^*"));
#u = "http://python.org/ftp/python/2.7.3/python-2.7.3.msi"
#file ="C:\\t\\test.msi"
#downloadFile(u, file);
