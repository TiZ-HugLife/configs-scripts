-- Rules specific to my work computer, which always has two monitors.

if screens_changed then
	main = geometry(1960, 0, 3840, 1080, false)
	main_true = geometry(1920, 0, 3840, 1080, false)
	secondary = geometry(0, 0, 1920, 1080, true)
	secondary_true = secondary
end

if normal and app_name:is("Remmina") then workspace(1) end
