-- Rules specific to my work computer, which has two monitors.
do_rules(
    --{app="Xfce Terminal", size={w=702, h=471}},
    --{app="Thunar", size={w=500, h=471}},
    {app="Thunar", size={w=404, h=523}},
    {app="Thunar", name="File Operation Progress", size={w=320, h=120}},
    --{app="geany", size={w=702, h=929}},
    {app="geany", size={w=790, h=1054}, pos={x=3136, y=26}},
    {app="syncthing-gtk", size={w=660, h=500}},
    {app="gigolo", size={w=320, h=160}},
    {app="Firefox", wksp=2, nth=1},
    {app="Remmina", size={w=611, h=280}},
    --{app="Quod Libet", nth=1, pos={x=0, y=0}, stick=true, max=true},
    {class="Ferdi", pos={x=0, y=0}, stick=true, max=true},
    {app="Spotify", nth=1, pos={x=0, y=0}, stick=true, max=true},
    {app="Evolution.bin", nth=1, pos={x=0, y=0}, max=true},
    {app="Evolution.bin", stick=true},
    {class="teams-for-linux", pos={x=0, y=0}, stick=true, max=true},
    {class="Microsoft Teams - Preview", pos={x=0, y=0}, stick=true, max=true},
    {class="discord", pos={x=0, y=0}, stick=true, max=true}
)
