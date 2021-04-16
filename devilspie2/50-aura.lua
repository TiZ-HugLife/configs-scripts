-- Rules specific to Aura.
-- To make sizing accurate, add window frames to w/h listed by wmctrl -G.
-- For Adapta, that's +4w, +27h.

-- Get current mode.
modefile = io.open("/run/user/1000/mode")
if modefile ~= nil then
    mode = modefile:read()
    modefile:close()
else
    mode = "laptop"
end

if win_class:is("Pegasus-Frontend") then
    os.execute("wmctrl -i -r "..win_xid.." -b remove,fullscreen")
    os.execute("wmctrl -i -r "..win_xid.." -e 0,0,0,-1,-1")
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

    -- Mode-specific rules.
    if mode:is("homedesk") then
        if app_name:is("obs") or app_name:is("Spotify") or
         win_class:is("Discord") or win_class:is("Caprine") or
         win_class:is("Ferdi")
         then
            unmaximize()
            set_window_position(0, 1106)
            maximize()
            stick_window()
            pin_window()
        end
    end
end
