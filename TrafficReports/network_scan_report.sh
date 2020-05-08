#!/bin/sh

if [ "$#" -eq 2 ] && [ -d "$2" ]; then
    IP_RANGE=$1
    REPORT_DIR=$2	
    REPORT=$REPORT_DIR/network_scan_report_$(date +"%Y.%m.%d_%H.%M.%S").txt

    nmap $IP_RANGE > $REPORT
else
    script_name=`basename "$0"`
    echo "Usage: $script_name <IP Range e.g., 192.168.1.0/24> <report_dir>"
    exit 1
fi

# Configure this as Cronjob, e.g., at 1:30 AM every Friday.
# 30 1 * * 5 $HOME/bin/network_scan_report.sh 192.168.1.0/24 /media/homesrv/reports
