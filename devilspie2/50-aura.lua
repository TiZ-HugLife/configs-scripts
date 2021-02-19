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

if app_name:is("Geany") then size(790, 1054); pos(1130, 26) end

-- Workspace placements.
if app_name:is("Evolution.bin") or win_class:is("Ferdi") or
 win_class:is("Caprine") or win_class:is("Discord") or
 win_class:is("Microsoft Teams - Preview") then
    wksp(1)
elseif app_name:is("Spotify") then
    wksp(2)
    maximize()
elseif app_name:is("Firefox") then
    wksp(2)
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


--do_rules(
    --{class2="cava", alpha=0.15, stick=true, no_task=true, no_page=true, pos={x=0, y=362}},
    --{app="Xfce Terminal", size={w=702, h=471}},
    --{app="Thunar", size={w=500, h=471}},
    ---{app="Thunar", size={w=404, h=523}},
    ---{app="Thunar", name="File Operation Progress", size={w=320, h=120}},
    --{app="geany", size={w=702, h=929}},
    ---{app="geany", size={w=790, h=1054}, pos={x=1130, y=26}},
    ---{app="syncthing-gtk", size={w=660, h=500}},
    --{app="gigolo", size={w=320, h=160}},
    ---{app="emoji-keyboard", type="utility", undeco=true, alpha=0.80,
    ---    pos={x=745, y=890}, size={w=430, h=190}},
    --{name="Whisker Menu", type="dialog", size={w=420, h=480}},
    --{app="Quod Libet", wksp=4, alpha=0.80},
    ---{app="pegasus-frontend", run="xdotool mousemove 9999 9999"},
-- Specific Workspaces
    ---{app="Evolution.bin", wksp=1},
    ---{class="Ferdi", wksp=1, max=true},
    ---{class="Caprine", wksp=1},
    ---{class="discord", wksp=1},
    ---{app="Spotify", wksp=2, max=true},
    ---{app="Firefox", wksp=2},
    ---{class="Microsoft Teams - Preview", wksp=1},
    --{name="Microsoft Teams Notification", stick=true, no_page=true, no_task=true},
--    {}
--)
