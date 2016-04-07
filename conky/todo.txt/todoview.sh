#!/bin/bash
# Not as polished as I want it to be yet; I want to add the ability to use
# custom headers at some point and distribute this properly.

header_start='${font Liberation Sans:size=9:weight=bold}'
header_end='${font Liberation Sans:size=9}'
other_header="Other"
args=(-d $HOME/.todo/config-conky -Pn)
today=$(date -d "-4hours" +%Y-%m-%d)
donerx="s:[0-9]* x [0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\} ::"
match='(\$\{.*\})?([0-9]*) (.*)'
switch='\2 \| \1\3'
categories=''
declare -A tasks

while getopts rbo:c: OPT; do case $OPT in
    r) switch='\1\3 \| \2'; align='${alignr}'; alnrx="s/^/$align/" ;;
    b) done_bottom=yes ;;
    o) other_header="$OPTARG" ;;
    c) categories="$OPTARG" ;;
esac; done; shift $((OPTIND - 1))

inverse=""
for c in $categories; do
    tasks[$c]=$(todo ${args[@]} ls @$c | head -n -2)
    inverse+="-@$c "
done
done=$(todo ${args[@]} lf done.txt $today | head -n -2)
other=$(todo ${args[@]} ls $inverse | head -n -2)

exec 3>&1 1>/tmp/.todoview.tmp
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

sed -e :a -e '/^\n*$/{$d;N;ba' -e '}' /tmp/.todoview.tmp
