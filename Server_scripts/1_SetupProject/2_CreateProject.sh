#!/bin/sh

# Run this scrypt to create a project

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

# =========================== Clean database and project body =============================

if   [ -z "$dbuser" ]; then echo "Variable 'dbuser' not set";
elif [ -z "$dbname" ]; then echo "Variable 'dbname' not set";
elif [ -z "$dbpasswd" ]; then echo "Variable 'dbpasswd' not set";
else
   cat <<EOMYSQL | mysql -u root -p;
USE mysql;

DROP USER IF EXISTS '$dbuser'@'localhost';
DROP DATABASE IF EXISTS $dbname;

CREATE USER '$dbuser'@'localhost' IDENTIFIED BY '$dbpasswd';
UPDATE user SET plugin='mysql_native_password' WHERE User='$dbuser';
GRANT ALL PRIVILEGES ON $dbname.* TO '$dbuser'@'localhost';

FLUSH PRIVILEGES;

EOMYSQL
fi


if   [ -z "$installroot" ]; then echo "Variable 'installroot' not set";
elif [ -z "$projectname" ]; then echo "Variable 'projectname' not set";
elif [ ! -d "$installroot"/"$projectname""/bin" ]; then :;
elif [ ! -f "$installroot"/"$projectname""/bin/rm" ]; then :;
else
  sudo "$installroot""$projectname""/bin/rm" -rf "$projectname"
fi


# =========================== Create project ========================================


echo -n "Basic configuration test: "
if [ -z "$installroot" -o -z "$hosturl" -o -z "$dbname" -o -z "$dbpasswd" \
-o -z "$projectnicename" -o -z "$projectname" -o -z "$dbuser" -o -z "$boinc_src" ] ; then
 echo "Missing configuration parameter."
 exit 1
else
 echo "[ok]"
fi


sudo "$boinc_src"tools/make_project \
  --url_base "$hosturl" \
  --db_name "$dbname" \
  --db_user "$dbuser" \
  --db_passwd "$dbpasswd" \
  --delete_prev_inst \
  --project_root "$installroot"/"$projectname" \
  --srcdir "$boinc_src" \
   "$projectname" "$projectnicename"
   

