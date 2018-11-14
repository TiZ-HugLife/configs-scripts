-- Rules common to all devices.
do_rules(
    --{app="Xfce Terminal", size={w=568, h=288}},
    --{app="Thunar", size={w=526, h=372}},
    {app="Xfce Terminal", alpha=0.80},
    {app="Thunar", size={w=414, h=413}},
    {app="Thunar", name="File Operation Progress", size={w=300, h=105}},
    {app="geany", size={w=622, h=413}},
    {app="syncthing-gtk", size={w=550, h=400}},
    {app="gigolo", size={w=320, h=160}},
    {app="mirage", max=true},
    {app="emoji-keyboard", type="utility", undeco=true, alpha=0.80},
    {app="Quod Libet", alpha=0.80},
    {app="Thunderbird", role="3pane", max=true, alpha=0.80},
    {name="Skidata Head Unit", max=true},
    {name="Whisker Menu", type="dialog", alpha=0.88, size={w=350, h=380}},
    {class2="cava", alpha=0.20, stick=true, below=true, no_page=true, no_task=true},
    {app="visterm", alpha=0.20, stick=true, below=true, undeco=true, no_page=true, no_task=true}
)
