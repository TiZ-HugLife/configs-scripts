-- Rules common to all devices.
-- To make sizing accurate, add window frames to w/h listed by wmctrl -G.
-- For Adapta, that's +4w, +27h.

if (app_name:is("Xfce Terminal") and normal) or
 (win_name:is("Whisker Menu") and dialog) then
    alpha(0.80)
end

if app_name:is("Thunar") then
    if win_name:is("File Operation Progress") then
        size(320, 120)
    elseif normal then
        size(408, 522)
    end
end

if app_name:is("Gitg") then
    if win_name:is("Commit") then size(840, 500)
    elseif normal then size(1130, 1054) end
end

-- Stop Discord and Firefox from demanding attention on open.
if win_class:is("Discord") or win_class:is("Firefox") then
    os.execute("/home/tiz/xdg/sync/devilspie2/stfu.sh " .. win_xid)
end

if app_name:is("Syncthing-GTK") and normal then size(660, 500) end
if win_class:is("Microsoft Teams - Preview") then set_class("MSTeams") end
if win_class:is("MSTeams") then set_icon("msteams") end

-- Fix fucking Spotify.
if win_name == "Untitled window" and app_name == "Untitled window" then
    -- Let's find out if Spotify just started.
    handle = io.popen("pgrep -o spotify")
    proc = "/proc/"..handle:read()
    handle:close()
    handle = io.popen("stat -c%X "..proc)
    stat = handle:read()
    handle:close()
    if (os.time() - stat) < 3 then
        debug_print("Spotify just started; this window likely belongs to it.")
        set_class("Spotify")
    end
end
