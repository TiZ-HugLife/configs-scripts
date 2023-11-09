-- Fixes for apps that behave badly.

-- Fix MSTeams.
if win_class:is("Microsoft Teams - Preview") then set_class("MSTeams") end
if win_class:is("MSTeams") then set_icon("msteams") end

-- Fix Trilium.
if win_class:has("Trilium") then set_class("Trilium") end

-- Fix fucking Spotify.
if (win_name == "Untitled window" and win_class:is("")) then
    -- Let's find out if Spotify just started.
    handle = io.popen("pgrep -o spotify")
    proc = "/proc/"..handle:read()
    handle:close()
    handle = io.popen("stat -c%X "..proc)
    stat = handle:read()
    handle:close()
    if (os.time() - stat) < 5 then
        debug_print("  !! This new window is almost certainly Spoofy.")
        set_class("Spotify")
    end
end
if app_name == "Spotify" then set_class("Spotify") end

-- Fix Spotify's icon too.
if win_class:is("Spotify") then set_icon("spotify") end
