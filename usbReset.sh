#!/bin/bash -eu
# Resets the last connected USB device with given vendor and product id

vendor="0b0E" # jabra
#vendor="046d" # logitech

product="1017" # J 930
#product="1041" # J 9460
#product="c52f" # Logitech receiver

# -------------------

echo "List of connected USB devices:"
lsusb | sort

#if [ ! $(lsusb | grep -qi "ID ${vendor}:${product} ") ]; then
if ! $(lsusb | grep -qi "ID ${vendor}:${product} "); then
  echo "Device ID  ${vendor}:${product} not found, exiting."
  exit 2
fi


USB_DEV=$(dmesg | grep -i -o "usb .*: New USB device found, idVendor=${vendor}, idProduct=${product}" | tail -n 1 | awk '{print $2}' | sed 's/://')

echo -e "\nWill try to reset this device:"
lsusb -v -d ${vendor}:$product} | grep -e '^Bus' -e iProduct -e iManufacturer -e iSerial

echo -e "Identified by ID as $USB_DEV \n"


file_authorized=/sys/bus/usb/devices/${USB_DEV}/authorized
if [ -e $file_authorized ]; then
	# reset procedure - authorize off -> on 
	echo -n '0' > $file_authorized 
	grep -H '.*' $file_authorized
	echo -n '1' > $file_authorized
	grep -H '.*' $file_authorized 
	echo "Done"
else 
	echo "$file_authorized not found (device disconnected?)"
	exit 3
fi


