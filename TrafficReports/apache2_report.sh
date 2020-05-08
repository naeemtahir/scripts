#!/bin/sh

# Apache2 acccess log format (https://httpd.apache.org/docs/2.2/logs.html)
#
# access.log/ssl_access.log
# -------------------------
#   host inetdid user  [date:time tz] "request_line" response_code content_length referer user_agent

if [ "$#" -eq 2 ] && [ -d "$1" ] && [ -d "$2" ]; then
    LOG_DIR=$1
    REPORT_DIR=$2
    REPORT=$REPORT_DIR/apache_$(date +"%Y.%m.%d_%H.%M.%S").csv
    HEADER="Date,Time,Host,UserId,Request,Code"

	echo $HEADER > $REPORT
    zcat -f $LOG_DIR/access.log* | awk '{ split($4, t, ":"); printf "%s,%s:%s:%s,%s,%s,%s %s %s,%s\n", substr(t[1],2), t[2], t[3], t[4], $1, $3, $6, $7, $8, $9}' | sort -t"," -k1.8,1.11 -k1.4,1.6M -k1.1,1.2n -k2 >> $REPORT
else
    script_name=`basename "$0"`
    echo "Usage: $script_name <log_dir> <report_dir>"
    exit 1
fi

# Configure this as Cronjob, e.g., at 1:15 AM every Friday.
# 15 1 * * 5 $HOME/bin/apache2_report.sh /var/log/apache2 /media/homesrv/reports
