# Aliases included in various distros.
alias ls='ls --color=auto '
alias grep='grep --color=auto '
alias fgrep='fgrep --color=auto '
alias egrep='egrep --color=auto '

# Custom aliases.
alias sudo='sudo '
alias fucking='sudo '
alias rs='rsync -avzsHXA -e ssh --progress '
alias rsbak='rs --remote-option --fake-super '
alias icoextract='wrestool -x --output=. -t14'
alias r='rolldice --separate --random'
alias usbconsole='script -f -c "picocom /dev/ttyUSB0" console.log'
alias marina-pingtest='ssh marina pingtest'
alias sshproxy='ssh -D 28080 marina'
alias protontricks='flatpak run --command=protontricks com.valvesoftware.Steam --no-runtime'
alias ginstall='/xusr/bin/ginstall.sh -d /xusr/bin '
alias test-lan='iperf3 -c 192.168.102.4 -f M --get-server-output'

# Sometimes people reach over and hit alt+f4.
altf4_psyche () {
    yad --title HAHAHAHAHA --text "YOU THOUGHT YOU COULD CLOSE MY\nWINDOW BUT YOU WERE WRONG.\nNICE TRY DOOFUS." --button "gtk-close"
}

# Set the compression flag on a directory then recursively compress it.
compress () {
    btrfs property set "$1" compression zstd
    btrfs filesystem defragment -vr -czstd "$1"
}

# Update PC games in Pegasus.
update_pc_games () {
    dir="/home/tiz/gam/pc"
    generate-steamids "$dir"
    echo "Pausing so you can check the generated steamids."
    read -p "Press enter to continue."
    steamid-to-skyscraper "$dir"
    scrape-steamgriddb "$dir"
    Skyscraper -p pc -s import
    Skyscraper -p pc
    #sed -i '/^extensions:/d' "$dir/metadata.pegasus.txt"
}

# Update links to the default kernel for custom GRUB entries.
default_kernel () { (
    cd /boot
    #ver=$(ls | sed -n s/vmlinuz-//p | tail -1)
    ver=$(uname -r)
    sudo ln -sfn "initrd.img-$ver" default-initrd.img
    sudo ln -sfn "vmlinuz-$ver" default-vmlinuz
    printf "default kernel set to %s.\n" "$ver"
) }

# Extract and install bo0xvn wallpapers.
bo0xvn () {
    local dir=$(mktemp -d)
    local zips=$(find . -name "*by_bo0xvn*")
    for z in $zips; do unzip -qq $z -d $dir; done
    rm -r $dir/__MACOSX
    for f in $(find $dir -name "*2880_1800*"); do
        basename "$f"
        mv $f ~/pic/wal/bo0xvn/$(
            sed -nr 's:^.+/_+([0-9]+)_([VIX]+)_.+$:\L\2\.0\1\.jpg:p' <<< "$f"
        )
    done
    # Prefer 4K.
    for f in $(find $dir -name "*4k.jpg"); do
        basename "$f"
        mv $f ~/pic/wal/bo0xvn/$(
            sed -nr 's:^.+/_+([0-9]+)_([VIX]+)_.+$:\L\2\.0\1\.jpg:p' <<< "$f"
        )
    done
    rm -r $dir
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
        "$HOME/doc"
        "$HOME/mus"
        "$HOME/pic"
        "$HOME/prj"
        "$HOME/pub"
        "$HOME/gam/save"
        "$HOME/xdg/sync"
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

# Haxe REPL.
alias ihx="haxelib --global run ihx"

# Dump and then strip album art.
albumart_mp3 () {
    VAR=(*.mp3)
    eyeD3 --write-images . "${VAR[0]}"
    mv FRONT_COVER.j* albumart.jpg
    #mid3v2 --delete-frames=PIC,APIC *.mp3
}

albumart_flac () {
    VAR=(*.flac)
    metaflac --export-picture=albumart.jpg "${VAR[0]}"
    #metaflac --remove --block-type=PICTURE,PADDING --dont-use-padding *.flac
}

# Unrotate images, now lossless! (Might be because I do 4:3 pics now.)
auto_orient () {
    [[ ! -d "$1" ]] && echo "Need a directory." && return 1
    cd "$1"
    for f in *.jpg; do
        jhead -autorot "$f"
        jhead -norot -rgt "$f"
    done
    notify-send "Auto-rotate complete"
}

# Silence videos. Why would I need to do that?
# Because I take videos of twirly cuties at conventions and my gleeful
# squeaks don't really add anything to the experience aside from
# embarrassing myself when I'm just trying to cheer up.
vid_silence () {
    for f in "$@"; do if [[ -f "$f" ]]; then
        ffmpeg -i "$f" -c:v copy -an "${f%.*}.shh.${f##*.}"
    fi; done
}

# Sometimes my save data gets corrupted.
backup_scvi () {
    dir="/home/tiz/gam/save/pc/SCVI/Saved"
    bak="/home/tiz/gam/save/pc/SCVI/Backups"
    cp -r "$dir" "$bak/$(date +%y%m%d%H%M)"
}
