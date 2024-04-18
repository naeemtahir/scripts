#!/bin/sh

# DansGuardian acccess log format (http://contentfilter.futuragts.com/wiki/doku.php?id=the_access.log_files)
# date time requesting_user requesting_ip request_url action(s) reason subreason method size weight category filter_group_no http_code mime_type clientname filter_group_name user_agent

if [ "$#" -eq 2 ] && [ -d "$1" ] && [ -d "$2" ]; then
    LOG_DIR=$1
    REPORT_DIR=$2
    REPORT=$REPORT_DIR/dansguardian_$(date +"%Y.%m.%d_%H.%M.%S").csv

    cat $LOG_DIR/access.log* | sort -V | awk 'BEGIN { print "Time,Host,Action,URL" }; { printf "%s %s,%s,%s,%s\n", $1, $2, $4, $6, $5 }' | uniq > $REPORT
else
    script_name=`basename "$0"`
    echo "Usage: $script_name <log_dir> <report_dir>"
    exit 1
fi

# Configure this as Cronjob, e.g., at 2:00 AM every 4th day of month (4,8,12,etc).
# 00 2 */4 * * $HOME/bin/dansguardian_report.sh /var/log/dansguardian /media/homesrv/reports
