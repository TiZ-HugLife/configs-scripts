-- Rules specific to Stealth.
-- KWin has a powerful window rules facility, but it can't do any logic.

if screens_changed then
    -- A simple check to see if we're docked; looking for the second monitor.
    docked = screen_h > 1080
    if docked then
        debug_print("  -- Using docked geometries.")
        main = geometry(40, 1080, 1920, 2160, false)
        main_true = geometry(0, 1080, 1920, 2160, false)
        secondary = geometry(0, 0, 1920, 1080, true)
        secondary_true = secondary
    else
        debug_print("  -- Using undocked geometries.")
        main = geometry(40, 0, 1920, 1080, false)
        main_true = geometry(0, 0, 1920, 1080, false)
        secondary = main
        secondary_true = main_true
    end

    -- On my laptop, I like to keep Evolution and Joplin on my main monitor.
    mail_and_notes_on_primary = true
end
