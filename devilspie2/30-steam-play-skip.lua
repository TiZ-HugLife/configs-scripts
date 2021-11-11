-- Automatically presses enter on the Steam Play dialog.
-- Requires xdotool.

if win_name:is("Steam Play") and win_class:is("Steam") then
	os.execute("xdotool sleep 3 key --window " .. win_xid .. " Return")
end
