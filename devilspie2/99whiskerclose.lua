-- Lowers conky when any window closes.
if get_class_instance_name() == "wrapper-1.0" then
    os.execute("conkytoggle below")
end
