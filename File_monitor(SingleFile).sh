#!/bin/bash
# Version : 1.0
# Author  : M.Sivaprasath
#     To monitor a single file and have backup of previous changes.

FileName=test
PWD=/root
LogPath=/ftp/File_Monit



TIMESTAMP=$(date +"%d-%m-%y_%T")
FilePath=""$PWD"/"$FileName""
TestPath=""$LogPath"/"$FileName""
LogFile=""$LogPath"/"$FileName".log"
[ ! -d "$LogPath" ] && mkdir -p "$LogPath"

function LogAndEcho()
        {
                echo "`date` $@" >> $LogPath
                echo -e "\n`date` $@"
        }

cd "$PWD"
[ ! -f "$TestPath" ] && cp "$FilePath" "$TestPath"

Change=$(diff "$FilePath" "$TestPath")
Test=$(printf "$Change" | wc -l)

if [ ! -f "$FilePath" ] ; then
        LogAndEcho "----------File Removed--------"

    elif [ "$Test" != "0" ]; then
        Change=$(diff "$FilePath" "$TestPath")
        LogAndEcho "$Change"
        cp "$TestPath" "$TestPath"-"$TIMESTAMP"
        rsync "$FilePath" "$TestPath"
fi

exit 0