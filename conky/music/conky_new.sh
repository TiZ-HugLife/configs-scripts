#!/bin/sh
# shellcheck disable=SC2016
# Uses information spit out by qlmonit since it has to be used for OBS anyways.
# This script is like 100000x simpler, whew!
set -eu

rundir="/run/user/$(id -u)/conky"
songinfodir="/run/user/$(id -u)/song-info"
cd "$songinfodir"

title=$(cat "title.txt")
artist=$(cat "artist.txt")
album=$(cat "album.txt")

if ! [ "$title" ]; then exit 0; fi

put () { printf %s "$*"; }
puts () { printf %s\\n "$*"; }

# Only does the work if current song actually changes.
if [ ! -e "$rundir/ql_cache" ]; then
    mkdir -p "$rundir"
fi
if [ -e "$rundir/ql_cache" ]; then
    ql_time=$(date +%s -r "$songinfodir/title.txt" || :);
    if [ -e "$rundir/ql_time" ] && \
       [ "$ql_time" -eq "$(cat "$rundir/ql_time")" ]; then
        cat "$rundir/ql_cache"
        exit 0
    fi
    puts "$ql_time" > "$rundir/ql_time"
fi

density=$(xrdb -query | grep Xft.dpi | cut -f2)
if ! [ "$density" ]; then density=96; fi

align="$1"; shift
voffset="$1"; shift
font="$1"; shift
titlesize="$1"; shift
fontsize="$1"; shift
gravity="west"
if [ "$align" = "right" ]; then gravity="east"; fi

# It will be a cold day in hell when Conky has fallback fonts.
# Let's fucking cheat and render text to an image with Pango.
convert -density "$density" -pointsize "$fontsize" -font "$font" \
 -background none -fill white \
 "pango:<span size='large'><b>$title</b></span>" \
 "pango:<b>$artist</b>" "pango:$album" \
 -gravity "$gravity" -append label-base.png

convert label-base.png -negate -background none -splice 1x1 label-shadow.png
convert label-base.png +level-colors "none,$fgcolor" label-fg.png
composite label-fg.png label-shadow.png label.png

coverwidth=$(identify -format %w "cover.png")
coverheight=$(identify -format %h "cover.png")
labelwidth=$(identify -format %w "label.png")
labelheight=$(identify -format %h "label.png")
hoffset=$((coverwidth + labelwidth + ${1:-4}))

if [ "$align" = "right" ]; then alignr='${alignr}${offset -'"$hoffset"'}'; fi

puts '${voffset '"$voffset"'}${font '"$font"':Bold:size='"$titlesize"'}${offset '"$hoffset"'}'"${alignr:-}   " | tee "$rundir/ql_cache"
