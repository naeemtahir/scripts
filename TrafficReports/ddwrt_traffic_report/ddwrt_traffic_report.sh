#!/bin/sh

if [ "$#" -eq 2 ] && [ -d "$1" ] && [ -d "$2" ]; then
   LOG_DIR=$1
   REPORT_DIR=$2

   AWK_SCRIPT=~/bin/ddwrt_traffic_report.awk
   TIMESTAMP=$(date +"%Y.%m.%d_%H.%M.%S")

   LOG=$LOG_DIR/ddwrt.log.1.gz
   INBOUND_REPORT=$REPORT_DIR/DDWRT_inbound_$TIMESTAMP.csv
   OUTBOUND_REPORT=$REPORT_DIR/DDWRT_outbound_$TIMESTAMP.csv
   REPORT=$REPORT_DIR/DDWRT_$TIMESTAMP.csv

   # Inbound='IN=vlan1 OUT=', Outbound='IN=br0 OUT=vlan1', Local='IN=br0 OUT='

   # Report inbound traffic
   zgrep 'IN=vlan1 OUT=' $LOG | awk -f $AWK_SCRIPT | uniq >> $INBOUND_REPORT

   # Report outbound traffic from certain hosts
   zgrep 'IN=br0\ OUT=vlan1' $LOG | grep '192.168.1.3\|192.168.1.159\|192.168.1.166\|192.168.1.173' | awk -f $AWK_SCRIPT | uniq >> $OUTBOUND_REPORT

   # Report all traffic
   # zgrep 'SRC=' $LOG | awk -f $AWK_SCRIPT | uniq >> $REPORT
else
    script_name=`basename "$0"`
    echo "Usage: $script_name <log_dir> <report_dir>"
    exit 1
fi

# Configure this as Cronjob, e.g., at 2:30 AM every Friday.
#30 2 * * 5 $HOME/bin/ddwrt_traffic_report.sh /var/log /media/homesrv/reports
