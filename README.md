# FileMonitoring
To monitor changes in file/files of a directory/directories 


# To check php file changes till date

`find /ftp/FileMonitor/BackUp/ -name *.php-*-*-*_*`
`find /ftp/FileMonitor/LOG/ -name *.*.log`


# To check List of files changes today
`Today=`date "+%d-%m-%y"` && find /ftp/FileMonitor/BackUp/ -name *.php-"$Today"_*`
