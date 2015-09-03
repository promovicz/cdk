#!/bin/sh

#
# Description:
#		This demonstrates the CDK command line
# interface to the radio widget.
#

#
# Create some global variables.
#
CDK_RADIO="../cdkradio"
CDK_LABEL="../cdklabel"
fileSystemList="/tmp/fsList.$$"
diskInfo="/tmp/diskInfo.$$"
output="/tmp/radio_output.$$"
tmp="/tmp/tmp.$$"

#
# Get the filesystem information.
#
getDiskInfo()
{
   fileName=$1;
   command="df"

   #
   # Determine the type of operating system.
   #
   machine=`uname -s`
   if [ "$machine" = "SunOS" ]; then
      level=`uname -r`

      if [ "$level" -gt 4 ]; then
         command="df -kl"
      fi
   else
      if [ "$machine" = "AIX" ]; then
         command="df -i"
      fi
   fi

   #
   # Run the command.
   #
   ${command} > ${fileName}
}

#
# Create the title for the scrolling list.
#
title="<C>Pick a filesystem to view."
buttons=" OK 
 Cancel "

#
# Get a list of the local filesystems.
#
getDiskInfo ${diskInfo}

#
# Create the file system list.
#
grep "^/" ${diskInfo} | awk '{printf "%s\n", $1}' > ${fileSystemList}

#
# Create the radio list.
#
${CDK_RADIO} -T "${title}" -f "${fileSystemList}" -c "</U>*" -B "${buttons}" 2> $output
selected=$?
if [ $selected -lt 0 ]; then
   exit;
fi

#
# The selection is now in the file $output.
#
fs=`cat ${output}`
echo "<C></R>File Statistics on the filesystem ${fs}" > ${tmp}
echo " " >> ${tmp}
grep "${fs}" ${diskInfo} | awk '{printf "</B>%s\n", $0}' >> ${tmp}
echo " " >> ${tmp}
echo "<C>You chose button #${selected}" >> ${tmp}
echo " " >> ${tmp}
echo "<C>Hit </R>space<!R> to continue." >> ${tmp}

#
# Create the label widget to display the information.
#
${CDK_LABEL} -f ${tmp} -p " "

#
# Clean up.
#
rm -f ${tmp} ${output} ${fileSystemList} ${diskInfo}
