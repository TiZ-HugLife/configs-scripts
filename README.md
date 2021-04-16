# TiZ's Configs and Scripts Repo

Hello there, welcome to my repo of scripts, configs, tweaks, etc etc etc. All of this is public domain so do as you will with it. :)

Here is IMO the most interesting stuff.

### /gtk*

I don't like thick empty space padding on my UI widgets. So these GTK tweaks reduce them wherever possible. They should be compatible with most themes.

There's also stuff here to remove the shadows drawn by CSD, so that your compositor can draw them instead.

### /mozilla

CSS for Mozilla userChrome.css that do the same thing as my GTK customizations.

### /devilspie2

Devil's Pie 2 is a scriptable window management automation tool that uses Lua for scripting. I created a whole-ass program in one file to make it easier to define rules in others.

### /scripts

Scripts I've written to make certain things more convenient or solve unique problems. You may even find some use for scripts here! This is definitely where the most interesting stuff is, IMO.

Shell scripts (for the most part) are restricted to POSIX sh and checked with Shellcheck. I adopted a philosophy that has made my life easier: "If you can't do it in POSIX, you need a real programming language." When it's Real Programming Language(tm) time, I like to go with Python 3. And if it's too unwieldy to organize well in a single file, well, then you end up with my other repos.

IMO, the most interesting scripts:

* auto-steam: A Steam wrapper that blocks until the game it's running is done. Also exits Steam automatically.
* ds4-lightbar: Command line utility for easily controlling the DualShock 4 light bar, and install udev rules to be able to do so as a regular user.
* focus-launch: Are you on a desktop environment without a dock? You can replicate that functionality with keyboard shortcuts and regular panel launchers with this script.
* music-watch: Output currently playing music info from MPRIS-enabled players using [playerctl](https://github.com/altdesktop/playerctl), so that it can be picked up by Conky, OBS Studio, and others.
* obsctl: A more convenient interface for using [obs-cli](https://github.com/leafac/obs-cli).
* termmie: maek yur trminals... temmie!!! yayA!!!!
* wait-for-it: Block until (dis)appearance of process, network, window, dbus interface, or an arbitrary amount of time, and optionally execute a command.
