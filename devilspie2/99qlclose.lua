-- Raises conky when Whisker opens.
if get_class_instance_name() == "quodlibet" then
    os.execute("xdotool search --name '^Quodlibet-Conky$' windowkill")
    os.execute("xdotool search --name '^Quodlibet-Conky-Cover$' windowkill")
end
