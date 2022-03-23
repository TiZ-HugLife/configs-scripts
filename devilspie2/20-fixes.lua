-- Fixes for apps that behave badly.

-- Fix MSTeams.
if win_class:is("Microsoft Teams - Preview") then set_class("MSTeams") end
if win_class:is("MSTeams") then set_icon("msteams") end

-- Fix fucking Spotify.
if (win_name == "Untitled window" and win_class:is("")) then
    -- Let's find out if Spotify just started.
    handle = io.popen("pgrep -o spotify")
    proc = "/proc/"..handle:read()
    handle:close()
    handle = io.popen("stat -c%X "..proc)
    stat = handle:read()
    handle:close()
    if (os.time() - stat) < 5 then
        debug_print("  !! This new window is almost certainly Spoofy.")
        set_class("Spotify")
    end
end
if app_name == "Spotify" then set_class("Spotify") end

-- Fix Spotify's icon too.
if win_class:is("Spotify") then set_icon("spotify") end

-- Stop startup apps from demanding attention on open.
if win_class:is("Ferdi") or win_class:is("MSTeams") or
 win_class:is("Caprine") or win_class:is("Discord") or
 win_class:is("Spotify") or app_name:is("Evolution.bin") or
 win_class:is("Joplin") or (app_name:is("Firefox") and is_nth(1)) then
    debug_print("  -- Invoking STFU on problematic app: " .. app_name)
    os.execute("/home/tiz/xdg/config/devilspie2/stfu.sh " .. win_xid)
end

-- Hide ultracompact windows that CudaText makes on file open.
if win_class:is("CudaText") and win_w <= 80 and win_h <= 48 then
  debug_print(" -- Gonna try to hide this.")
  os.execute("sh -c 'xprop -id " .. win_xid .. " > /tmp/cuda-tiny-window-xprop.txt 2>&1'")
  alpha(0); minimize(); set_skip_tasklist(true); set_skip_pager(true)
end
