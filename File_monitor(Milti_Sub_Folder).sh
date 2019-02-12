#!/bin/bash
# Version : 1.0
# Author  : M.Sivaprasath
#     To monitor a all file recursively in a directory and have backup of previous changes.

FolderPath1='/var/www/html/Dir1,/var/www/html/Dir2'



function MultiMonit ()

	{
		LogPath=/ftp/FileMonitor/LOG"$FP"

		LS=$(ls -p "$FP"  | grep -v '/' | tr [:space:] '\n')
		
		[ ! -d "$LogPath" ] && mkdir -p "$LogPath"
		[ ! -f ""$LogPath"/AvailableFiles" ] && touch "$LogPath"/AvailableFiles
		

		echo "$LS" > ""$LogPath"/AvailableFiles"
			
		
		for word in $LS ; do
		FileName="$word"
		TIMESTAMP=$(date +"%d-%m-%y_%T")
		FilePath=""$FP"/"$FileName""
		TestPath="/ftp/FileMonitor/BackUp"$FP"/"$FileName""
		LogFile=""$LogPath"/"$FileName".log"

		function LogAndEcho()
		        {
		                echo "`date` $@" >> $LogFile
		                echo -e "\n`date` $@"
		        }

		function ptouch() 
			{
  				for p do
    				_dir="$(dirname -- "$p")"
    				mkdir -p -- "$_dir" &&
      				touch -- "$p"
  				done
			}	

		[ ! -f "$TestPath" ] && ptouch "$TestPath" && cp "$FilePath" "$TestPath"


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
	}

	
FoPa=$(echo "$FolderPath1"  | tr ',' '\n')

for FolDer in $FoPa ; do
	if [ -d "$FolDer" ]; then
	FoP1=$(find "$FolDer" -type d )
		for FP in $FoP1 ; do			
				MultiMonit
		done
	fi
done