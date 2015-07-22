# Aliases.
alias fucking='sudo'
alias ls='ls --color=auto'
alias icoextract='wrestool -x --output=. -t14'
alias backup='sudo rsync --verbose --progress --stats --archive --hard-links --acls --xattrs --numeric-ids --delete --delete-excluded --delete-after --ignore-errors --exclude-from=/home/trent/.backup.exclude / rsync://trent@tiz.qc.to:8873/$(hostname) > >(tee .backup-stdout) 2> >(tee .backup-stderr)'
alias cit383='rsync -av --progress /home/trent/School/CIT383/ mcpheronw1@cscode1:/home/local/NKU/mcpheronw1/CIT383/'
alias r='rolldice --separate --random'
alias kpie-dump='kpie --single /usr/share/doc/kpie/examples/dump.lua > /tmp/kpie-dump; geany /tmp/kpie-dump &'
alias cerebro-pingtest='ssh cerebro /home/common/bin/pingtest'

# Package management.
alias pkg-fail="echo Can't do that here, sorry."
if [[ -x $(which pacman) ]]; then
    alias pkg='yaourt'
    alias pkg-update='pkg -Syu --aur'
    alias pkg-install='pkg -S'
    alias pkg-install-file='pkg -U'
    alias pkg-remove='pkg -R'
    alias pkg-purge='pkg -Rnsc' 
    alias pkg-info='pkg -Si'
    alias pkg-info-local='pkg -Qi'
    alias pkg-search='pkg -Ss'
    alias pkg-search-local='pkg -Qs'
    alias pkg-list='pkg -Ql'
    alias pkg-owns='pkg -Qo'
    alias pkg-clean='pkg-fail'
elif [[ -x $(which apt-get) ]]; then
    alias pkg='sudo apt-get'
    alias pkg-update='pkg update && pkg dist-upgrade'
    alias pkg-install='pkg install'
    alias pkg-install-aur='pkg-fail'
    alias pkg-install-rec='pkg install --install-recommends'
    alias pkg-install-file='sudo gdebi'
    alias pkg-remove='pkg remove'
    alias pkg-purge='pkg purge'
    alias pkg-info='sudo apt-cache show'
    alias pkg-search='sudo apt-cache search'
    alias pkg-search-local='sudo dpkg --get-selections | grep'
    alias pkg-list='sudo dpkg -L'
    alias pkg-owns='sudo dpkg -S'
    alias pkg-clean='pkg autoremove && pkg autoclean'
fi

# Functions.
altf4_psyche () {
    yad --title HAHAHAHAHA --text "YOU THOUGHT YOU COULD CLOSE MY\nWINDOW BUT YOU WERE WRONG.\nNICE TRY DOOFUS." --button "gtk-close"
}

ffencode () {
    while getopts "s:e:" OPT; do
    case "$OPT" in
        s) START="-ss $1" ;;
        e) END="-to $2" ;;
    esac
    done
    shift $((OPTIND-1))
    ffmpeg -i "$1" $START $END \
     -c:v libx264 -preset faster -crf 18 \
     -c:a copy \
     -threads 0 \
     "$2"
}

# Generic search function.
search () {
    [ -z "$1" ] && echo "Need an argument, prick." && return 1
    EXTRA_ARGS=""
    [ "$1" = "-nr" ] && EXTRA_ARGS="${EXTRA_ARGS}-maxdepth 1 " && shift
    if [ "$#" = "1" ]; then
        DIR="."
        QUERY="$1"
    else
        DIR="$1"
        QUERY="$2"
    fi
    find "${DIR}" ${EXTRA_ARGS}-type f -exec grep -li "${QUERY}" \{\} \; | sort
}

# Dump and then strip album art.
albumart () {
    VAR=(*.mp3)
    eyeD3 -i . "$VAR"
    mv FRONT_COVER.jpeg albumart.jpg
    mid3v2 --delete-frames=PIC,APIC *.mp3
}

# Make btsync key.
gen-bts-secret () {
    echo "TiZEX1${1}sec$(echo $1|rev)ret${1}1XEZiT" | base64
}

sync-music () {
    rsync -av --progress --exclude=".st*" ~/Music/ /media/trent/TIZMUSIC/
    for f in /media/trent/TIZMUSIC/*.m3u8; do mv "$f" "${f/.m3u8/.m3u}"; done
}
