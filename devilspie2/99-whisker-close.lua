-- Lowers conky when any window closes.
if win_name:is("Whisker Menu") then
    os.execute("conky-toggle below")
end
