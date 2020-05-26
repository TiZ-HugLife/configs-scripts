#!/bin/sh
# shellcheck disable=SC2016
# Uses information spit out by qlmonit since it has to be used for OBS anyways.
# This script is like 100000x simpler, whew!
set -eu

rundir="/run/user/$(id -u)/conky"
songinfodir="/run/user/$(id -u)/song-info"

title=$(cat "$songinfodir/title.txt")
artist=$(cat "$songinfodir/artist.txt")
album=$(cat "$songinfodir/album.txt")

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

align="$1"; shift
voffset="$1"; shift
fallbackvoffset="$1"; shift
font="$1"; shift
titlesize="$1"; shift
fontsize="$1"; shift
fallbackfont="$1"; shift
fallbacktitlesize="$1"; shift
fallbackfontsize="$1"; shift

coverwidth=$(convert "$songinfodir/cover.png" -ping -format "%w" info:)
hoffset=$((coverwidth + ${1:-0}))

fallbackregex='[\p{Hiragana}\p{Katakana}\p{Han}]'

if [ "$align" = "right" ]; then alignr='${alignr}${offset -'"$hoffset"'}'; fi

if (puts "$title$artist$album" | grep -qP "$fallbackregex"); then
    voffset="$fallbackvoffset"
    font="$fallbackfont"
    fontsize="$fallbackfontsize"
    titlesize="$fallbacktitlesize"
fi

puts '${voffset '"$voffset"'}${font '"$font"':Bold:size='"$titlesize"'}${offset '"$hoffset"'}'"${alignr:-}$title"'${font '"$font"':Bold:size='"$fontsize"'}
${offset '"$hoffset"'}'"${alignr:-}$artist"'${font '"$font"':size='"$fontsize"'}
${offset '"$hoffset"'}'"${alignr:-}$album" | tee "$rundir/ql_cache"
