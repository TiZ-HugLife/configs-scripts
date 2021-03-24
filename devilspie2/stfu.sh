#!/bin/sh
# Continuously remove a window's attention hint for 5 seconds.
# Really useful for Discord windows on startup.
set -eu

rundir="/run/user/$(id -u)/stfu"
mkdir -p "$rundir"

{
wfi -i 0.25 dbus org.xfce.Xfconf
xfconf-query -c xfwm4 -p /general/activate_action -s none
touch "$rundir/$$"
count=0
while [ "$((count = count + 1))" -le "$((${2:-5} * 4))" ]; do
	sleep 0.25
	wmctrl -i -r "$1" -b remove,demands_attention
done
rm -f "$rundir/$$"
if [ "$(find "$rundir" | wc -l)" -eq 1 ]; then
	xfconf-query -c xfwm4 -p /general/activate_action -s switch 
fi
} &
