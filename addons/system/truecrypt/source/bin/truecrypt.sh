#!/bin/sh

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

# In case on modification to the script please redirect command output to stderr (>&2)
# otherwise you risk mallfunction of certain features of the python part.

ADDON_DIR="$HOME/.xbmc/addons/plugin.program.truecrypt"
ADDON_HOME="$HOME/.xbmc/userdata/addon_data/plugin.program.truecrypt"

# Function adds addon exec directory to the PATH if necessary. This method is
# run at start up of XBMC
addToPath(){
	echo $PATH | grep -q $ADDON_DIR/bin
	if [ "$?" != "0" ]; then
		echo "Adding addon bin dir to PATH." >&2
		export PATH="$PATH:$ADDON_DIR/bin"
	fi
}


# The function will return tc_aux_mnt created after truecrypt attempt to mount a device
# by searching in used loop devices. Argument has to be tc file or a mount point and
# optional loop device.
getTcAuxMnt() {
	local arg="$1"		
	local loopDevice=""
	if [ "$2" == "" ]; then
		loopDevice=$(getLoopDev "$arg")
		
		if [ "$?" != "0" ]; then
			echo "Loop device not found." >&2
			return 1
		fi
	else
		loopDevice="$2"
	fi

	local escapedLoopDev=$(escapePathforAwk "$loopDevice")
	
	local tc_mnt=$(losetup -a | awk "/$escapedLoopDev/"'{print substr($3, 2, length($3)-2)}')	
	echo -n $tc_mnt
	
	if [ "$tc_mnt" != "" ]; then
		return 0
	else
		return 1
	fi

}
# Function returns loop device associated with trucrypt mounted file or mount point
getLoopDev() {
	local arg=$(checkForLink "$1") 
	arg=$(escapePathforAwk "$arg")

	local loop_dev=$(truecrypt -l | awk "/$arg/ "'{
	for (i=1; i <= NF; i++){
		if ( $i  ~ /\/dev\/loop/ )
			print $i
	}}')
	
	if [ "$loop_dev" != "" ]; then
		echo -n "$loop_dev"
		return 0
	else
		echo "Failed to find loop device used - $loop_dev" >&2
		return 1
	fi
}

# Function returns escaped path to a file for use in awk. All '/' are escaped as '\/' .
escapePathforAwk() {

	echo "$1" | awk -v path="" '{
		for (i=0; ++i <= length($0);) {
			letter=substr($0, i, 1)
			if(letter == "/" ) {
				letter="\\" letter
			} 
			if(letter == " "){
				letter="[[:space:]]"
			}
			path=path letter
		}
		print path
	  }'

}

# function checks for symbolic or hard links. It will return path to the targer file
# or or the same file if link is not found.
checkForLink() {
	local arg="$1"

	linkTest=$(readlink -f -s "$arg") >&2
	if [ "${linkTest}" != "" ]; then
		arg="$linkTest"
	fi
	echo -n "$arg"
}

# Removes trailing / if needed, otherwise returns the same string.
removeTrailingSlash() {
	local arg="$1"
	if [ "${arg#${arg%?}}" == "/" ]; then
		echo "Drive name ends in /. Removing last character." >&2
		arg="${arg%?}"
	fi
	echo -n "$arg"	
}

# Function checks supplied path for links and trailing '/'. It returns 
# corrected path if needed
checkFolderPath() {
	local arg=$(checkForLink "$1")
	arg=$(removeTrailingSlash "$arg")
	echo -n "$arg"
}

# Function will print all mounted TC volumes / files
getMountedFiles() {
	# local listing=$(truecrypt -l) 2>/dev/null
	# if [ "$listing" == "" ]; then
		# return
	# fi
	# echo "$listing" | awk -F"([']?[[:space:]][']?)" '{print $2}'
	
	truecrypt -l 2>/dev/null | awk -F"([']?[[:space:]][']?)" '{print $2}' 2>/dev/null
}

