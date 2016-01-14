#!/bin/bash
# Requires imagemagick. Configure Quod Libet's Picture Saver plugin to save
# the cover to /tmp/current.cover

([[ -z "$(pgrep quodlibet)" ]] || [[ ! -e ~/.quodlibet/current ]]) && exit 0

voffset=30
hoffset=112
font="Avenir LT 65 Medium"
fallbackfont="WenQuanYi Micro Hei"  # In case of Japanese music.
fontsize=10
fallbackfontsize=10
titlesize=14
imgsize=96
radius=12
shadowtype=0

while getopts :f:F:t:T:s:S:i:v:a:r:hH OPT; do
case $OPT in
    f) font="$OPTARG" ;;
    F) fallbackfont="$OPTARG" ;;
    t) titlesize="$OPTARG" ;;
    T) fallbacktitlesize="$OPTARG" ;;
    s) fontsize="$OPTARG" ;;
    S) fallbackfontsize="$OPTARG" ;;
    i) imgsize="$OPTARG" ;;
    v) voffset="$OPTARG" ;;
    a) hoffset="$OPTARG" ;;
    r) radius="$OPTARG" ;;
    h) shadowtype=1 ;;
    H) shadowtype=2 ;;
esac
done

[[ "$shadowtype" = "1" ]] && voffset=$((voffset + 10))
cd /tmp
cur="$(quodlibet --print-playing '${font %font%:Bold:size=%title%}${alignr} <title>${font %font%:Bold:size=%size%}<artist|
${alignr} <artist>>${font %font%:size=%size%}<album|
${alignr} <album>><website|
${alignr} <website>>')"
if [[ "$(cat .current.song)" != "$cur" ]]; then
    IN=current.cover
    [[ ! -e $IN ]] && IN=~/.conky/QLInfo/nocover.png
    convert $IN -resize ${imgsize}x${imgsize} .qli-step1.png
    convert .qli-step1.png -format "roundrectangle 0,0 %[fx:w-1],%[fx:h-1] $radius,$radius" \
     info: > .qli-draw.mvg
    convert .qli-step1.png -border 0 -alpha transparent -background none -fill \
     white -stroke none -strokewidth 0 -draw "@.qli-draw.mvg" .qli-mask.png
    convert .qli-step1.png -alpha set -bordercolor none -border 0 .qli-mask.png \
     -compose DstIn -composite .qli-step2.png
    convert .qli-step2.png -background none -gravity south -extent ${imgsize}x${imgsize} \
     .qli-step3.png
    if [[ "$shadowtype" = "1" ]]; then
        convert .qli-step3.png \( +clone -background black -shadow 90x3+0+0 \) \
         +swap -background none -layers merge +repage conkycover.png
    elif [[ "$shadowtype" = "2" ]]; then
        convert .qli-step3.png +level 0%,0% .qli-step4.png
        composite -compose Dst_Over -geometry +1+1 .qli-step4.png .qli-step3.png \
         conkycover.png
    else
        mv .qli-step3.png conkycover.png
    fi
    rm .qli-step*.png .qli-mask.png .qli-draw.mvg
    echo "$cur" > .current.song
fi
if (echo "$cur" | grep -P '[^[:ascii:]]' > /dev/null); then
    cur="$(echo "$cur" | sed -e "s/%font%/$fallbackfont/g" \
     -e "s/%size%/$fallbackfontsize/g" -e "s/%title%/$fallbacktitlesize/g")"
else
    cur="$(echo "$cur" | sed -e "s/%font%/$font/g" -e "s/%size%/$fontsize/g" \
     -e "s/%title%/$titlesize/g")"
fi
IMGDIFF=$((588 - imgsize))
#echo -e '${image /tmp/conkycover.png -p '$IMGDIFF',0}${voffset '$voffset'}'"$cur"'${font}'
#echo -e '${voffset '$voffset'}'"$cur"'${font}'
echo -e "$cur"
