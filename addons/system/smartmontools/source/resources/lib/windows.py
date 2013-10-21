'''
Created on 24.9.2013

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


import xbmcgui  # @UnresolvedImport


class basicTextWindow(xbmcgui.WindowXMLDialog):

    def __init__(self, *args, **kwargs):
        self.ACTION_PREVIOUS_MENU = 10;
        self.text = "";
        self.header = "";
    
    
    def setText(self, text):
        self.text = text;
        
    def setHeader(self, header):
        self.header = header;

    def setHeaderAndText(self, header, text):
        self.setHeader(header);
        self.setText(text);
    
    def onInit(self):
        headerLabel = self.getControl(1);
        headerLabel.setLabel(self.header);
        textBox = self.getControl(5);  
        textBox.setText(self.text);          

    def onAction(self, action):        
        if action == self.ACTION_PREVIOUS_MENU or action == 92 or action == 9:
            self.close();


    def onClick(self, controlID):
        pass;

    def onUnload(self):
        pass
        
    def onFocus(self, controlID):
        pass;
        