-- Make simple matches easier to read and write with extra functions.

-- Let's avoid defining these functions on every single run.
if not functions_defined then
    debug_print(" *** Defining helper functions.")
    string_meta = getmetatable("")

    -- Case insensitive string comparison.
    string_meta.__index["is"] = function (strA, strB)
        return strA:lower() == strB:lower()
    end

    -- Case insensitive string search.
    string_meta.__index["has"] = function (strA, strB)
        return strA:lower():find(strB:lower()) ~= nil
    end

    -- Shortcut functions.
    function set_type (target)
        set_window_type("WINDOW_TYPE_"..target:upper())
    end
    function type_is (target)
        return "WINDOW_TYPE_"..string.upper(target) == get_window_type()
    end

    -- Check if window is nth of its type.
    function is_nth (n)
        local count = 0
        local find = class_instance .. "." .. win_class
        local handle = io.popen("wmctrl -lx | awk '{print $3}'")
        local result = handle:read("*a")
        handle:close()
        for line in result:gmatch('[^\r\n]+') do
            if line:is(find) then count = count + 1 end
        end
        return count == n
    end

    -- Modify window class.
    function set_class (class)
        win_class = class
        class_inst = class
        os.execute("xdotool set_window " ..
         "--class " .. class .. " --classname " .. class .. " " .. win_xid)
    end

    -- Change window icon to a .png file located in /xusr/share/icons.
    function set_icon (icon)
       os.execute("xseticon -id " .. win_xid ..
        " /xusr/share/icons/" .. icon .. ".png")
    end

    -- Define a geometry table.
    function geometry (left, top, right, bottom, pin)
        -- Nothing actually uses this calculation.
        --width = right - left; height = bottom - top
        return {
            l = left, t = top,
            r = right, b = bottom,
            --w = width, h = height,
            pin = pin
        }
    end

    -- Just make sure they exist to start with.
    -- The _true ones are for the monitors without the panels so that
    -- new windows can be moved off of the second monitor initially.
    main = geometry(0, 0, 1920, 1080)
    main_true = main
    secondary = main
    secondary_true = main

    -- Change window's location and remaximize it.
    -- Useful for moving windows between displays.
    function maximize_at (x, y, delay)
        unmaximize()
        if delay then os.execute("sleep 0.1") end
        pos(x, y)
        if delay then os.execute("sleep 0.1") end
        maximize()
    end

    -- To pin or not to pin?
    function pin (value)
        if value then pin_window() else unpin_window() end
    end

    -- Create an aspect-adjusted fullscreen window.
    -- Not friendly to multiple monitors, unfortunately.
    function fswin (aspect)
        if aspect ~= "" then
            debug_print("Forcing fsw aspect ratio to " .. aspect)
            if aspect == "4:3" then
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

    -- Handy function aliases.
    pos = set_window_position2
    size = set_window_size
    workspace = set_window_workspace
    alpha = set_window_opacity
    viewport = set_viewport
    skip_task = set_skip_tasklist
    skip_pager = set_skip_pager
    above = set_window_above
    below = set_window_below
    undecorate = undecorate_window

    -- Aaaand done!
    functions_defined = true
    debug_print(" *** Helper functions defined."); debug_print("");
end

-- Create handy vars to reference in each script.
win_xid = get_window_xid()
win_name = (get_window_name() or "")
app_name = (get_application_name() or "")
win_class = (get_window_class() or "")
class_instance = (get_class_instance_name() or "")
win_role = (get_window_role() or "")
win_x, win_y, win_w, win_h = get_window_geometry()
new_screen_w, new_screen_h = get_screen_geometry()
normal = type_is("normal")
dialog = type_is("dialog")

-- Check if screen geometry changed so that geometry updates can take place.
if new_screen_w ~= screen_w or new_screen_h ~= screen_h then
    debug_print(" *** Screens changed since last run.")
    screens_changed = true
    screen_w = new_screen_w
    screen_h = new_screen_h
else screens_changed = false
end

-- Debug info.
debug_print("==== New window: ====")
debug_print("Window ID: " .. win_xid)
debug_print("Name: " .. win_name)
debug_print("App: " .. app_name)
debug_print("Class: " .. win_class)
debug_print("Class Inst.: " .. class_instance)
debug_print("Role: " .. win_role)
debug_print("Location: " .. win_x .. ", " .. win_y)
debug_print("Geometry: " .. win_w .. " x " .. win_h)
