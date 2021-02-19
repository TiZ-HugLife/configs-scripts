-- Raises conky when Whisker opens.
if win_name:is("Whisker Menu") then
    os.execute("conky-toggle above")
end
