-- Raises conky when Whisker opens.
if get_window_class() == "Quodlibet" then
    os.execute("conky -c /home/trent/.conky/QLInfo/conkyrc-`hostname` &")
    os.execute("conky -c /home/trent/.conky/QLInfo/conkyrc-cover-`hostname` &")
end
