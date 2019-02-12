#!/bin/bash
# Version : 1.0
# Author  : M.Sivaprasath
#     To monitor a all file in a current directory and have backup of previous changes.
PWD=/root/File_monit
LogPath=/ftp/File_Monit

LS=$(ls -p "$PWD"  | grep -v '/' | tr [:space:] '\n')
[ ! -d "$LogPath" ] && mkdir -p "$LogPath"
[ ! -f ""$LogPath"/AvailableFiles" ] && touch "$LogPath"/AvailableFiles
echo "$LS" > ""$LogPath"/AvailableFiles"
for word in $LS ; do
FileName="$word"
TIMESTAMP=$(date +"%d-%m-%y_%T")
FilePath=""$PWD"/"$FileName""
TestPath=""$LogPath"/"$FileName""
LogFile=""$LogPath"/"$FileName".log"

function LogAndEcho()
        {
                echo "`date` $@" >> $LogFile
                echo -e "\n`date` $@"
        }



[ ! -f "$TestPath" ] && cp "$FilePath" "$TestPath"


Change=$(diff "$FilePath" "$TestPath")
Test=$(printf "$Change" | wc -l)

if [ "$Test" != "0" ]; then
        Change=$(diff "$FilePath" "$TestPath")
        LogAndEcho "$Change"
        cp "$TestPath" "$TestPath"-"$TIMESTAMP"
        rsync "$FilePath" "$TestPath"
fi
done
[ ! -f ""$LogPath"/.Files"  ] && cp ""$LogPath"/AvailableFiles" ""$LogPath"/.Files" 
Remove=$(diff ""$LogPath"/AvailableFiles" ""$LogPath"/.Files" | awk -F ">" '{print $2}')
Removed=$(printf "$Remove" | wc -l)
if [ "$Removed" != "0" ]; then
echo ""$TIMESTAMP" "$Remove" ---File Removed" >> ""$LogPath"/RemovedFiles"
fi
echo "$LS" > ""$LogPath"/.Files"
exit 0