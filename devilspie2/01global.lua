-- Rules common to all devices.
do_rules(
    --{app="Xfce Terminal", size={w=568, h=288}},
    --{app="Thunar", size={w=526, h=372}},
    {app="Xfce Terminal", alpha=0.80},
    {app="mirage", max=true},
    {app="emoji-keyboard", type="utility", undeco=true, alpha=0.80},
    {name="Whisker Menu", type="dialog", alpha=0.80},
    {class2="cava", alpha=0.20, stick=true, below=true, no_page=true, no_task=true},
    {app="visterm", alpha=0.20, stick=true, below=true, undeco=true, no_page=true, no_task=true},
    {name="Microsoft Teams Notification", stick=true, no_page=true, no_task=true}
)
