# Aliases.
alias fucking='sudo'
alias ls='ls --color=auto'
alias rs='rsync -avzsHXA -e ssh --rsync-path="rsync --fake-super" --progress'
alias icoextract='wrestool -x --output=. -t14'
alias r='rolldice --separate --random'
alias flow='haxelib run flow'
alias nme='haxelib run nme'
alias lime='haxelib run lime'
alias openfl='haxelib run openfl'
alias flixel='haxelib run flixel-tools'
alias kpie-dump='kpie --single /usr/share/doc/kpie/examples/dump.lua > /tmp/kpie-dump; geany /tmp/kpie-dump &'
alias cerebro-pingtest='ssh cerebro /home/common/bin/pingtest'

# Package management; consistent commands no matter what distro I'm on.
alias pkg-fail="echo Can't do that here, sorry."
if [[ -x $(which bauerbill 2> /dev/null) ]]; then
    alias pkg='bb_wrapper_wrapper --build-dir /home/tiz/Source'
    export archlinux=1
    
    # Now we're getting silly.
    bb_wrapper_wrapper () {
        pushd () { command pushd "$@" > /dev/null; }; export -f pushd
        popd ()  { command popd "$@" > /dev/null; };  export -f popd
        bb-wrapper "$@"
    }
elif [[ -x $(which yaourt 2> /dev/null) ]]; then
    alias pkg='yaourt'
    export archlinux=1
fi
if [[ "$archlinux" ]]; then
    alias pkg-update='pkg -Syu --aur'
    alias pkg-install='pkg -S --aur'
    alias pkg-install-file='pkg -U'
    alias pkg-remove='pkg -R'
    alias pkg-purge='pkg -Rnsc' 
    alias pkg-info='pkg -Si --aur'
    alias pkg-info-local='pkg -Qi'
    alias pkg-search='pkg -Ss --aur'
    alias pkg-search-local='pkg -Qs'
    alias pkg-list='pkg -Ql'
    alias pkg-owns='pkg -Qo'
    alias pkg-clean='pkg-fail'
    alias pkg-mirrors="sudo reflector --verbose --country 'United States' -l 25 -p http --sort rate --save /etc/pacman.d/mirrorlist"
elif [[ -x $(which apt-get 2> /dev/null) ]]; then
    alias pkg='sudo apt-get'
    alias pkg-update='pkg update && pkg dist-upgrade'
    alias pkg-install='pkg install'
    alias pkg-install-aur='pkg-fail'
    alias pkg-install-rec='pkg install --install-recommends'
    alias pkg-install-file='sudo dpkg -i'
    alias pkg-remove='pkg remove'
    alias pkg-purge='pkg purge'
    alias pkg-info='sudo apt-cache show'
    alias pkg-search='sudo apt-cache search'
    alias pkg-search-local='sudo dpkg --get-selections | grep'
    alias pkg-list='sudo dpkg -L'
    alias pkg-owns='sudo dpkg -S'
    alias pkg-clean='pkg autoremove && pkg autoclean'
fi

# Sometimes people reach over and hit alt+f4.
altf4_psyche () {
    yad --title HAHAHAHAHA --text "YOU THOUGHT YOU COULD CLOSE MY\nWINDOW BUT YOU WERE WRONG.\nNICE TRY DOOFUS." --button "gtk-close"
}

# I forgot what I use this for.
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

# For Syncthing.
find_sync_conflicts () {
    dirs=(
        "$HOME/Documents"
        "$HOME/Music"
        "$HOME/Pictures"
        "$HOME/Projects"
        "$HOME/Public"
        "$HOME/School"
        "$HOME/Games/Saves"
        "/home/common"
    )
    for dir in "${dirs[@]}"; do find "$dir" -name "*.sync-conflict-*"; done
}

# Compile Haxe programs.
hxneko () {
    main=${1/.hx/}; shift
    haxe -main $main -dce full "$@" -lib thx.core -lib tink_lang -lib tink_core \
     -neko .neko.n && nekotools boot .neko.n && mv .neko ./$main
}
hxcpp () {
    main=${1/.hx/}; shift
    haxe -main $main -dce full "$@" -lib thx.core -lib tink_lang -lib tink_core \
     -cpp .hxcpp && mv .hxcpp/$main ./$main
}

# Dump and then strip album art.
albumart_mp3 () {
    VAR=(*.mp3)
    eyeD3 --write-images . "$VAR"
    mv FRONT_COVER.jpeg albumart.jpg
    mid3v2 --delete-frames=PIC,APIC *.mp3
}

albumart_flac () {
    metaflac --remove --block-type=PICTURE,PADDING --dont-use-padding *.flac
}

# Unrotate images and strip exif data. Lossy!
auto_orient () {
    [[ ! -d "$1" ]] && echo "Need a directory." && return 1
    mogrify -auto-orient -quality 96% -strip "$1"/*.jpg
}

# Rotate videos.
vid_rotate () {
    for f in "$@"; do if [[ -f "$f" ]]; then
        ffmpeg -i "$f" -vf "transpose=1" "${f%.*}.rot.${f##*.}"
    fi; done
}

# Silence videos.
vid_silence () {
    for f in "$@"; do if [[ -f "$f" ]]; then
        ffmpeg -i "$f" -c:v copy -an "${f%.*}.shh.${f##*.}"
    fi; done
}
