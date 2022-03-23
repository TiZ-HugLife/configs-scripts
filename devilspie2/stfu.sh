#!/bin/sh
# Continuously remove a window's attention hint for several seconds and also
# move back to the initial workspace. Useful for windows that demand attention
# on startup like Discord, Firefox, and Joplin, or on Plasma, *everything*.
set -eu

max=50
count=0
printf "  ++ Window silencer invoked on %s.\n" "$1"
{
# We print it twice so we get it in the stfu log too.
printf "++ Window silencer invoked on %s.\n" "$1"
while [ "$((count = count + 1))" -le "$max" ]; do
	sleep 0.1
	case "$(xprop -id "$1" _NET_WM_STATE)" in
	*DEMANDS_ATTENTION*)
		printf "++ Caught %s demanding attention.\n" "$1"
		wmctrl -i -r "$1" -b remove,demands_attention
		wmctrl -s 1
		count=$((max - 40))
		;;
	esac
done
printf "++ Time ran out on %s.\n" "$1"
} | logger -t stfu &
