-- Lowers conky when any window closes.
if get_window_name() == "Whisker Menu" then
    os.execute("conky-toggle below")
end
