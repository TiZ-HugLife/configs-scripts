-- Actions to run on window open.
do_rules(
    {app="Thunderbird", type="dialog", class2="calendar",
     name="Select Calendar", run="autowin tbird_calendar"},
    {app="Thunderbird", type="dialog", class2="dialog",
     name="How do you want to react?", run="autowin tbird_react"},
    {app="Thunderbird", type="dialog", role="Attendees", class2="calendar",
     name="Invite Attendees", run="autowin tbird_invite"}
)
