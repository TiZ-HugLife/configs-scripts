-- Automatically presses enter on the Steam Play dialog. Requires xdotool.
-- Unfortunately, it doesn't seem to actually work! 😭

if win_name:is("Steam Play") and win_class:is("Steam") then
	debug_print("Executing Steam Play dialog skip.")
	os.execute("xdotool windowfocus " .. win_xid .. " sleep 3 key Return")
end
