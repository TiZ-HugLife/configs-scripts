--[[ All-in one config script for simple matches.
do_rules(
    {app="etc", max="true", ...},
    {class="etc", size={w=500, h=500}, ...},
    ...
)

MATCH CRITERIA
app = application name
class = window class
role = window role
name = title bar contents
min_width = window width is this or higher
min_height = window height is this or higher
type = window type, specified without the WINDOW_TYPE_ prefix and whatever case
       you want. if nil, assumed to be normal. if *, all types.
exc_name = exclude window name
exc_type = exclude window type
onlyfirst = only act on the first window matching the other criteria to open

ACTION CRITERIA
alpha = window opacity
pos = a table with fields x and y for the desired position
size = a table with fields w and h for the desired size
wksp = target workspace starting from 1
vport = target viewport starting from 1
no_task = hide from tasklist
no_page = hide from pager
set_type = change the window's type. see type above.
set_class = change the window's class.
top, bottom, shade, max, min, undeco, stick, pin = do these to the window.
fswin = borderless fullscreen window. aspect scales window to fill screen.
run = run script on window with args followed by window id.
]]

win_name = (get_window_name() or "")
app_name = (get_application_name() or "")
win_class = (get_window_class() or "")
class_instance = (get_class_instance_name() or "")
win_role = (get_window_role() or "")
win_x, win_y, win_w, win_h = get_window_client_geometry()

debug_print("Name: " .. win_name)
debug_print("App: " .. app_name)
debug_print("Class: " .. win_class)
debug_print("Class2: " .. class_instance)
debug_print("Role: " .. win_role)
debug_print("Location: " .. win_x .. ", " .. win_y)
debug_print("Geometry: " .. win_w .. " x " .. win_h)
debug_print("Command: " .. get_window_property("WM_COMMAND"))
debug_print("----------------")

function do_rules (...)
    _, _, win_w, win_h = get_window_client_geometry()
    for _, v in ipairs(arg) do
        if
            (not v.app or v.app:lower() == app_name:lower()) and
            (not v.class or v.class:lower() == win_class:lower()) and
            (not v.class2 or v.class2:lower() == class_instance:lower()) and
            (not v.role or get_window_role():match(v.role)) and
            (not v.name or get_window_name():match(v.name)) and
            (not v.min_width or v.min_width >= win_w) and
            (not v.min_height or v.min_height >= win_h) and
            (not v.exc_name or v.exc_name ~= get_window_name()) and
            (v.type == "*" or
                "WINDOW_TYPE_"..string.upper(v.type or "normal") ==
                get_window_type()) and
            (not v.exc_type or "WINDOW_TYPE_"..string.upper(v.exc_type) ~=
                get_window_type()) and
            (not v.nth or is_nth(v))
        then
            debug_print("Window matched!")
            if v.pos then set_window_position2(v.pos.x, v.pos.y) end
            if v.size then set_window_size(v.size.w, v.size.h) end
            if v.alpha then set_opacity(v.alpha) end
            if v.wksp then
                --change_workspace(v.wksp)
                set_window_workspace(v.wksp)
            end
            if v.vport then set_viewport(v.vport) end
            if v.no_task then set_skip_tasklist(true) end
            if v.no_page then set_skip_pager(true) end
            if v.top then make_always_on_top() end
            if v.above then set_window_above() end
            if v.below then set_window_below() end
            if v.shade then shade() end
            if v.max then maximize() end
            if v.min then minimize() end
            if v.undeco then undecorate_window() end
            if v.pin then pin_window() end
            if v.stick then stick_window() end
            if v.set_type then
                set_window_type("WINDOW_TYPE_"..string.upper(v.set_type))
            end
            --if v.set_class then
                --set_window_property("WM_CLASS", v.set_class)
            --end
            if v.run then
                os.execute(v.run .. " " .. get_window_xid())
            end
            if v.fswin then
                screen_w, screen_h = get_screen_geometry()
                if v.fsw_aspect ~= "" then
                    debug_print("Forcing fsw aspect ratio to " .. v.fsw_aspect)
                    if v.fsw_aspect == "4:3" then
                        new_w = screen_h * 4 / 3
                        new_x = (screen_w - new_w) / 2
                        new_h, new_y = screen_h, 0
                    end
                elseif win_w / win_h <= (screen_w / screen_h) then
                    new_w = (screen_h / win_h) * win_w
                    new_h = screen_h
                    new_x = (screen_w - new_w) / 2
                    new_y = 0
                else
                    new_w = screen_w
                    new_h = new_w / (win_w / win_h)
                    new_x = 0
                    new_y = (screen_h - new_h) / 2
                end
                undecorate_window()
                set_window_geometry2(new_x, new_y, new_w, new_h)
            end
        end
    end
end

function is_nth (v)
    local count = 0
    local class = v.class or ".+"
    local app = v.app or ".+"
    local name = v.name or ".+"
    local find = class .. "%." .. app .. "\t" .. name
    local handle = io.popen("wmctrl -lx | awk '{print $3 \"\t\" $4}'")
    local result = handle:read("*a")
    handle:close()
    for line in result:gmatch('[^\r\n]+') do
        if line:find(find) then count = count + 1 end
    end
    return count == v.nth
end