# Function will print all partitions on the system. Devices with following format are retruned: 
# sdXY and hdXY.
# It won't return whole disk like sda or hda. 
getPartitions() {
	ls /dev 2>/dev/null | awk "/sd[a-z]?[0-9]+$|hd[a-z]?[0-9]+$/"'{print $1}' 2>/dev/null
}

# Function returns corespnding label to the partition. Only name of the partition should be supplied e.g. sda1
getPartitionLabel() {
	if [ "$1" != "" ] ; then
		ls /dev/disk/by-label -l 2>/dev/null | awk "/$1\$/"'{printf $9}'
		# more "d:\test.txt" | awk "/$1\$/"'{print $9}'
	fi
	
}

# Function will pring mount point associated with the tc volume
getMountPoint() {
	local arg=$(checkForLink "$1")
	arg=$(escapePathforAwk "$arg")
	truecrypt -l 2>/dev/null | awk -F"([']?[[:space:]][']?/?)" "/$arg\>/ "'{print "/" $4}'
		
}

# Function retruns /dev/disk/by-id/... link to the partition
getByIdPath() {
	ids=$(ls /dev/disk/by-id/)
	for id in $ids
	do
		readlink -f "/dev/disk/by-id/$id" | grep -q "$1"
		if [ "$?" == "0" ]; then
			echo -n "/dev/disk/by-id/$id"
			break
		fi
	done
	
}


mountdrive() {
	local tcfile="$1"
	local drive="$2"
	local pass="$3"
	local keyfiles="$4"
	#mkdir -p $drive
	
	# mount tc to the loop device 
	mountspecial "$tcfile" "$drive" "$pass" "$keyfiles"
	
	if [ "$?" != "0" ]; then # check whether previous operation was successfull
		return 1
	fi
	
	# mount file system
	
	mountfs "$tcfile" "$drive"
	
	if [ "$?" != "0" ]; then # check whether previous operation was successfull
		echo "File system mount was unsuccessfull, unmounting tc drive from loop device."
		unmountdrive "$tcfile" "$drive"
		return 1
	fi

	# test if mounted sucessfully
	ismounted "$tcfile" "$drive"
	if [ "$?" == "0" ]; then
		echo "Mounted successfuly." >&2
		return 0
	else
		echo "Mount failed." >&2
		return 1
	fi
}

mountHidden() {
	local tcfile="$1"
	local drive="$2"
	local passOuter="$3"
	local keyFilesOuter="$4"
	local passHidden="$5"
	local keyFilesHidden="$6"
	local additionalOptions="$7"
	#mkdir -p $drive
	
	# mount tc to the loop device 
	mountspecial "$tcfile" "$drive" "$passOuter" "$keyFilesOuter" "$additionalOptions" "yes" "$passHidden" "$keyFilesHidden"
	
	if [ "$?" != "0" ]; then # check whether previous operation was successfull
		return 1
	fi
	
	# mount file system
	
	mountfs "$tcfile" "$drive"
	
	if [ "$?" != "0" ]; then # check whether previous operation was successfull
		echo "File system mount was unsuccessfull, unmounting tc drive from loop device."
		unmountdrive "$tcfile" "$drive"
		return 1
	fi

	# test if mounted sucessfully
	ismounted "$tcfile" "$drive"
	if [ "$?" == "0" ]; then
		echo "Mounted successfuly." >&2
		return 0
	else
		echo "Mount failed." >&2
		return 1
	fi

}

