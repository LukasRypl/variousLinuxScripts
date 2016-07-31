#!/bin/bash
# synclient commandline  utility to query and modify Synaptics driver parameters
# notify-send for displaying info

state=$(synclient -l | grep TouchpadOff | awk '{print $3}')

function show() {
  notify-send  -t 3 "$1"
  echo "$1"
}

if [ "$state" == "0" ] ; then
  synclient TouchpadOff=1
  # TODO Toggle LED state - something like sudo su -c 'echo 0 >/sys/class/leds/dell-laptop::touchpad/brightness'
  show "Touchpad is OFF"
elif [ "$state" == "1" ] ; then
  synclient TouchpadOff=0
  show "Touchpad activated"
else
  show "Touchpad state is unknown"
fi
