#!/bin/sh
# shellcheck disable=SC2034
# lib.sh -- A small library of POSIX sh functions
#
# These are all the utility functions that are too small to be scripts.
# Put this in your PATH and include it with `. lib.sh`.
# Including this script will automatically `set -eu`.
set -eu

# Ensure XDG vars are set.
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}

# Define color codes.
Treset=$(printf %b "\033[0m")
Tbold=$(printf %b "\033[1m")
TFblack=$(printf %b "\033[90m")
TFred=$(printf %b "\033[91m")
TFgreen=$(printf %b "\033[92m")
TFyellow=$(printf %b "\033[93m")
TFblue=$(printf %b "\033[94m")
TFmagenta=$(printf %b "\033[95m")
TFcyan=$(printf %b "\033[96m")
TFwhite=$(printf %b "\033[97m")

# Printing and output functions.
puts ()    { printf -- %b\\n "$*"; }
perr ()    { printf -- %b\\n "$*" >&2; }
die ()     { printf -- %b\\n "$*" >&2; exit 1; }
h1 ()      { puts "${Tbold}${TFcyan}==> ${TFwhite}$*${Treset}"; }
h2 ()      { puts "${Tbold}${TFblue}-> ${TFwhite}$*${Treset}"; }
success () { puts "${Tbold}${TFgreen}++ ${TFwhite}$*${Treset}"; }
failure () { puts "${Tbold}${TFred}!! ${TFwhite}$*${Treset}"; }

# Use stdin if $* is -. Useful for making chainable functions.
catarg () { if [ "${*:-}" = "-" ]; then cat; else printf %s\\n "$*"; fi; }

# String manipulation.
lower () { catarg "$*" | tr '[:upper:]' '[:lower:]'; }
upper () { catarg "$*" | tr '[:lower:]' '[:upper:]'; }
trim () {
	__lib_sh_trim=$(catarg "$*")
    __lib_sh_trim=${__lib_sh_trim#${__lib_sh_trim%%[![:space:]]*}}
    __lib_sh_trim=${__lib_sh_trim%${__lib_sh_trim##*[![:space:]]}}
    printf %s\\n "$__lib_sh_trim"
}
safe_filename () {
	catarg "$*" | trim - | \
	 sed -E -e 's/: / - /' -e "s/[^A-Za-z0-9._()'!& -]//g";
}
# By using a subshell, we don't have to change anything back.
# shellcheck disable=SC2086 disable=SC2048
split () { (
    set -f
    IFS=$1; shift
    set -- $*
    printf '%s\n' "$@"
) }

# Check for a variable to be a very loosely truthy value.
# When given extra arguments, function as a ternary puts.
is () {
	case "${1:-}" in
		[yY]*|[tT]*|[oO][nN]|[1-9]|[1-9][0-9]*)
			if [ "${2:-}" ]; then puts "$2"; else return 0; fi ;;
		*)
			if [ "${3:-}" ]; then puts "$3"; else return 1; fi ;;
	esac
}

# Convenience versions of frequently used idioms.
shh () { "$@" >/dev/null 2>&1; }
err_ok () { "$@" || :; }
pids () { pgrep "$@" || :; }
qpgrep () { pgrep "$@" >/dev/null 2>&1; }
has_flatpak () {
	[ -x "$(command -v flatpak)" ] && shh flatpak run --command=true "$1"
}

# Trap management.
cleanup_on_exit () {
	__current_trap=$(trap | err_ok grep -oP "(?<=trap -- ').+(?=' EXIT)")
	trap "${__current_trap:+$__current_trap; }rm -rf \"${1:?}\"" EXIT
	unset __current_trap
}

# Set up a run directory.
setup_rundir () {
	__rundir_name=${1:-$(basename "$0")}
	__rundir_id=$(id -u)
	if [ "$__rundir_id" -gt 0 ]; then
		if [ -w "/run/user/$__rundir_id" ]; then
			__rundir="/run/user/$__rundir_id/$__rundir_name"
		else
			__rundir="$(mktemp -d)"
		fi
	else __rundir="/run/$__rundir_name"
	fi
	mkdir -p "$__rundir"
	puts "$__rundir"
	unset __rundir_name __rundir_id __rundir
}

# Check for dependencies.
depends () {
	for arg; do
		if ! [ -x "$(command -v "$arg")" ]; then
			missing="${missing:+$missing }$arg"
		fi
	done

	if [ "${missing:-}" ]; then
		cat <<-EOF
			This script depends on the following missing utilities.
			Please install them.
				$missing
			EOF
		notify-send "Script failed" \
		 "A script failed due to missing dependencies:\n    $missing"
		exit 1
	fi
}

# Define a usage function that prints the comment header of the calling file.
usage () {
	__lib_sh_usage_on_empty=1
	__lib_sh_usage_words=1
	for arg; do case "$(lower "$arg")" in
	-z|noempty) __lib_sh_usage_on_empty=1; shift;;
	-n|emptyok) __lib_sh_usage_on_empty=0; shift;;
	-w|words) __lib_sh_usage_words=1; shift;;
	-W|nowords) __lib_sh_usage_words=0; shift;;
	--) shift; break;;
	esac; done
	usage () {
		sed -nE '/^#/!q; /SC[0-9]{4}/d; s/^#( |$)//p' "$0"
		exit "${1:-0}"
	}
	case "${1:-}" in
	-h|--help|--usage) usage 0 ;;
	help|usage) if [ "$__lib_sh_usage_words" -eq 1 ]; then usage 0; fi ;;
	"") if [ "$__lib_sh_usage_on_empty" -eq 1 ]; then usage 0; fi ;;
	esac
}

# Define a usage text, and then check for usage arguments.
# Takes the usage text as a heredoc. Requires program arguments passed through.
usage_old () {
	__lib_sh_usage_text=$(cat)
	if ! [ "$__lib_sh_usage_text" ]; then
		die "Usage requires usage text passed as a heredoc."
	fi
	__lib_sh_usage_on_empty=1
	for arg; do case "$(lower "$arg")" in
	-z|noempty) __lib_sh_usage_on_empty=1; shift ;;
	-n|emptyok) __lib_sh_usage_on_empty=0; shift ;;
	esac; done
	
	# That's right, this function replaces itself.
	usage () {
		this=$(basename "$0")
		printf %s\\n "$__lib_sh_usage_text" | sed "s/%this%/$this/"
		exit "${1:-0}"
	}
	case "${1:-}" in
	-h|--help|--usage) usage 0 ;;
	"") if [ "$__lib_sh_usage_on_empty" -eq 1 ]; then usage 0; fi ;;
	esac
}

# Lite version of dotdee.
dotdee_lite () {
	if [ -d "$1.d" ]; then
		for f in "$1.d"/*; do
			if [ -x "$f" ]; then "$f"
			elif [ -r "$f" ]; then cat "$f"
			fi
		done > "$1"
	fi
}
