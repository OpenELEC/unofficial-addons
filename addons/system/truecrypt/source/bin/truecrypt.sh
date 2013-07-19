#!/bin/ash

################################################################################
#  Copyright (C) Peter Smorada 2013
#  Based on the code created by Stephan Raue (stephan@openelec.tv) and code
#  originally found in http://linux.sparsile.org/2009/09/automated-truecrypt-container-creation.html
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
echo $PATH | grep -q $ADDON_DIR/bin
if [ $? != "0" ]; then
	echo "Adding addon bin dir to PATH." >&2
	export PATH=$PATH:$ADDON_DIR/bin
fi
used_tc_aux_mnt=$(mount | awk '/truecrypt_aux_mnt/ {print $3}')

# The function will return tc_aux_mnt created after truecrypt attempt to mount a device
# by comparing state at the start of the script with the state after calling truecrypt
gettcmnt() {

	for a in $@
	do
		found="1"
		for b in $used_tc_aux_mnt
		do
		  if [ "$b" == "$a" ]; then
				found="0"
			break
			fi
		done
		if [ "$found" = "1" ]; then # if not found in inner loop
			tc_aux_mnt=$a
		break
		fi
	done
	echo "$tc_aux_mnt"
}

# The function will return tc_aux_mnt created after truecrypt attempt to mount a device
# by searching in mounts and used loop devices
getTcauxmntFromMountPoint() {
	drive=$1
		
	loop_dev=$(mount | grep $drive | cut -d" " -f 1)
	echo "Loop device connected to the mount point: $loop_dev" >&2
	tc_mnt=$(losetup -a | grep $loop_dev | awk '/truecrypt_aux_mnt/ {print substr($3, 2, length($3)-9)}')
	echo "Found tc_aux_mnt: $tc_mnt" >&2
	echo $tc_mnt
	
	if [ "$tc_mnt" != "" ]; then
		return 0
	else
		return 1
	fi
}

mountdrive() {
	tcfile=$1
	drive=$2
	pass=$3
	keyfiles=$4
	#mkdir -p $drive
	echo "Used tc_aux_mnt at start: $used_tc_aux_mnt" >&2
	
	echo "Available loop device: " $(losetup -f) >&2
	truecrypt --non-interactive --protect-hidden=no -m=nokernelcrypto -k "$keyfiles" -p "$pass" "$tcfile" "$drive" >&2
	#cmd="truecrypt --non-interactive --protect-hidden=no -m=nokernelcrypto -k \"\" -p\"\$pass\" \"\$tcfile\" \"\$drive\""
	#eval $cmd 1>&2
	
	tc_exit_value=$?
	if [ "$tc_exit_value" != "0" ]; then
		echo "Execution of truecrypt unsuccessfull. Executing it with NTFS option." >&2
		truecrypt --non-interactive --protect-hidden=no -m=nokernelcrypto --filesystem=ntfs-3g -k "$keyfiles" -p "$pass" "$tcfile" "$drive" >&2
		tc_exit_value=$?
	fi
	
	echo "truecrypt return value: $tc_exit_value" >&2
	echo "Mounted loop devices after truecrypt bin being executed:" >&2
	echo $(mount | grep "loop") >&2
	echo "Mounted truecrypt devices after truecrypt bin being executed:" >&2
	echo $(mount | grep "truecrypt") >&2
	
	curr_tc_aux_mnt=$(mount | awk '/truecrypt_aux_mnt/ {print $3}')
	echo "Currently used tc_aux_mnt: $curr_tc_aux_mnt" >&2
	tc_aux_mnt=$(gettcmnt $curr_tc_aux_mnt)
	echo "tc_aux_mnt used by truecrypt: $tc_aux_mnt" >&2

	# test if mounted sucessfully
	ismounted $tcfile $drive
	if [ "$?" == "0" ]; then
		echo "Mounted successfuly directly by truecrypt." >&2
		rv=0
	else
		echo "Mounting by TrueCrypt failed. Remounting within script." >&2
		loop_dev=$(losetup -f)
		echo "Setting up a loop device - $tc_aux_mnt/volume on $loop_dev" >&2
		losetup "$loop_dev" "$tc_aux_mnt/volume" >&2
		echo "Mounting $loop_dev on $drive" >&2
		mount "$loop_dev" "$drive" >&2

		# if previous attempt to mount FS was unsuccessful, it will try to mount it as NTFS drive.
		if [ "$?" != "0" ]; then  
			echo "Mounting was unsuccessful, will try as NTFS drive." >&2
			ntfs-3g "$loop_dev" "$drive" >&2
		fi
	
		ismounted $tcfile $drive
		if [ "$?" == "0" ]; then
			echo "Mounting was successful." >&2
			rv=0
		else
			echo "Mounting was unsuccessful." >&2
			rv=1
		fi
	fi
	# Returning used tc_aux_mnt to the python script for easier unmount or other tasks.
	echo -n "$tc_aux_mnt"
	return $rv
}

