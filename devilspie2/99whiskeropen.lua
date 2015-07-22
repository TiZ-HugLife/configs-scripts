-- Raises conky when Whisker opens.
if get_class_instance_name() == "wrapper-1.0" then
    os.execute("conkytoggle above")
end
