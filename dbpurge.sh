#!/bin/sh
##################################################################

# dbpurge by Jeff Johnston <jj358mhz@gmail.com>
# Allows schedule purge (delete) from your Dropbox app
# THIS FILE: /usr/local/bin/dbpurge
# No Warranty is implied, promised or permitted.

##################################################################
# File Locations for Raspberry Pi (Debian based)

# /usr/local/bin/dbpurge.sh     (this file)
# /etc/dbpurge/dbpurge.conf     (configuration file)

# Create this folder if it does not exist:
# /etc/dbpurge

##################################################################

# Add the following line to root's crontab (via sudo crontab -e):
#       xx * * * *   [ -x /usr/local/bin/dbpurge.sh ] && /usr/local/bin/dbpurge.sh cron > /dev/null
# This will purge an archive xx minutes after the top of every hour. You can update to suit your needs.

###################  >>> ENJOY !    ################################

set -x

# PATH added in case it is not set when cron runs @reboot
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:

# Make config changes to the following file...
CONFIGFILE=/etc/dbpurge/dbpurge.conf

# Check and load the conf file
[ -f "$CONFIGFILE" ] && . $CONFIGFILE

# Calculates the number of DAYS (from dbpurge.conf) * 24, 1hr recordings
FILE_COUNT=$(($DAYS \* 24))

# Dropbox purge

REMOTE_COUNT=`$DBSCRIPT list | wc -l`

if `[ $REMOTE_COUNT -gt $FILE_COUNT ]`; then
    DBFILE_PURGE=`$DBSCRIPT list | gawk 'NR==2{print $3}'`
    [ $USEDROPBOX = "yes" ] && sudo -u pi $DBSCRIPT delete /"$DBFILE_PURGE"
    echo "A file was purged"
else
    echo "A file was not purged"
fi

exit 0

