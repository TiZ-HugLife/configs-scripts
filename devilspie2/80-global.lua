-- Rules common to all devices.
-- Device-specific files set variables that enable lots of code reuse.

-- We can skip many checks by only paying attention to normal windows.
if normal then
    -- Apps that go to workspace 1 on the primary monitor.
    firefox = app_name:is("Firefox")
    persistent_primary = (firefox and is_nth(1)) or
     (mail_and_notes_on_primary and
        (app_name:is("Evolution.bin") or win_class:is("Joplin")))

    -- Separate out Electron detection for additional handling.
    electron = win_class:is("Ferdi") or win_class:is("MSTeams") or
     win_class:is("Caprine") or win_class:is("Discord") or
     win_class:is("Spotify")

    -- Apps that will go on the second monitor if it exists, else wksp 1.
    persistent_secondary = electron or
     (not mail_and_notes_on_primary and
        (app_name:is("Evolution.bin") or win_class:is("Joplin")))

    if persistent_primary then
        debug_print("  -- Handling workspace 1 window.")
        maximize_at(main.l, main.t, firefox)
        pin(false); workspace(1)
    elseif persistent_secondary then
        debug_print("  -- Handling monitor 2 window.")
        maximize_at(secondary.l, secondary.t)
        pin(secondary.pin); if not secondary.pin then workspace(1) end
    elseif app_name:is("Geany") then
        win_width = 880
        xywh(main.r - win_width + 1, main.t, win_width, main.b - main.t)
    elseif app_name:is("Gitg") then
        xywh(main.l, main.t, 1130, main.h)
    elseif win_class:is("KWeather") then
        -- We can make KWeather into a pseudo-popup for the weather widget.
        win_width = 660
        xywh(main.l, main.b - win_width, win_width, win_width)
        make_always_on_top()
    elseif win_class:is("Pegasus-Frontend") then
        -- Keep Pegasus on the main screen.
        debug_print("  -- Handling Pegasus.")
        os.execute("wmctrl -i -r "..win_xid.." -b remove,fullscreen")
        os.execute("wmctrl -i -r "..win_xid.." -e 0,0,"..main.t..",-1,-1")
        os.execute("wmctrl -i -r "..win_xid.." -b add,fullscreen")
    elseif app_name:is("obs") or win_class:has("cookieclicker") then
        -- OBS does not change workspaces, but it does go on the second monitor.
        maximize_at(secondary.l, secondary.t, true)
    elseif not persistent_secondary and
     win_x >= secondary_true.l and win_x < secondary_true.r and
     win_y >= secondary_true.t and win_y < secondary_true.b then
        -- If it's not a persistent window but it appeared on the
        -- second monitor, then move it off of the second monitor.
        -- This is effectively a no-op when there's one monitor.
        win_x = win_x - secondary_true.l + main_true.l
        win_y = win_y - secondary_true.t + main_true.t
        set_window_position(win_x, win_y)
        unpin_window()
    end

    -- Minimize Electron apps at start.
    if electron or win_class:is("Joplin") then minimize() end
elseif dialog then
    if app_name:is("Gitg") and win_name:is("Commit") then size(840,500) end
end
