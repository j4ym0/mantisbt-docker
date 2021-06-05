#!/bin/bash

printf "Checking for config_inc.php...\n"
if [ -f "/config/config_inc.php" ]
then
	 if [ ! -f "/install-run" ]
	 then
  	 printf "Creating tmp install file for first fun\n"
		 touch /install-run
		 printf "!!! ADMIN FOLDER WILL BE REMOVED WHEN CONTAINER IS RESTARTED \n"
	 else
		 chown www-data:www-data /config/config_inc.php
		 printf "  Found\n"
		 printf "Checking for instalation folder...\n"
		 if [ -d "/var/www/html/admin" ]
		 then
		   printf "  Found\n"
		   printf "Atempting to remove admin folder...\n"
		   rm -rf /var/www/html/admin
		   if [ -d "/var/www/html/admin" ]
		   then
  			 printf "  Failed\n"
  		 else
  			 printf "  Removed\n"
  		 fi
  	 else
  		 printf "  Missing - Good\n"
  	 fi
	 fi
else
	touch /install-run
	printf "  Missing persistent config file\n"
	printf "Please use setup /admin/install.php \n"
	printf "!!! ADMIN FOLDER WILL BE REMOVED WHEN CONTAINER IS RESTARTED \n"
fi

printf "\n\n"


exec apache2-foreground
