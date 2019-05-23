#!/bin/sh

# If project created successfully - run this script

# =========================  Check variables are set =================================


boincserverconfig=/home/boincadm/Desktop/BOINC_data/1_SetupProject/setup_variables.conf


if		[ ! -z "$boincserverconfig" ]; then
	. $boincserverconfig
else
	echo "Variable 'boincserverconfig' not set";
	exit 1
fi

if 		[ -z "$dbname" ]; then
	echo "Variable 'dbname' not set";
	exit 1
elif	[ -z "$dbuser" ]; then
	echo "Variable 'dbuser' not set";
	exit 1
elif	[ -z "$dbpasswd" ]; then
	echo "Variable 'dbpasswd' not set";
	exit 1
elif	[ -z "$hosturl" ]; then
	echo "Variable 'hosturl' not set";
	exit 1
elif	[ -z "$projectname" ]; then
	echo "Variable 'projectname' not set";
	exit 1
elif	[ -z "$projectnicename" ]; then
	echo "Variable 'projectnicename' not set";
	exit 1
elif	[ -z "$installroot" ]; then
	echo "Variable 'installroot' not set";
	exit 1
elif	[ -z "$boinc_src" ]; then
	echo "Variable 'boinc_src' not set";
	exit 1
fi



# ========================= Configure project ======================================


if [ ! -d "$installroot"/"$projectname" ]; then 
	echo "Projcet not created. Stop"
	exit 1
fi

if [ -z "$installroot" -o -z "$projectname" ]; then
  	echo "Not all variables are set for the configuration"
  	echo "Error, do not continue."
  	exit 1
elif [ ! -d "$installroot"/"$projectname" ]; then
  	echo "The directory '$installroot/'$projectname' is not existing"
  	echo "Error, do not continue."
  	exit 1
else
	cd "$installroot"/"$projectname"
  	sudo chown boincadm:boincadm  -R .
  	sudo chmod g+w -R .
  	sudo chmod 02770 -R upload html/cache html/inc html/languages html/languages/compiled html/user_profile
  	hostname=`hostname`
  	if [ -z "$hostname" ]; then 
		echo "Please specify the hostname"
    	exit 1
  	else
		if [ -d log_"$hostname" ]; then 
    		sudo chgrp -R www-data log_"$hostname" upload
		fi
  	fi

	if [ -d html/inc -a -d cgi-bin ]; then
	  	echo -n "html/inc: "; sudo chmod o+x html/inc && sudo chmod -R o+r html/inc && echo "[ok]" || echo "[failed]"
	  	echo -n "html/languages: "; sudo chmod o+x html/languages/ html/languages/compiled && echo "[ok]" || echo "[failed]"
	else
	  	echo "You are not in your project directory"
	  	exit 1
	fi
fi


(sudo crontab -l ; echo "0,5,10,15,20,25,30,35,40,45,50,55 * * * * cd "$installroot"/"$projectname" ; "$installroot"/"$projectname"/bin/start --cron") 2>&1 | grep -v "no crontab" | sort | uniq | crontab -


cd "$installroot"/"$projectname"
sudo "$installroot"/"$projectname"/bin/xadd

echo "Enter password for ""$projectname"" options"
htpasswd -c "$installroot"/"$projectname"/html/ops/.htpasswd $dbuser


if [ -f ""$installroot"/"$projectname"/"$projectname".httpd.conf" -a ! -z "$installroot" -a ! -z "$projectname" ]; then
  	sudo ln -s -f "$installroot"/"$projectname"/"$projectname".httpd.conf /etc/apache2/sites-enabled
else 
	echo "File '"$installroot"/"$projectname"/"$projectname".httpd.conf' not exists or varables not set"
	exit 1
fi


cd /etc/apache2/mods-enabled
sudo ln -s -f ../mods-available/php5.* .
sudo ln -s -f ../mods-available/cgi.* .
sudo service apache2 restart

cd "$installroot"/"$projectname"
sudo ./bin/start

xdg-open "$hosturl"/"$projectname"/



