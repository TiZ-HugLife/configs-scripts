#!/bin/bash

# Only does the work if todo.txt or done.txt actually change.
rundir="/run/user/$UID/conky"
if [[ ! -e "$rundir/todo" ]]; then
    mkdir -p "$rundir"
    ln -s "$(todo path todo)" "$rundir/todo"
    ln -s "$(todo path done)" "$rundir/done"
fi
if [[ -e "$rundir/todo_cache" ]]; then
    todo_time=$(date +%s -r "$rundir/todo");
    done_time=$(date +%s -r "$rundir/done");
    if [[ -e "$rundir/todo_time" &&
          "$todo_time" -eq "$(<"$rundir/todo_time")" &&
          "$done_time" -eq "$(<"$rundir/done_time")" ]]; then
        #echo "No changes; using cache" >&2
        cat "$rundir/todo_cache"
        exit 0
    fi
    #echo "Change detected; re-processing" >&2
    echo "$todo_time" > "$rundir/todo_time"
    echo "$done_time" > "$rundir/done_time"
fi

font="Liberation Sans"; fontsize="9"
numvoffset="0:0"
other_header="Other"
args=(-d $HOME/.todo/config-conky -Pn)
dateoffset="-4hours"
donerx="s:[0-9]* x [0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\} ::"
match='(\$\{.*\})?([0-9]*) (.*)'
switch='\2 \| \1\3'
categories=''
declare -A tasks

while getopts rbo:c:f:s:n:N:v:d: OPT; do case $OPT in
    r) right=1 ;;
    b) done_bottom=yes ;;
    o) other_header="$OPTARG" ;;
    c) categories="$OPTARG" ;;
    f) font="$OPTARG" ;;
    s) fontsize="$OPTARG" ;;
    n) numfont="$OPTARG" ;;
    N) numfontsize="$OPTARG" ;;
    v) numvoffset="$OPTARG" ;;
    d) dateoffset="$OPTARG" ;;
esac; done; shift $((OPTIND - 1))
numfont="${numfont:-$font}"
numfontsize="${numfontsize:-$fontsize}"
numvostart="$(cut -d: -f1 <<< "$numvoffset")"
numvoend="$(cut -d: -f2 <<< "$numvoffset")"
numvoend="${numvoend:--$numvostart}"

today=$(date -d "$dateoffset" +%Y-%m-%d)
header_start='${font '"$font"':size='"$fontsize"':weight=bold}'
header_end='${font '"$font"':size='"$fontsize"'}'
num_start='${font '"$numfont"':size='"$numfontsize"'}${voffset '"$numvostart"'}'
num_end='${font '"$font"':size='"$fontsize"'}${voffset '"$numvoend"'}'

if [[ "${right:-}" ]]; then
    switch='\1\3 \| '"$num_start"'\2'"$num_end"
    align='${alignr}'; alnrx="s/^/$align/"
else
    switch="$num_start"'\2'"$num_end"' \| \1\3'
fi

header_start='${font '"$font"':size='"$fontsize"':weight=bold}'
header_end='${font '"$font"':size='"$fontsize"'}'

inverse=""
for c in $categories; do
    tasks[$c]=$(todo ${args[@]} ls @$c | head -n -2)
    inverse+="-@$c "
done
done=$(todo ${args[@]} lf done.txt $today | head -n -2)
other=$(todo ${args[@]} ls $inverse | head -n -2)

exec 3>&1 1>"$rundir/todo_cache"
if [[ ! "$done_bottom" ]] && [[ "$done" ]]; then
        echo "$header_start$align-= Done Today =-$header_end"
        echo "$done" | sed -e "s:[0-9]* x $today ::" -e "$alnrx"
        echo
fi
for c in $categories; do if [[ "${tasks[$c]}" ]]; then
    echo "$header_start$align-= $c =-$header_end"
    echo "${tasks[$c]}" | sed -r -e "s: @$c::gI" -e "s/$match/$switch/" -e "$alnrx"
    echo
fi; done
if [[ "$other" ]]; then
    echo "$header_start$align-= $other_header =-$header_end"
    echo "$other" | sed -r -e "s/$match/$switch/" -e "$alnrx"
    echo
fi
if [[ "$done_bottom" ]] && [[ "$done" ]]; then
    echo "$header_start$align-= Done Today =-$header_end"
    echo "$done" | sed -e "$donerx" -e "$alnrx"
fi
exec 1>&3 3>&-

sed -i -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$rundir/todo_cache"
cat "$rundir/todo_cache"