mountspecial() {
	#echo "$@"
	local tcfile=$(checkForLink "$1")
	local drive=$(checkFolderPath "$2")
	local pass="$3"
	local keyfiles="$4"
	local mountoptions=""
	if [ "$5" == "" ]; then
		mountoptions="nokernelcrypto"
	else
		mountoptions="nokernelcrypto,$5"
	fi
	
	losetup -f > /dev/null 2>&1
	
	if [ "$?" != "0" ]; then
		echo "Loop device is not available." >&2
	fi
	
	if [ "$6" == "yes" ]; then
		protectionpass="$7"
		protectionkeyfiles="$8"

		truecrypt --non-interactive --protect-hidden=yes --mount-options="$mountoptions" --filesystem=none -k "$keyfiles" --protection-keyfiles="$protectionkeyfiles" -p "$pass" --protection-password="$protectionpass" "$tcfile" >&2
	else 
		truecrypt --non-interactive --protect-hidden=no --mount-options="$mountoptions" --filesystem=none -k "$keyfiles" -p "$pass" "$tcfile" "$drive" >&2
	fi
	
	tc_exit_value=$?
	
	return $tc_exit_value
}

# It mounts file system to the loop device connected to the truecrypt volume
mountfs() {
	local tcfile="$1"
	local drive="$2"
	local loop_dev=$(getLoopDev "$tcfile")
	
	mount -t auto "$loop_dev" "$drive" >&2
	rv=$?
	
	if [ "$rv" == "0" ]; then # check whether previous operation was successfull
		return 0
	fi
	
	ntfs-3g "$loop_dev" "$drive" >&2
	rv=$?
	if [ "$rv" != "0" ]; then # check whether previous operation was successfull
		echo "Mounting file system failed" 
		return 0
	fi
}

# The function will unmount file system connected to the tc drive.
# Usefull when formatting or manipulating or creating hidden volumes.
umountfs() {
	local drive=$(checkFolderPath "$1")
	local loop_dev=$(getLoopDev "$drive")
	
	ev=$?	
	if [ "$ev" != "0" ]; then
		echo "Unable to find loop device. Therefore; not proceeding with file system umount." >&2
		return 1
	fi
	
	tc_aux_mnt=$(getTcAuxMnt "$drive" "$loop_dev")
	umount "$drive" >&2
	ev=$?	
	if [ "$ev" != "0" ]; then 
		return 1
	fi

	losetup "${loop_dev}" "${tc_aux_mnt}" >&2
	ev=$?
	if [ "$ev" != "0" ]; then 
		echo "Failed to set up loop device. " >&2
		return 1
	else
		return 0
	fi
}


unmountdrive() {

	local tcfile=$(checkForLink "$1")
	local drive=$(checkFolderPath "$2")	
	
	truecrypt --non-interactive -d "$tcfile" "$drive" >&2
	ev=$?
	if [ "$?" != "0" ]; then
	
		local loop_dev=$(getLoopDev "$tcfile")
		local tc_aux_mnt=$(getTcAuxMnt "$drive" "$loop_dev")
		
		truecrypt --non-interactive -d --force "$tcfile" "$drive" >&2
		umount "$drive" >&2
		losetup -d "$loop_dev" >&2
		umount "$tc_aux_mnt" >&2
		ismounted "$tcfile" "$drive"
		if [ "$?" == "0" ]; then
			echo "Failed to unmount drive."
			return 1
		fi
	fi
	echo "Unmount successful."
	return 0
	
}

ismounted(){
	local tcfile=$(checkForLink "$1")
	local drive=$(checkFolderPath "$2")
	
	# check if tc file was supplied, if not then act as if it was not mounted, thus can return mount in use if needed
	if [ "$tcfile" != "" ]; then
		truecrypt -l | grep -q "$tcfile" >&2
		rv1=$?
	else
		rv1=1
	fi
	
	if [ "$drive" != "" ]; then      # in case second argument was not supplied
		mount | grep -q "$drive" >&2
		rv2=$?
	fi

	if [ "$rv1" == "0" ] && [ "$rv2" == "0" ]; then
		#echo "Truecrypt drive is mounted." >&2
		return 0
	elif [ "$rv1" == "1" ] && [ "$rv2" == "0" ]; then
		#echo "Mountpoint is being used by other file or process." >&2
		return 2
	elif [ "$rv1" == "0" ] && [ "$rv2" == "" ]; then
		#echo "Truecrypt drive is mounted." >&2
		return 0
	else
		#echo "Truecrypt drive is not mounted." >&2
		return 1
	fi
}

