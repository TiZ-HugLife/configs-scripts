#!/bin/sh
# shellcheck disable=SC2016
# Requires imagemagick. Configure Quod Libet's Picture Saver plugin to save
# the cover to $HOME/.cache/ql.current.cover

if [ -z "$(pgrep -f python.*quodlibet)" ] || [ ! -e ~/.quodlibet/current ];
    then exit 0; fi

if [ ! -x "$(command -v quodlibet)" ] && [ -x "$(command -v flatpak)" ]; then
    quodlibet () {
        flatpak run io.github.quodlibet.QuodLibet "$@"
    }
fi
puts () { printf %s\\n "$*"; }

# Only does the work if current song actually changes.
rundir="/run/user/$(id -u)/conky"
if [ ! -e "$rundir/ql_cache" ]; then
    mkdir -p "$rundir"
fi
if [ -e "$rundir/ql_cache" ]; then
    ql_time=$(date +%s -r "$HOME/.quodlibet/current");
    if [ -e "$rundir/ql_time" ] && \
       [ "$ql_time" -eq "$(cat "$rundir/ql_time")" ]; then
        cat "$rundir/ql_cache"
        exit 0
    fi
    puts "$ql_time" > "$rundir/ql_time"
fi

voffset=30
hoffset=112
font="Avenir LT 65 Medium"
fallbackfont="WenQuanYi Micro Hei"  # In case of Japanese music.
fontsize=10
fallbackfontsize=10
fallbackregex='[\p{Hiragana}\p{Katakana}\p{Han}]'
titlesize=14
imgsize=96
radius=12
shadowtype=0

while getopts :f:F:t:T:s:S:i:v:V:a:Ar:R:hHw OPT; do case $OPT in
    f) font="$OPTARG" ;;
    F) fallbackfont="$OPTARG" ;;
    t) titlesize="$OPTARG" ;;
    T) fallbacktitlesize="$OPTARG" ;;
    s) fontsize="$OPTARG" ;;
    S) fallbackfontsize="$OPTARG" ;;
    i) imgsize="$OPTARG" ;;
    v) voffset="$OPTARG" ;;
    V) fallbackvoffset="$OPTARG" ;;
    a) hoffset="$OPTARG" ;;
    A) alignr=1 ;;
    r) radius="$OPTARG" ;;
    R) fallbackregex="$OPTARG" ;;
    h) shadowtype=1 ;;
    H) shadowtype=2 ;;
    w) watchmode=1 ;;
    *) : ;;
esac; done

confdir=$(dirname "$(readlink -f "$0")")
cd "$rundir" || exit
cur="$(quodlibet --print-playing \
'${font %font%:Bold:size=%title%}${offset '"$hoffset"'}%alignr%<title>${font %font%:Bold:size=%size%}<artist|
${offset '"$hoffset"'}%alignr%<artist>>${font %font%:size=%size%}<album|
${offset '"$hoffset"'}%alignr%<album>><website|
${offset '"$hoffset"'}%alignr%<website>>')"
if [ "$watchmode" ] || [ "$(cat ql_current)" != "$cur" ]; then
    IN="$HOME/.cache/ql.current.cover"
    [ ! -e "$IN" ] && IN="$confdir/nocover.png"
    convert "$IN" -resize "${imgsize}x${imgsize}" .qli-step1.png
    convert .qli-step1.png -format \
     "roundrectangle 0,0 %[fx:w-1],%[fx:h-1] $radius,$radius" \
     info: > .qli-draw.mvg
    convert .qli-step1.png -border 0 -alpha transparent -background none -fill \
     white -stroke none -strokewidth 0 -draw "@.qli-draw.mvg" .qli-mask.png
    convert .qli-step1.png -alpha set -bordercolor none -border 0 .qli-mask.png \
     -compose DstIn -composite .qli-step2.png
    convert .qli-step2.png -background none -gravity south \
     -extent "${imgsize}x${imgsize}" .qli-step3.png
    if [ "$shadowtype" = "1" ]; then
        convert .qli-step3.png \( +clone -background black -shadow 90x3+0+0 \) \
         +swap -background none -layers merge +repage conkycover.png
    elif [ "$shadowtype" = "2" ]; then
        convert .qli-step3.png +level 0%,0% .qli-step4.png
        composite -compose Dst_Over -geometry +1+1 .qli-step4.png .qli-step3.png \
         .qli-step4.png
        mv .qli-step4.png conkycover.png
    else
        mv .qli-step3.png conkycover.png
    fi
    rm .qli-step*.png .qli-mask.png .qli-draw.mvg
    puts "$cur" > ql_current
fi
if [ "$alignr" ]; then
    cur="$(puts "$cur" | sed 's/%alignr%/${alignr}${offset -'"$hoffset"'}/g')"
else
    cur="$(puts "$cur" | sed 's/%alignr%//g')"
fi
if (puts "$cur" | grep -P "$fallbackregex" > /dev/null); then
    voffset="${fallbackvoffset:-$voffset}"
    cur="$(puts "$cur" | sed -e "s/%font%/$fallbackfont/g" \
     -e "s/%size%/$fallbackfontsize/g" -e "s/%title%/$fallbacktitlesize/g")"
else
    cur="$(puts "$cur" | sed -e "s/%font%/$font/g" -e "s/%size%/$fontsize/g" \
     -e "s/%title%/$titlesize/g")"
fi
puts '${voffset '"$voffset"'}'"$cur"'${font}' > "$rundir/ql_cache"
cat "$rundir/ql_cache"
