-- Rules common to all devices.
-- The monitor detection file sets variables that enable lots of code reuse.

-- We can skip many checks by only paying attention to normal windows.
if normal then
    if spoofy then
        -- Spotify is the only app that uses a tertiary monitor.
        debug_print("  -- Handling spoofy.")
        maximize_in(tertiary)
        pin(secondary.pin); if not secondary.pin then workspace(1) end
    elseif firefox_first then
        -- Firefox is kinda dumb about its own placement.
        debug_print("  -- Handling Firefox.")
        os.execute("sleep 0.1")
        maximize_in(main)
        pin(false); workspace(1)
    elseif persistent_primary then
        debug_print("  -- Handling workspace 1 window.")
        maximize_in(main, firefox and 0.2 or 0.0)
        pin(false); workspace(1)
    elseif persistent_secondary then
        debug_print("  -- Handling monitor 2 window.")
        maximize_in(secondary)
        pin(secondary.pin); if not secondary.pin then workspace(1) end
    elseif app_name:is("Geany") then
        debug_print("  -- Handling Geany.")
        win_width = 880
        geom(main.r - win_width + 1, main.t, win_width, main.b - main.t)
    elseif app_name:is("KWrite") then
        debug_print("  -- Handling KWrite.")
        win_width = 990
        geom2(main.r - win_width + 1, main.t, win_width, main.b - main.t)
    elseif app_name:is("Gitg") then
        debug_print("  -- Handling gitg.")
        geom(main.l, main.t, 1130, main.h)
    elseif win_class:is("KWeather") then
        debug_print("  -- Handling KWeather.")
        -- We can make KWeather into a pseudo-popup for the weather widget.
        win_width = 660
        geom(main.l, main.b - win_width, win_width, win_width)
        make_always_on_top()
    elseif win_class:is("Pegasus-Frontend") then
        -- Keep Pegasus on the main screen.
        debug_print("  -- Handling Pegasus.")
        os.execute("wmctrl -i -r "..win_xid.." -b remove,fullscreen")
        pos(main.l, main.t)
        --os.execute("wmctrl -i -r "..win_xid.." -e 0,"..main.l..","..main.t..",-1,-1")
        os.execute("wmctrl -i -r "..win_xid.." -b add,fullscreen")
    elseif app_name:is("obs") or win_class:has("cookieclicker") then
        -- OBS does not change workspaces, but it does go on the second monitor.
        debug_print("  -- Handling OBS.")
        maximize_in(secondary, 0.1)
    --elseif not persistent_secondary then move_to_main()
    end

    -- Minimize Electron apps at session start.
    if (electron or win_class:is("Joplin") or win_class:has("Trilium"))
     and is_session_starting() then
        debug_print("  -- Minimizing Electron startup app.")
        minimize()
    end
elseif dialog then
    if app_name:is("Gitg") and win_name:is("Commit") then size(840,500) end
end