# a prerequisite: drive has to be mounted
formatdrive() {
	local tcfile=$(checkForLink "$1")
	local drive=$(checkFolderPath "$2")
	local filesys="$4"
	
	# look for needed variables
	local loop_dev=$(getLoopDev "$tcfile")		
	if [ "$?" != "0" ]; then
		echo "Failed to find associated loop device. Not proceeding with formatting." >&2
		return 1
	fi
	
	# unmounting file system
	umountfs "$drive"
	if [ "$?" != "0" ]; then
		echo "Failed to unmount file system. Not proceeding with formatting." >&2
		return 1
	fi
	
	format "$loop_dev" "$filesys"
	rv=$?
	
	unmountdrive "$tcfile" "$drive"

	if [ "$rv" != "0" ]; then
		echo "Failed to format drive."
		return 1
	else 
		echo "Drive formatted successfully."
		return 0
	fi
}

# Function performs actual formatting of tc device. File system has to be unmounted
# before it is used. Used loop device and file system has to be provided.
format() {
	loop_dev="$1"
	filesys="$2"
	
	echo "Formatting..." >&2
	if [ "$filesys" == "FAT32" ]; then
		mkdosfs "$loop_dev" >&2
	elif [ "$filesys" == "NTFS" ]; then
		mkntfs "$loop_dev" >&2
	else
		"mkfs.$2" "$loop_dev" >&2
	fi
	rv=$?
	
	sleep 5
	return $rv
}

mkcontainer() {
	local tcfile="$1"
	local drive="$2"
	local pass="--password=${3}"
	local SIZE="$4" # in bytes
	local keyfiles="$5"
	if [ "$6" != "" ]; then
		ENTROPY="$6"
	else
		ENTROPY="/dev/urandom"
	fi
	
	if [ "$7" == "none" ]; then
		filesys="none"
	else 
		filesys="FAT"
	fi
	
	if [ "$8" == "hidden" ]; then
		type="hidden"
	else
		type="normal"
	fi
	
	mkdir -p "$drive"
		
	ismounted "" "$drive"
	if [ "$?" == "2" ]; then   # mount point is in use
		echo "Executing unmouning of the drive by truecrypt as mount point is in use." >&2
		truecrypt -t -d "$drive" >&2
	fi
	
	echo "Executing creation of the container." >&2
	truecrypt -t --create --non-interactive --keyfiles="$keyfiles" --protect-hidden=no --volume-type="$type" --size="$SIZE" --encryption=AES --hash=SHA-512 --filesystem="$filesys" --random-source="$ENTROPY" "$pass" "$tcfile" >&2 
	
	if [ "$?" != "0" ]; then
		echo "Container creation failed." >&2
		echo $tcfile >&2
		return 1
	else
		echo "Container created successfully." >&2
		return 0
	fi
}

