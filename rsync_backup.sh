#!/bin/bash    
# rsync backup script
# by daniel "lws" nimmervoll

# CHANGE THE SSH PORT AT THE BOTTOM TO THE SSH PORT OF YOUR REMOTE SERVER !! then remove this line (:

DATE=`date +%d_%m_%y`						# date format for the backup timestap
BACKUPDIR=/srv/backups/						# local backup directory path
SITESBDIR=/srv/backups/html 				# local backup directory path for your sites
MYSQLBDIR="/srv/backups/mysql"				# local backup directory path for mysql
REMOTEDIR=/srv/backups_franklin/			# remote backup directory path
REMOTEUSR=root								# remote user name
REMOTESRV=backup.server.com					# remote backup server, use domain or ip
WEBBACKUP=/var/www/html  					# backup path for web files (path to your sites)
DB_USER="root"								# local mysq user name
DB_PASSWD="DATABASEPW"						# local mysql password

# generate backup for you sites and move it to your local backup directory
tar cfvz $SITESBDIR/html_backup_$DATE.tar.gz $WEBBACKUP

# generate mysql backup and move it to your local backup direcoty 
mysqldump --user=$DB_USER --password=$DB_PASSWD --all-databases | bzip2 > $MYSQLBDIR/mysql_$DATE.bz2

# move the backups to the remote server
rsync -avze 'ssh -p PORT' $BACKUPDIR $REMOTEUSR@$REMOTESRV:$REMOTEDIR