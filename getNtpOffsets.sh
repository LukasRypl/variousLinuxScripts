#!/bin/bash
# Expects IP addresses on input, one per line
# Stores reported NTP offset with timestamp to file <IP>.txt 
# Should be invoked from cron e.g */5 * * * * cd /var/tmp/ntpmonitor ; cat IP.list | ./getNTPoffset.sh
#

while read line ; do
  ts=$(date --rfc-3339='seconds')
  offset=$(/usr/sbin/ntpq -n -c "host $line" --peers | grep '^*' | awk '{print $9}')
  echo "$ts $offset" >> ${line}.txt
done
