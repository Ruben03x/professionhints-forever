# Profession Hints Forever

Hover over your skill bar in WoW Forever's Professions overview or in its crafting window. You'll see the next skill target and a recommended craft or gathering spot. The addon covers all 12 professions from 1 to 300.

## Install

Extract the `ProfessionHintsForever` folder into `World of Warcraft/_forever_/Interface/AddOns`, so `ProfessionHintsForever.toc` is directly inside the addon folder. Enable **Profession Hints Forever** in WoW and open Professions.

Mining shows a node, a skill target, and up to three zones. When smelting can grant skill, you also see a recommended bar to make and its own target. Smelt Iron can take you to 140, then mine to 155 to learn Smelt Gold. Gold can take you to 185. Switch back to mining for regular skill-ups from 185. Smelting targets are recommendations and can require multiple crafts per point.

Herbalism, Skinning, and Fishing show what to gather, your next skill target, and nearby zones. At a skill cap, the tooltip gives a trainer, book vendor, or quest destination for your faction and includes the district or settlement where available.

Crafting shows a recommended recipe and an alternative where available. In your crafting window, the addon flags a recipe when the game reports that you haven't learned it. The tooltip uses a verified location or the game's own source text when available. It checks recipe status by name against the bundled English route.

## Zone order

Gathering tooltips sort suitable zones nearest first using straight-line distance to the zone center. Your current zone comes first if it fits the bracket. Zones on other continents or without coordinates follow the measurable ones in bundled order. If your position is unavailable, the tooltip uses the bundled order.

## Data sources

Trainer and recipe sources checked on November 25, 2026 against WoW Forever 1.60.1.71091 data and guides. The recommendations and destination hints live in `Routes.lua`. Zone and city names use the in-game map labels with bundled English fallbacks.

- Mining brackets and zone ordering draw from [Wowhead's Forever Mining guide](https://www.wowhead.com/forever/guide/professions/mining/overview-leveling), [its Iron Deposit data](https://www.wowhead.com/forever/object=1735/iron-deposit), and [Method's Forever zone guide](https://www.method.gg/wow-forever/mining-and-ore-farming-routes-in-wow-forever-best-mithril-thorium-and-heavy-thorium-farming-routes). Smelting targets follow Wowhead and [Method's Mining leveling guide](https://www.method.gg/wow-forever/mining-in-wow-forever-leveling-guide-mining-items-enchants-trainers).
- The Herbalism, Skinning, Fishing, and early crafting recommendations draw from [Icy Veins' Forever profession guides](https://www.icy-veins.com/wow-forever/). First Aid uses [Wowhead's bandage route](https://www.wowhead.com/forever/guide/professions/first-aid/overview).
- [ForeverArtisan's leveling guides](https://foreverartisan.app/guides/) cover Engineering and supplement Alchemy, Leatherworking, and Tailoring after 225. [Hardcore Helper's Forever guides](https://www.hardcorehelper.com/forever/guides) cover Enchanting and the end of Blacksmithing.
- Rank destinations draw from [WoW Professions' Forever trainer guides](https://www.wow-professions.com/forever), [Warcraft Tavern's Forever trainer guide](https://www.warcrafttavern.com/forever/guides/profession-trainers/), and [Wowhead's Forever Fishing guide](https://www.wowhead.com/forever/guide/professions/fishing/overview-leveling).
- Recipe destinations draw from Forever entry data at [Bind on Forever](https://bindonforever.com/professions), [ForeverDB](https://www.foreverdb.app/), and [Azeroth Wiki](https://azeroth.wiki/forever/).
