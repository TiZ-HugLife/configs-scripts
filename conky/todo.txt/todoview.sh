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

while getopts rbo:p: OPT; do
case $OPT in
    r) switch='\1\3 \| \2'; align='${alignr}'; alnrx="s/^/$align/" ;;
    b) done_bottom=yes ;;
    o) other_header="$OPTARG" ;;
    p) padding=$OPTARG ;;  # Conky likes to shift around a lot without this.
esac
done
shift $((OPTIND - 1))

done=$(todo ${args[@]} lf done.txt $today | head -n -2)
work=$(todo ${args[@]} ls @work | head -n -2)
school=$(todo ${args[@]} ls @school | head -n -2)
other=$(todo ${args[@]} ls -@work -@school | head -n -2)

[[ -n "$padding" ]] && {
    lines=0
    sep=0
    [[ -n "$done" ]] && lines=$(($lines + $(echo "$done" | wc -l) + 1))
    [[ -n "$done" ]] && [[ -n "$work" ]] && lines=$(($lines + 1))
    [[ -n "$work" ]] && lines=$(($lines + $(echo "$work" | wc -l) + 1))
    [[ -n "$work" ]] && [[ -n "$school" ]] && lines=$(($lines + 1))
    [[ -n "$school" ]] && lines=$(($lines + $(echo "$school" | wc -l) + 1))
    [[ -n "$school" ]] && [[ -n "$other" ]] && lines=$(($lines + 1))
    [[ -n "$other" ]] && lines=$(($lines + $(echo "$other" | wc -l) + 1))
    lines=$(($padding - $lines))
}

[[ -z "$done_bottom" ]] && {
    [[ -n "$padding" ]] && for i in $(seq 1 $lines); do echo; done
    [[ -n "$done" ]] && {
        echo "$header_start$align-= Done Today =-$header_end"
        echo "$done" | sed -e "s:[0-9]* x $today ::" -e "$alnrx"
        [[ -n "$work$school$other" ]] && echo '${color}'
    }
}
[[ -n "$work" ]] && {
    echo "$header_start$align-= Work =-$header_end"
    echo "$work" | sed -r -e 's: @work::gI' -e "s/$match/$switch/" -e "$alnrx"
    [[ -n "$school$other" ]] && echo '${color}'
}
[[ -n "$school" ]] && {
    echo "$header_start$align-= School =-$header_end"
    echo "$school" | sed -r -e 's: @school::gI' -e "s/$match/$switch/" -e "$alnrx"
    [[ -n "$other" ]] && echo '${color}'
}
[[ -n "$other" ]] && {
    echo "$header_start$align-= $other_header =-$header_end"
    echo "$other" | sed -r -e "s/$match/$switch/" -e "$alnrx"
}
[[ -n "$done_bottom" ]] && {
    [[ -n "$done" ]] && {
        [[ -n "$other" ]] && echo '${color}'
        echo "$header_start$align-= Done Today =-$header_end"
        echo "$done" | sed -e "$donerx" -e "$alnrx"
    }
    [[ -n "$padding" ]] && for i in $(seq 1 $lines); do echo; done
}
