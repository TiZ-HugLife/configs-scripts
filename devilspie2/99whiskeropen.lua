-- Raises conky when Whisker opens.
if get_window_name() == "Whisker Menu" then
    os.execute("conky-toggle above")
end
