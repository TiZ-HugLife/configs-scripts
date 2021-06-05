-- Rules specific to Aura.
-- To make sizing accurate, add window frames to w/h listed by wmctrl -G.
-- For Adapta, that's +4w, +27h.

if win_class:is("Pegasus-Frontend") then
    if screen_w > 1920 then loc = 1920 else loc = 0 end
    os.execute("wmctrl -i -r "..win_xid.." -b remove,fullscreen")
    os.execute("wmctrl -i -r "..win_xid.." -e 0,"..loc..",0,-1,-1")
    os.execute("wmctrl -i -r "..win_xid.." -b add,fullscreen")
end

if normal then
    if app_name:is("Geany") then size(790, 1054); pos(1130, 26) end

    -- Workspace placements.
    if app_name:is("Evolution.bin") or win_class:is("Ferdi") or
     win_class:is("Caprine") or win_class:is("Discord") or
     win_class:is("MSTeams") or app_name:is("Firefox") then
        workspace(1)
    elseif win_class:is("Spotify") then
        workspace(1)
        maximize()
    end

    if app_name:is("obs") then
        if screen_h > 1080 then win_y = 1106 else win_y = 26 end
        unmaximize()
        os.execute("sleep 0.25")
        set_window_position(0, win_y)
        os.execute("sleep 0.25")
        maximize()
    end
    
    -- Mode-specific rules.
    if screen_h > 1080 then
        if win_class:is("Spotify") or win_class:is("Ferdi") or
         win_class:is("Discord") or win_class:is("Caprine") or
         win_class:is("cookieclicker-nativefier-3a34cc") or
         win_class:is("MSTeams")
         then
            unmaximize()
            set_window_position(0, 1106)
            win_y = 1106
            maximize()
        -- For some reason Firefox starts on second monitor. Move it back.
        elseif app_name:is("Firefox") and is_nth(1) then
            unmaximize()
            set_window_position(0, 26)
            win_y = 26
            maximize()
        end
    end
end

-- Any window that ends up on a non-laptop monitor should be sticky.
if win_x >= 1920 or win_y >= 1080 then
    stick_window()
    pin_window()
end
