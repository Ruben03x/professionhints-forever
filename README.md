# Profession Hints Forever

Hover over your skill bar in WoW Forever's Professions overview or in its crafting window. You'll see the next skill target and a recommended craft or gathering spot. The addon covers all 12 professions from 1 to 300.

## Install

Extract the `ProfessionHintsForever` folder into `World of Warcraft/_forever_/Interface/AddOns`, so `ProfessionHintsForever.toc` is directly inside the addon folder. Enable **Profession Hints Forever** in WoW and open Professions.

Mining shows a node, a skill target, and up to three zones. When smelting can grant skill, you also see a recommended bar to make and its own target. Smelt Iron can take you to 140, then mine to 155 to learn Smelt Gold. Gold can take you to 185. Switch back to mining for regular skill-ups from 185. Smelting targets are recommendations and can require multiple crafts per point.

Herbalism, Skinning, and Fishing show guide-recommended gathering spots. Crafting shows one recommendation with a short alternative where available. The tips use base skill, and reaching a training cap shows how to unlock the next rank.

## Zone order

Gathering tooltips sort suitable zones nearest first using straight-line distance to the zone center. Your current zone comes first if it fits the bracket. Zones on other continents or without coordinates follow the measurable ones in bundled order. If your position is unavailable, the tooltip uses the bundled order.

## Data sources

Snapshot checked on November 25, 2026. The short recommendations live in `Routes.lua`. Update that file when Forever changes professions or a recommendation needs correcting.

- Mining brackets and zone ordering draw from [Wowhead's Forever Mining guide](https://www.wowhead.com/forever/guide/professions/mining/overview-leveling), [its Iron Deposit data](https://www.wowhead.com/forever/object=1735/iron-deposit), and [Method's Forever zone guide](https://www.method.gg/wow-forever/mining-and-ore-farming-routes-in-wow-forever-best-mithril-thorium-and-heavy-thorium-farming-routes). Smelting targets follow Wowhead and [Method's Mining leveling guide](https://www.method.gg/wow-forever/mining-in-wow-forever-leveling-guide-mining-items-enchants-trainers).
- The Herbalism, Skinning, Fishing, and early crafting recommendations draw from [Icy Veins' Forever profession guides](https://www.icy-veins.com/wow-forever/). First Aid uses [Wowhead's bandage route](https://www.wowhead.com/forever/guide/professions/first-aid/overview).
- [ForeverArtisan's leveling guides](https://foreverartisan.app/guides/) cover Engineering and supplement Alchemy, Leatherworking, and Tailoring after 225. [Hardcore Helper's Forever guides](https://www.hardcorehelper.com/forever/guides) cover Enchanting and the end of Blacksmithing.
