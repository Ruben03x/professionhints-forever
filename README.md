# Profession Hints Forever

Hover over your skill bar in WoW Forever's Professions overview or in its crafting window. You'll see the next skill target and a recommended craft or gathering spot. The addon covers all 12 professions from 1 to 300.

## Install

Extract the `ProfessionHintsForever` folder into `World of Warcraft/_forever_/Interface/AddOns`, so `ProfessionHintsForever.toc` is directly inside the addon folder. Enable **Profession Hints Forever** in WoW and open Professions.

Mining shows one main node for the current bracket with up to three zones, ordered by recorded spawn count. Herbalism, Skinning, and Fishing use guide-recommended spots. Crafting shows one recommendation with a short alternative where available. The suggestions use base skill, and a skill cap shows how to unlock the next rank.

## Nearby scores

By default, zone lists use the bundled order. Run `/profhints distance` to toggle nearby scores. Each score out of 10 is the average of:

- **Rank**. The recommended zones start at 10 points, dropping two points per place.
- **Proximity**. Your current zone gets 10 points. Elsewhere on the same continent, the score falls from 10 to 0 over 10,000 yards, measured in a straight line to the zone center. Other continents get 0 proximity points.

If map coordinates are unavailable, the tooltip uses the bundled order. This is an approximate distance score. Routes, travel time, and node availability vary.

## Data sources

Snapshot checked on November 25, 2026. The short recommendations live in `Routes.lua`. Update that file when Forever changes professions or a recommendation needs correcting.

- Mining brackets and zone ordering draw from [Wowhead's Forever Mining guide](https://www.wowhead.com/forever/guide/professions/mining/overview-leveling), [its Iron Deposit data](https://www.wowhead.com/forever/object=1735/iron-deposit), and [Method's Forever zone guide](https://www.method.gg/wow-forever/mining-and-ore-farming-routes-in-wow-forever-best-mithril-thorium-and-heavy-thorium-farming-routes).
- The Herbalism, Skinning, Fishing, and early crafting recommendations draw from [Icy Veins' Forever profession guides](https://www.icy-veins.com/wow-forever/). First Aid uses [Wowhead's bandage route](https://www.wowhead.com/forever/guide/professions/first-aid/overview).
- [ForeverArtisan's leveling guides](https://foreverartisan.app/guides/) cover Engineering and supplement Alchemy, Leatherworking, and Tailoring after 225. [Hardcore Helper's Forever guides](https://www.hardcorehelper.com/forever/guides) cover Enchanting and the end of Blacksmithing.
