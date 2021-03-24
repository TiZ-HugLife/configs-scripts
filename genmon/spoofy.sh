#!/bin/sh
set -eu

rundir="/run/user/$(id -u)/song-info"

title=$(cat "$rundir/title.txt" 2>&1 || :)

printf "<icon>spotify</icon>\n"
printf "<iconclick>focus-launch com.spotify.Client</iconclick>\n"

if ! [ "$title" ]; then
	cat <<-EOF
		<tool>No song playing.</tool>
	EOF
else
	cat <<-EOF
		<tool><big><b>$title</b></big>
		<b>$(cat "$rundir/artist.txt")</b>
		$(cat "$rundir/album.txt")</tool>
	EOF
fi