createHiddenVolume() {
    # set up needed variables
    local tcfile="$1"
    local drive="$2"
    local passOuter="$3"
    local keyFilesOuter="$4"
    local sizeOuter="$5"
    local passHidden="$6"
    local keyFilesHidden="$7"
    local sizeHidden="$8"
    local fileSystem="$9"
	local randomNumberGenerator="$10"
	
	if [ "$randomNumberGenerator" == "" ]; then
		randomNumberGenerator="/dev/random"
	fi
	
   
    # creation of outer volume without file system
    mkcontainer "$tcfile" "$drive" "$passOuter" "$sizeOuter" "$keyFilesOuter" "$randomNumberGenerator" "none"
    if [ "$?" != "0" ]; then
        echo "Failed to create outer volume." >&2
        return 1
    fi
	
	#  mountspecial "$tcfile" "$drive" "$passOuter" "$keyFilesOuter"
   
    # creation of hidden volume
    mkcontainer "$tcfile" "$drive" "$passHidden" "$sizeHidden" "$keyFilesHidden" "$randomNumberGenerator" "none" "hidden"
    if [ "$?" != "0" ]; then
        echo "Failed to create hidden volume." >&2
        return 1
    fi
   
    # mounting of outer volume with hidden volume protection without mounting file system
    mountspecial "$tcfile" "$drive" "$passOuter" "$keyFilesOuter" "" "yes" "$passHidden" "$keyFilesHidden"
    if [ "$?" != "0" ]; then
        echo "Failed to mount outer volume." >&2
        return 1
    fi
   
    local loopDev=$(getLoopDev "$tcfile")
   
    # creation of file system on the outer volume
    format "$loopDev" "$fileSystem"
    if [ "$?" != "0" ]; then
        echo "Failed to create file system ($fileSystem) for the outer volume on $loopDev" >&2
        return 1
    fi
   
    # test mount of newly created FS
    mountfs "$tcfile" "$drive"
    if [ "$?" != "0" ]; then
        echo "Failed to mount file system of outer volume after formatting." >&2
        return 1
    fi
   
    # umounting outer volume
    unmountdrive "$tcfile" "$drive"
    if [ "$?" != "0" ]; then
        echo "Failed to umount outer volume." >&2
        return 1
    fi
   
    # mouting hidden volume
    mountspecial "$tcfile" "$drive" "$passHidden" "$keyFilesHidden"
    if [ "$?" != "0" ]; then
        echo "Failed to mount hidden volume." >&2
        return 1
    fi
   
    loopDev=$(getLoopDev "$tcfile")
   
    # creation of file system on the hidden volume
    format "$loopDev" "$fileSystem"
    if [ "$?" != "0" ]; then
        echo "Failed to create file system ($fileSystem) for the outer volume on $loopDev" >&2
        return 1
    fi
   
    # test mount of newly created FS
    mountfs "$tcfile" "$drive"
    if [ "$?" != "0" ]; then
        echo "Failed to mount file system of outer volume after formatting." >&2
        return 1
    fi
   
    # umounting hidden volume
    unmountdrive "$tcfile" "$drive"
    if [ "$?" != "0" ]; then
        echo "Failed to umount hidden volume." >&2
        return 1
    fi
   
    # successful end :)
    echo "" >&2
    echo "Warning: To copy files to the outer volume, mount it with hidden volume protection." >&2
    echo "Not doing so might result in destroying the hidden volume." >&2
    return 0

}

changepassword(){
	tcfile="$1"
	oldpass="$2"
	newpass="$3"
	keyfiles="$4"

	echo "Executing truecrypt password change." >&2
	truecrypt -t \
	-C \
	--non-interactive \
	--password="${oldpass}" \
	--new-password="${newpass}" \
	--keyfiles="$keyfiles" \
	--new-keyfiles="$keyfiles" \
	"$tcfile" >&2
	  
if [ "$?" != "0" ]; then
		echo "Password change failed." >&2
		return 1
	else
		echo "Password changed successfully." >&2
		return 0
	fi

}

changekeyfiles(){
	tcfile="$1"
	password="$2"
	oldkeyfiles="$3"
	newkeyfiles="$4"

	echo "Executing truecrypt change of key file(s)." >&2
	truecrypt -t \
	-C \
	--non-interactive \
	--keyfiles="$oldkeyfiles" \
	--new-keyfiles="$newkeyfiles" \
	--password="$password" \
	--new-password="$password" \
	"$tcfile" >&2
	  
if [ "$?" != "0" ]; then
		echo "Change of key file(s) failed." >&2
		return 1
	else
		"Key file(s) changed successfully." >&2
		return 0
	fi

}

createkeyfile(){
	keyfile="$1"
		
	if [ "$keyfile" == "" ]; then
		echo "No file specified." >&2
		return 2
	fi
	
	if [ "$2" != "" ]; then
		ENTROPY="$2"
	else
		ENTROPY="/dev/urandom"
	fi
	
	echo "Creating key file. Source of random data: $ENTROPY" >&2
	truecrypt --non-interactive --create-keyfile --random-source="$ENTROPY" "$keyfile" >&2
	
	return $?	
}

