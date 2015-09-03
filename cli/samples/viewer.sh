#!/bin/sh

#
# Description:
#		This demonstrates the CDK command line
# interface to the viewer widget.
#

#
# Create some global variables.
#
CDK_FSELECT="../cdkfselect"
CDK_VIEWER="../cdkviewer"
tmp="/tmp/tmp.$$"
file="/tmp/fs.$$"
directory="."
xpos=CENTER
ypos=CENTER
width="-2"
height="0"
interpret=0

#
# Chop up the command line.
#
set -- `getopt d:x:y:w:h:i $*`
if [ $? != 0 ]
then
   echo $USAGE
   exit 2
fi
for c in $*
do
    case $c in
         -d) directory=$2; shift 2;;
         -x) xpos=$2; shift 2;;
         -y) ypos=$2; shift 2;;
         -w) width=$2; shift 2;;
         -h) height=$2; shift 2;;
         -i) interpret=1; shift 1;;
         --) shift; break;;
    esac
done

#
# Create the CDK file selector.
#
${CDK_FSELECT} -T "<C>Select a file" -d "${directory}" 2> ${file}
selected=$?
if [ $selected -lt 0 ]; then
   exit;
fi
answer=`cat ${file}`

#
# Create the title and buttons for the viewer.
#
title="<C>CDK File Viewer Widget
<C></U>${answer}"
buttons="OK"

#
# Create the file viewer.
#
if [ "$interpret" -eq 1 ]; then
   ${CDK_VIEWER} -f "${answer}" -T "${title}" -B "${buttons}" -i -X ${xpos} -Y ${ypos} -H "${height}" -W "${width}"
else
   ${CDK_VIEWER} -f "${answer}" -T "${title}" -B "${buttons}" -X ${xpos} -Y ${ypos} -H "${height}" -W "${width}" -B "${buttons}"
fi

#
# Clean up.
#
rm -f ${tmp} ${file}
