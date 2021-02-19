-- Rules specific to my work computer, which has two monitors.
-- To make sizing accurate, add window frames to w/h listed by wmctrl -G.
-- For Adapta, that's +4w, +27h.

-- Left monitor.
if app_name:is("Evolution.bin") or win_class:is("Ferdi") or
 win_class:is("Caprine") or win_class:is("Discord") or
 win_class:is("Microsoft Teams - Preview") then
    pos(0, 0)
    stick()
elseif app_name:is("Spotify") then
    pos(0, 0)
    stick()
    maximize()
end

if app_name:is("Firefox") then wksp(2) end
if app_name:is("Geany") then size(790, 1054); pos(1130, 26) end
if app_name:is("Remmina") then size(620, 280) end

--do_rules(
    --{app="Xfce Terminal", size={w=702, h=471}},
    --{app="Thunar", size={w=500, h=471}},
    ---{app="Thunar", size={w=404, h=523}},
    ---{app="Thunar", name="File Operation Progress", size={w=320, h=120}},
    --{app="geany", size={w=702, h=929}},
    ---{app="geany", size={w=790, h=1054}, pos={x=3050, y=26}},
    ---{app="syncthing-gtk", size={w=660, h=500}},
    --{app="gigolo", size={w=320, h=160}},
    ---{app="Firefox", wksp=2, nth=1},
    ---{app="Remmina", size={w=611, h=280}},
    --{app="Quod Libet", nth=1, pos={x=0, y=0}, stick=true, max=true},
    ---{class="Ferdi", pos={x=0, y=0}, stick=true, max=true},
    ---{class="caprine", pos={x=0, y=0}, stick=true},
    ---{app="Spotify", nth=1, pos={x=0, y=0}, stick=true, max=true},
    ---{app="Evolution.bin", nth=1, pos={x=0, y=0}, max=true},
    ---{app="Evolution.bin", stick=true},
    ---{class="teams-for-linux", pos={x=0, y=0}, stick=true, max=true},
    ---{class="Microsoft Teams - Preview", pos={x=0, y=0}, stick=true, max=true},
    ---{class="discord", pos={x=0, y=0}, stick=true, max=true}
--)