showinfo() {
	echo "This script is primarily meant to be excecuted by an addon"
	echo "from OpenElec's XBMC interface (plugin.program.truecrypt)."
	echo
	echo "Usage:" 
	echo "mount TRUECRYPT_FILE/PARTION MOUNT_POINT PASSWORD [KEY_FILES]"
	echo "dismount TRUECRYPT_FILE/PARTION MOUNT_POINT [TC_AUX_MNT]"
	echo "ismounted TRUECRYPT_FILE/PARTION MOUNT_POINT"
	echo "changepass TRUECRYPT_FILE/PARTION OLD_PASS NEW_PASS [KEY_FILES]"
	echo "create TRUECRYPT_FILE/PARTION MOUNT_POINT PASSWORD SIZE_IN_GB [KEY_FILES RANDOM_DATA_GENERATOR]"
	echo "changekeyfiles TRUECRYPT_FILE/PARTION PASSWORD CURRENT_KEY_FILE(S) NEW_KEY_FILE(S)"
	echo "addkeyfiles TRUECRYPT_FILE/PARTION PASSWORD NEW_KEY_FILE(S)"
	echo "removekeyfiles TRUECRYPT_FILE/PARTION PASSWORD CURRENT_KEY_FILE(S)"
	echo "createkey KEY_FILE [RANDOM_DATA_GENERATOR]"
	echo "format TRUECRYPT_FILE/PARTION MOUNT_POINT TC_AUX_MNT FILE_SYSTEM"
	echo 
	echo "Option \"format\" requires to have drive mounted first."
}


case "$1" in
	mount) mountdrive "$2" "$3" "$4" "$5"
		rv=$?
		;;
	mountHidden) mountHidden "$2" "$3" "$4" "$5" "$6" "$7" "$8"
		;;
	dismount) unmountdrive "$2" "$3" "$4"
		;;
	ismounted) ismounted "$2" "$3"
		rv=$?
		echo "EV:$rv"
		;;
	create) mkcontainer "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9"
		rv=$?
		;;
	format) formatdrive "$2" "$3" "$4" "$5"
		rv=$?
		echo "EV:$rv"
		;;
	changepass) changepassword "$2" "$3" "$4" "$5"
		rv=$?
		echo "EV:$rv"
		;;
	createkey) createkeyfile "$2" "$3"
		rv=$?
		echo "EV:$rv"
		;;
	changekeyfiles)	changekeyfiles "$2" "$3" "$4" "$5"
		rv=$?
		echo "EV:$rv"
		;;
	addkeyfiles)	changekeyfiles "$2" "$3" "" "$4"
		rv=$?
		echo "EV:$rv"
		;;
	removekeyfiles)	changekeyfiles "$2" "$3" "$4" ""
		rv=$?
		echo "EV:$rv"
		;;
	ms) mountspecial "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9"
		rv=$?
		echo "EV:$rv"
		;;
	gld) getLoopDev "$2"
		;;
	mfs) mountfs "$2" "$3"
		;;
	umfs) umountfs "$2"
		;;
	gtam) getTcAuxMnt "$2"
		;;
	chckfp) checkFolderPath "$2"
		;;
	epawk) escapePathforAwk "$2"
		;;
	f) format "$2" "$3"
		;;
	chv) createHiddenVolume "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" "$10" "$11"
		ev=$?
		echo "EV:$rv"
		;;
	gmf) getMountedFiles
		;;
	gmp) getMountPoint "$2"
		;;
	gp) getPartitions
		;;
	gpl) getPartitionLabel "$2"
		;;
	path) addToPath
		;;
	by-id) getByIdPath "$2"
		;;
	chlink) checkForLink "$2"
		;;
	*) showinfo
		rv=0
		;;
esac

exit $rv
