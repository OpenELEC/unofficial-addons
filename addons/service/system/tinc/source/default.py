################################################################################
# This file is part of OpenELEC - http://www.openelec.tv
# Copyright (C) 2014-2016 Anton Voyl (awiouy at gmail dot com)
#
# OpenELEC is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# OpenELEC is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with OpenELEC. If not, see <http://www.gnu.org/licenses/>.
################################################################################
import os.path
import random
import socket
import struct
import subprocess
import xbmc
import xbmcaddon

SUBNET = '10.0.0.0/8'

addon = xbmcaddon.Addon()
id = addon.getAddonInfo('id')
path = addon.getAddonInfo('path')
profile = xbmc.translatePath(addon.getAddonInfo('profile'))
config = os.path.join(profile, '.config')
tinc = os.path.join(path, 'bin', 'tinc')

def run_code(command, *argv):
   return subprocess.call(command.format(*argv).split())

def run_lines(command, *argv):
   return subprocess.check_output(command.format(*argv).split()).splitlines()

def setSetting(var, dft):
   try:
      val = run_lines('{} -c {} get {}', tinc, config, var)[0]
      addon.setSetting('tinc_' + var, val)
   except subprocess.CalledProcessError:
      addon.setSetting('tinc_' + var, dft)


class Monitor(xbmc.Monitor):

   def __init__(self, *args, **kwargs):
      xbmc.Monitor.__init__(self)

   def onSettingsChanged(self):
      run_code('systemctl restart {}', id)


if __name__ == '__main__':

   try:
      for network in run_lines('{} network', tinc):
         run_code('{} -n {} start', tinc, network)
   except subprocess.CalledProcessError:
      pass

   if not os.path.isdir(config):
      network, mask = SUBNET.split('/')
      mask = 2 ** (32 - int(mask)) - 1
      network = struct.unpack('!L', socket.inet_aton(network))[0] & -mask
      ip = network + random.randint(1, mask - 1)
      name = format(ip, '08x')
      subnet = socket.inet_ntoa(struct.pack('!L', ip))
      run_code('{} -c {} init {}', tinc, config, name)
      run_code('{} -c {} set Subnet {}', tinc, config, subnet)
      run_code('systemctl start {}', id)

   setSetting('name', 'N/A')
   setSetting('port', '655')
   setSetting('subnet', 'N/A')

   Monitor().waitForAbort()

