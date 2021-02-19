-- Rules common to all devices.

if app_name:is("Xfce Terminal") or
 (win_name:is("Whisker Menu") and type_is("dialog")) then
    alpha(0.80)
end

if app_name:is("Thunar") then
    if win_name:is("File Operation Progress") then
        size(320, 120)
    else
        size(404, 523)
    end
end

if app_name:is("Syncthing-GTK") then size(660, 500) end
