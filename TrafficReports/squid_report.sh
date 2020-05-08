#!/bin/sh

# Squid acccess log format (http://wiki.squid-cache.org/Features/LogFormat)
#
# access.log
# -------------------------
#   time elapsed remotehost code/status bytes method URL rfc931 peerstatus/peerhost type
#     1     2        3          4         5     6     7    8             9          10

if [ "$#" -eq 2 ] && [ -d "$1" ] && [ -d "$2" ]; then
    LOG_DIR=$1
    REPORT_DIR=$2
    REPORT=$REPORT_DIR/squid_$(date +"%Y.%m.%d_%H.%M.%S").csv
    HEADER="Time,Host,MIME Type,Method,Status,URL"
	
    echo $HEADER > $REPORT
    zcat -f $LOG_DIR/access.log* | awk '{ printf "%s,%s,%s,%s,%s,%s\n", strftime("%Y.%m.%d %H:%M:%S", $1), $3, $10, $6, $4, $7}' | sort -g | uniq >> $REPORT
else
    script_name=`basename "$0"`
    echo "Usage: $script_name <log_dir> <report_dir>"
    exit 1
fi

# Configure this as Cronjob, e.g., at 1:45 AM every 4th day of month (4,8,12,etc).
# 45 1 */4 * * $HOME/bin/squid_report.sh /var/log/squid /media/homesrv/reports