unmountdrive() {
	echo "unmounting." >&2
	tcfile=$1
	drive=$2
	
	# check for links and their usage in case they are found
	linkTest=$(readlink -f $drive) >&2
	if [ "${linkTest}" != "" ]; then
		echo "Provided mount point drive is a link. Using real folder instead of link." >&2
		drive=${linkTest}
	fi

	if [ "${drive#${drive%?}}" == "/" ]; then
		echo "Drive name ends in /. Removing last character." >&2
		drive=${drive%?}
	fi

	if [ "$3" == "" ]; then
		echo "tc_aux_mnt was not supplied. Searching for it..." >&2
		tc_aux_mnt=$(getTcauxmntFromMountPoint $drive)
	else
		tc_aux_mnt="${3}"
	fi  

	loop_dev=$(mount | grep ${drive%?} | cut -d" " -f 1)
	echo "Loop device used for mounting: $loop_dev" >&2
  
	echo "Executing truecrypt" >&2
	truecrypt --non-interactive -d "$tcfile" "$drive" >&2

	if grep -qs "$tc_aux_mnt" /proc/mounts; then
  
		echo "Drive is still mounted. Proceeding with manual unmount." >&2
	
		truecrypt --non-interactive -d --force "$tcfile" "$drive" >&2
		umount "$drive" >&2
		losetup -d "$loop_dev" >&2
		umount "$tc_aux_mnt" >&2

		if grep -qs "$tc_aux_mnt" /proc/mounts; then
			rv=0
		else
			rv=1
		fi
	else
		echo "Unmount successfull directly by Truecrypt." >&2
		rv=0
	fi
	return $rv
}

ismounted(){
	tcfile=$1
	drive=$2
  
  # check for links and their usage in case they are found
	linkTest=$(readlink -f $drive) >&2
	if [ "${linkTest}" != "" ]; then
		drive=${linkTest}
	fi
  
	# if drive's named ends in "/" it will be removed
	if [ "${drive#${drive%?}}" == "/" ]; then
		drive=${drive%?}
	fi
	
	truecrypt -l | grep -q "$tcfile" >&2
	rv1=$?
	echo  "Checking if file is mounted in Truecrypt list: ${rv1}" >&2

	mount | grep -q "$drive" >&2
	rv2=$?
	echo "Checking if drive is listed in mounts: ${rv1}" >&2

	if [ "$rv1" == "0" ] && [ "$rv2" == "0" ]; then
		echo "Truecrypt drive is mounted." >&2
		return 0
	elif [ "$rv1" == "1" ] && [ "$rv2" == "0" ]; then
		echo "Mountpoint is being used by other file or process." >&2
		return 2
	else
		echo "Truecrypt drive is not mounted." >&2
		return 1
	fi
}

