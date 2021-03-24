#!/bin/sh
# Adapted from ToZ's script, found here:
# https://forum.xfce.org/viewtopic.php?pid=59979#p59979

puts () { printf %b\\n "$*"; }
putd () { printf %b\\n "$*" >&2; }
field () { printf %b\\n "$OUT" | awk -F';' '{print $'"$1"'}'; }

convert_time () {
    HOUR=$(puts "$1" | awk -F':' '{print $1}')
    MINUTE=$(puts "$1" | awk -F':' '{print $2}')
    
    HOUR=$(printf "%d" "$HOUR")
    if [ "$HOUR" -lt 12 ]; then AMPM=am
    else HOUR=$((HOUR - 12)); AMPM=pm; fi
    if [ "$HOUR" -eq 0 ]; then HOUR=12; fi
    
    puts "$HOUR:$MINUTE $AMPM"
}

LOCATION=$(puts "${1:-}" | sed 's/ /%20/g')

CLICK_COMMAND="xfce4-terminal -H --geometry=126x41 -T Weather -x curl -s wttr.in/$LOCATION"

SPACE="<span size='x-small'> </span>"

if [ -x "$(command -v check)" ]; then
    # Use wait-for-it to wait for an internet connection.
    # Display nothing if we're offline.
    if ! check internet; then printf "<txt></txt>\n"; exit 0; fi
fi

OUT=$(curl -s wttr.in/"$LOCATION"?format="%c;%h;%t;%f;%w;%l;%m;%M;%p;%P;%D;%S;%z;%s;%d;%C")

if [ "$?" -ne 0 ]; then printf "<txt></txt>\n"; exit 0; fi

WEATHERICON=$(field 1)
HUMIDITY=$(field 2)
TEMPERATURE=$(field 3 | sed -e 's/+//g' -e 's/^-0/0/g' )
FEELSLIKE=$(field 3 | sed -e 's/+//g' -e 's/^-0/0/g' )
WIND=$(field 5)
LOCATION=$(field 6)
SITE=$(field 6 | awk -F", " '{print $1}')
MOONPHASE=$(field 7)
MOONDAY=$(field 8)
PRECIPITATION=$(field 9)
PRESSURE=$(field 10)
DAWN=$(convert_time "$(field 11)")
SUNRISE=$(convert_time "$(field 12)")
ZENITH=$(convert_time "$(field 13)")
SUNSET=$(convert_time "$(field 14)")
DUSK=$(convert_time "$(field 15)")
WEATHERCONDITION=$(field 16)

if [ "${2:-}" = "debug" ]; then
    putd "OUT=$OUT"
    putd "WEATHERICON=$WEATHERICON"
    putd "HUMIDITY=$HUMIDITY"
    putd "TEMPERATURE=$TEMPERATURE"
    putd "FEELSLIKE=$FEELSLIKE"
    putd "WIND=$WIND"
    putd "LOCATION=$LOCATION"
    putd "MOONPHASE=$MOONPHASE"
    putd "MOONDAY=$MOONDAY"
    putd "PRECIPITATION=$PRECIPITATION"
    putd "PRESSURE=$PRESSURE"
    putd "DAWN=$DAWN"
    putd "SUNRISE=$SUNRISE"
    putd "ZENITH=$ZENITH"
    putd "SUNSET=$SUNSET"
    putd "DUSK=$DUSK"
    putd "WEATHERCONDITION=$WEATHERCONDITION"
fi

# Genmon output
puts "<txt>$SPACE<span size='medium'>$WEATHERICON</span>$SPACE<span weight='Bold'>$TEMPERATURE</span>$SPACE</txt>"
puts "<txtclick>$CLICK_COMMAND</txtclick>"
puts "<tool><b><big>$WEATHERICON$SPACE$SITE</big></b>
$TEMPERATURE <small>and</small> $WEATHERCONDITION
<small>
Feels like:\t$FEELSLIKE
Humidity:\t$HUMIDITY
Wind:\t\t$WIND
Precipitation:\t$PRECIPITATION
Pressure:\t$PRESSURE

Rise/Set:\t$SUNRISE / $SUNSET

Moon:\t\t$MOONPHASE
</small>
<span size='x-small'>$(date)</span></tool>"

exit 0
