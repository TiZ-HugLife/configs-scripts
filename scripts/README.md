# TiZ's Utility Scripts

Welcome to, IMO, the most interesting folder of this whole repo.

It's no stranger to anyone that desktop Linux has a whole lot of papercuts and shortcomings. A lot of them can be worked around with scripts, and here you'll find a collection of the scripts I use to work around stuff.

I have written an overwhelming majority of these scripts in POSIX sh. I've chosen POSIX sh for three main reasons: the first and simplest is that every Linux system has a /bin/sh. Second: every /bin/sh is consistent everywhere and so are the POSIX utilities like grep, sed, awk, etc. Lastly: the more limiting syntax *is supposed to* protect me from scope creep. If there is something I should be writing as a program instead of a script, the limiting syntax *should* stop me, but often times what actually happens is that I create multiple scripts that work together to accomplish a task.

Now that I have a lib.sh, it is clear that my goal to keep me from using sh for stuff I shouldn't has failed and I need to re-evaluate some of my life choices. Whenever I do resolve to write a Real-Ass Program™, I usually use Python 3, and I try to avoid pip dependencies so I don't have to reinstall them every time a new version comes out. I'm exploring potentially using Crystal as well, and just distributing static binaries with musl.

Here are some great resources for writing scripts in POSIX sh:

* [Shellhaters.org](https://shellhaters.org/)
* [Pure SH Bible](https://github.com/dylanaraps/pure-sh-bible)
* [Rich's sh tricks](http://www.etalabs.net/sh_tricks.html)

Some of the stuff in the above links, and some of the extra tricks below, are implemented in [lib.sh](lib.sh). For example, my `puts` function is literally just Rich's simple `echo`, for the reasons he outlined, except with a different name so `echo` semantics aren't expected by anyone reading my code.

## Header as Usage Text

Comments at the top of your file are absolutely good practice, but often times if a script hasn't been used for a hot minute, you might not remember what it does or how to use it, and it's kind of unwieldy to open the file to remember how to use it. Wouldn't it be great if you could run your script with a `-h` switch and get that comment block? Well, you can!

```sh
# Print the comment header of this file when asked for help.
usage () { sed -nE '/^#/!q; /SC[0-9]{4}/d; s/^#( |$)//p' "$0"; exit "${1:-0}"; }
case "${1:-}" in -h|--help|--usage|help|usage|"") usage 0 ;; esac
```

This sed block does three things: quits on any non-comment line, deletes shellcheck directives, and prints comments without the comment character in front. Using case, we can respond to the standard flags for help and usage, and also to an invocation without arguments with a `""` case.

If the script is intended to be run without arguments, remove the `""` case. That said, this idiom is not very useful for scripts that run in the background and do things autonomously, which also typically do so without arguments.

## Checking dependencies

If you make a script that uses a program that cannot be reasonably guaranteed to be part of any given Linux system, then you should check for its presence at the start of the script.

```sh
# Check dependencies.
for cmd in zcat sponge; do if ! [ -x "$(command -v "$cmd")" ]; then
	printf "This script requires %s; please install it.\n" "$cmd" >&2; exit 1
fi; done
```

If it's more than one program, you should use the above form. If it's just one program, this next one will do:

```sh
if ! [ -x "$(command -v maim)" ]; then
	printf "This script requires maim; please install it.\n" >&2; exit 1
fi
```

The version of this idiom in lib.sh will check for every program in the list and output every missing program instead of exiting on the first missing one.

## Self-Sudo

Sometimes a script is intended to be invoked with sudo. Whenever that is the case, why not just go ahead and handle that ourselves?

```sh
if [ "$(id -u)" -gt 0 ]; then exec sudo -k "$0" "$@"; fi
```

First, it will only run this code if it is not already root. Second, exec takes care of ending the current invocation and also replacing the current process. Last and most importantly: unless you add an entry in the sudoers file, you will always know the script is trying to sudo because it invalidates the timestamp with -k. It's a bad idea to become root without explicit consent.

If the script runs without arguments, you can remove the `"$@"`, and it may even be safer to do so, but it shouldn't hurt anything if the script doesn't respond to arguments anyways.

If you document with a usage function, you should add a paragraph in the usage text:

```
<<! Please note that this script will invoke sudo on itself. !>>
And then make sure to explain why the script needs to sudo itself.
```

Self-sudo breaks simple inclusion of lib.sh due to resetting `$PATH`. It's probably not a good idea to preserve `$PATH`, so if we want to still use it, make sure it exists next to the script and then do this:

```sh
. "$(dirname "$0")/lib.sh"
```
