-- Rules specific to Aura.
-- To make sizing accurate, add window frames to w/h listed by wmctrl -G.
-- For Adapta, that's +4w, +27h.
do_rules(
    --{class2="cava", alpha=0.15, stick=true, no_task=true, no_page=true, pos={x=0, y=362}},
    --{app="Xfce Terminal", size={w=702, h=471}},
    --{app="Thunar", size={w=500, h=471}},
    {app="Thunar", size={w=404, h=523}},
    {app="Thunar", name="File Operation Progress", size={w=320, h=120}},
    --{app="geany", size={w=702, h=929}},
    {app="geany", size={w=790, h=1054}, pos={x=1216, y=26}},
    {app="syncthing-gtk", size={w=660, h=500}},
    {app="gigolo", size={w=320, h=160}},
    {app="emoji-keyboard", type="utility", undeco=true, alpha=0.80,
        pos={x=745, y=890}, size={w=430, h=190}},
    --{name="Whisker Menu", type="dialog", size={w=420, h=480}},
    --{app="Quod Libet", wksp=4, alpha=0.80},
-- Specific Workspaces
    {app="Firefox", wksp=2},
    {class="Ferdi", wksp=1, max=true},
    {app="Evolution.bin", wksp=1},
    {app="Spotify", wksp=1, max=true}
    --{class="teams-for-linux", wksp=4},
    --{class="Microsoft Teams - Preview", wksp=4},
    --{name="Microsoft Teams Notification", stick=true, no_page=true, no_task=true},
)
