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
        size(404, 523)
    end
end

-- Stop Discord and Firefox from demanding attention on open.
if win_class:is("Discord") or win_class:is("Firefox") then
    os.execute("/home/tiz/xdg/sync/devilspie2/stfu.sh " .. win_xid)
end

if app_name:is("Syncthing-GTK") and normal then size(660, 500) end
if win_class:is("Microsoft Teams - Preview") then set_class("MSTeams") end
if win_class:is("MSTeams") then set_icon("msteams") end
