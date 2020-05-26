# Proper title case, removes features, editions, and remasters.
s/[a-z,&] (The|A|An|And|But|For|Nor|To|As|Of|On|At|In|By) /\L&/g
s/[a-z,&] (The|A|An|And|But|For|Nor|To|As|Of|On|At|In|By) /\L&/g
s/ [[(](feat\.|featuring) .+[])]//i
s/ [[(].* edition.*[])]//i
s/ [[(].*remastered.*[])]//i
s/ [[(]deluxe.*[])]//i
s/[[(](Original|Official) .*Sound ?track[])]/OST/i
s/(Original|Official) .*Sound ?track/OST/i
s/Sound ?track/OST/i