format() {
	tcfile=$1
	drive=$2
	tc_aux_mnt=$3
	filesys=$4
	
	if [ "${drive#${drive%?}}" == "/" ]; then
		loop_dev=$(mount | grep ${drive%?} | cut -d" " -f 1) # ${drive%?} = string without last character
	else
		loop_dev=$(mount | grep $drive | cut -d" " -f 1)
	fi
	echo "Found loop device: $loop_dev" >&2

	echo "Unmounting drive." >&2
	umount "$drive" >&2
	if [ "$?" != "0" ]; then
		echo "Failed to unmount drive before formating." >&2
		return 1
	fi

	echo "Setting up loop device with tc_aux_mnt" >&2
	losetup "${loop_dev}" "${tc_aux_mnt}/volume" >&2

	echo "Formatting..." >&2
	if [ "$filesys" = "FAT32" ]; then
		mkdosfs "$loop_dev" >&2
	elif [ "$filesys" = "NTFS" ]; then
		mkntfs "$loop_dev" >&2
	else
		"mkfs.$4" "$loop_dev" >&2
	fi
	rv=$?
	sleep 5
	
	echo "Detaching loop device: ${loop_dev}." >&2
	losetup -d "${loop_dev}" >&2
	# umount $drive
	
	echo "Unmounting tc_aux_mnt."
	umount $tc_aux_mnt >&2
	# truecrypt -d $tcfile

	if [ "$rv" != "0" ]; then
		echo "Failed to format drive."
		return 1
	else 
		echo "Drive formatted successfully."
		return 0
	fi
}

mkcontainer() {
	tcfile=${1}
	drive=${2}
	pass="--password=${3}"
	SIZE=${4} # in GB
	filesys=${5}
	keyfiles="$6"
	if [ "$7" != "" ]; then
		ENTROPY=$7
	else
		ENTROPY="/dev/urandom"
	fi
	
	mkdir -p "$drive"
	
	echo "Executing unmouning of the drive by truecrypt." >&2
	truecrypt -t -d "$drive" >&2

	echo "Executing creation of the container." >&2
	truecrypt -t \
	--create \
	--keyfiles="$keyfiles" \
	--protect-hidden=no \
	--volume-type=normal \
	--size=${SIZE} \
	--encryption=AES \
	--hash=SHA-512 \
	--filesystem=FAT \
	--random-source=${ENTROPY} \
	"$pass" \
	"$tcfile" >&2 

	if [ "$?" != "0" ]; then
		echo "Container creation failed." >&2
		return 1
	else
		"Container creation successfully." >&2
		return 0
	fi
}

changepassword(){
	tcfile=$1
	oldpass=$2
	newpass=$3

	echo "Executing truecrypt password change." >&2
	truecrypt -t \
	-C \
	--non-interactive \
	--password="${oldpass}" \
	--new-password="${newpass}" \
	"$tcfile" >&2
  
if [ "$?" != "0" ]; then
		echo "Password change failed." >&2
		return 1
	else
		"Password changed successfully." >&2
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
		ENTROPY=$2
	else
		ENTROPY="/dev/urandom"
	fi
	
	echo "Creating key file. Source of random data: $ENTROPY" >&2
	truecrypt --non-interactive --create-keyfile --random-source=$ENTROPY $keyfile >&2
	
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
	echo "changepass TRUECRYPT_FILE/PARTION OLD_PASS NEW_PASS"
	echo "create TRUECRYPT_FILE/PARTION MOUNT_POINT PASSWORD SIZE_IN_GB [KEY_FILES RANDOM_DATA_GENERATOR]"
	echo "createkey KEY_FILE [RANDOM_DATA_GENERATOR]"
	echo "format TRUECRYPT_FILE/PARTION MOUNT_POINT TC_AUX_MNT FILE_SYSTEM"
	echo 
	echo "Option \"format\" requires to have drive mounted first."
}


case "$1" in
	mount) mountdrive "$2" "$3" "$4" "$5"
		rv=$?
		;;
	dismount) unmountdrive "$2" "$3" "$4"
		;;
	ismounted) ismounted "$2" "$3"
		rv=$?
		echo "EV:$rv"
		;;
	create) mkcontainer "$2" "$3" "$4" "$5" "$6" "$7"
		rv=$?
		;;
	format) format "$2" "$3" "$4" "$5"
		rv=$?
		echo "EV:$rv"
		;;
	changepass) changepassword "$2" "$3" "$4"
		rv=$?
		echo "EV:$rv"
		;;
	createkey) createkeyfile "$2" "$3"
		rv=$?
		echo "EV:$rv"
		;;
	*) showinfo
		rv=0
		;;
esac

exit $rv
