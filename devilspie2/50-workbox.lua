-- Rules specific to my work computer, which has two monitors.
-- To make sizing accurate, add window frames to w/h listed by wmctrl -G.
-- For Adapta, that's +4w, +27h.

if normal then
    -- Left monitor.
    if app_name:is("Evolution.bin") or win_class:is("Ferdi") or
     win_class:is("Caprine") or win_class:is("Discord") or
     win_class:is("MSTeams") then
        pos(0, 0)
        stick()
    elseif win_class:is("Spotify") then
        pos(0, 0)
        stick()
        maximize()
    end

    if app_name:is("Firefox") then workspace(2) end
    if app_name:is("Geany") then size(790, 1054); pos(3050, 26) end
    if app_name:is("Remmina") then size(620, 280) end
end
