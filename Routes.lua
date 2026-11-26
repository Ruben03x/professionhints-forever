local _, addon = ...

-- WoW Forever UiMapIDs. Each gathering route lists its preferred zones first.
local durotar, mulgore, barrens = 1411, 1412, 1413
local arathi, badlands = 1417, 1418
local tirisfal, silverpine, western, eastern = 1420, 1421, 1422, 1423
local hillsbrad, hinterlands, dunMorogh = 1424, 1425, 1426
local searing, burning, elwynn = 1427, 1428, 1429
local duskwood, loch, redridge, stranglethorn = 1431, 1432, 1433, 1434
local wetlands, teldrassil, darkshore, ashenvale = 1437, 1438, 1439, 1440
local thousand, stonetalon, desolace = 1441, 1442, 1443
local feralas, dustwallow, tanaris, azshara = 1444, 1445, 1446, 1447
local felwood, ungoro, silithus, winterspring = 1448, 1449, 1451, 1452
local stormwind, orgrimmar, ironforge, thunderBluff, darnassus, undercity = 1453, 1454, 1455, 1456, 1457, 1458
local swampOfSorrows = 1435
local hyjal, zephras, riverglades = 2482, 2521, 2548

addon.zoneNames = {
    [durotar] = "Durotar", [mulgore] = "Mulgore", [barrens] = "The Barrens",
    [arathi] = "Arathi Highlands", [badlands] = "Badlands",
    [tirisfal] = "Tirisfal Glades", [silverpine] = "Silverpine Forest",
    [western] = "Western Plaguelands", [eastern] = "Eastern Plaguelands",
    [hillsbrad] = "Hillsbrad Foothills", [hinterlands] = "The Hinterlands", [dunMorogh] = "Dun Morogh",
    [searing] = "Searing Gorge", [burning] = "Burning Steppes", [elwynn] = "Elwynn Forest",
    [duskwood] = "Duskwood", [loch] = "Loch Modan", [redridge] = "Redridge Mountains",
    [stranglethorn] = "Stranglethorn Vale",
    [wetlands] = "Wetlands", [teldrassil] = "Teldrassil", [darkshore] = "Darkshore", [ashenvale] = "Ashenvale",
    [thousand] = "Thousand Needles", [stonetalon] = "Stonetalon Mountains", [desolace] = "Desolace",
    [feralas] = "Feralas", [dustwallow] = "Dustwallow Marsh", [tanaris] = "Tanaris", [azshara] = "Azshara",
    [felwood] = "Felwood", [ungoro] = "Un'Goro Crater", [silithus] = "Silithus", [winterspring] = "Winterspring",
    [stormwind] = "Stormwind City", [orgrimmar] = "Orgrimmar", [ironforge] = "Ironforge",
    [thunderBluff] = "Thunder Bluff", [darnassus] = "Darnassus", [undercity] = "Undercity",
    [swampOfSorrows] = "Swamp of Sorrows",
    [hyjal] = "Mount Hyjal", [zephras] = "Zephras Isle", [riverglades] = "Riverglades",
}

local startingZones = { zephras, elwynn, dunMorogh, teldrassil, durotar, mulgore, tirisfal }

local mageQuarter = { stormwind, "Mage Quarter" }
local oldTown = { stormwind, "Old Town" }
local theDrag = { orgrimmar, "The Drag" }
local bootyBay = { stranglethorn, "Booty Bay" }
local gadgetzan = { tanaris, "Gadgetzan" }
local theramore = { dustwallow, "Theramore Isle" }
local hammerfall = { arathi, "Hammerfall" }
local geofram = { ironforge, "The Great Forge", npc = "Geofram Bouldertoe" }
local springspindle = { ironforge, "Tinker Town", npc = "Springspindle Fizzlegear" }
local magnusFrostwake = {
    action = "Buy the plans from Magnus Frostwake", location = { western, "Caer Darrow" },
}
local firstAidManuals = {
    Alliance = { arathi, "Stromgarde Keep" }, Horde = { dustwallow, "Brackenwall Village" },
}
local firstAidTrainers = {
    Alliance = { stormwind, "Cathedral Square", npc = "Shaina Fuller" },
    Horde = { orgrimmar, "Valley of Spirits", npc = "Arnok" },
}
local cookingTrainers = {
    Alliance = { stormwind, "Old Town", npc = "Stephen Ryback" },
    Horde = { orgrimmar, "The Drag", npc = "Zamja" },
}

-- Destinations must teach the next rank. When listing several, put the default first.
addon.training = {
    [186] = { -- Mining
        allRanks = { locations = {
            Alliance = {
                { stormwind, "Dwarven District", npc = "Gelman Stonehand" },
                geofram,
                { loch, "Thelsamar", npc = "Brock Stoneseeker" },
            },
            Horde = {
                { orgrimmar, "Valley of Honor", npc = "Makaru" },
                { thunderBluff, npc = "Brek Stonehoof" },
                { undercity, "War Quarter", npc = "Brom Killian" },
            },
        } },
    },
    [182] = { -- Herbalism
        allRanks = { locations = {
            Alliance = {
                { stormwind, "Mage Quarter", npc = "Tannysa" },
                { ironforge, "The Great Forge", npc = "Reyna Stonebranch" },
                { darnassus, "The Temple Gardens", npc = "Firodren Mooncaller" },
            },
            Horde = {
                { orgrimmar, "The Drag", npc = "Jandi" },
                { thunderBluff, "Middle Rise", npc = "Komin Winterhoof" },
                { undercity, "The Apothecarium", npc = "Martha Alliestar" },
            },
        } },
    },
    [393] = { -- Skinning
        allRanks = { locations = {
            Alliance = {
                { stormwind, "Old Town", npc = "Maris Granger" },
                { ironforge, "The Great Forge", npc = "Balthus Stoneflayer" },
                { darnassus, "Craftsmen's Terrace", npc = "Eladriel" },
            },
            Horde = {
                { orgrimmar, "The Drag", npc = "Thuwd" },
                { thunderBluff, npc = "Mooranta" },
                { undercity, "Rogues' Quarter", npc = "Killian Hagey" },
            },
        } },
    },
    [171] = { -- Alchemy
        [75] = {
            Alliance = { stormwind, "Mage Quarter", npc = "Lilyssia Nightbreeze" },
            Horde = { orgrimmar, "The Drag", npc = "Yelmak" },
        },
        [150] = {
            Alliance = { darnassus, "Craftsmen's Terrace", npc = "Ainethil" },
            Horde = { undercity, "The Apothecarium", npc = "Doctor Herbert Halsey" },
        },
        [225] = {
            Alliance = { feralas, "Feathermoon Stronghold", npc = "Kylanna Windwhisper" },
            Horde = { swampOfSorrows, "Stonard", npc = "Rogvar" },
        },
    },
    [164] = { -- Blacksmithing
        [75] = {
            Alliance = { stormwind, "Dwarven District", npc = "Therum Deepforge" },
            Horde = { orgrimmar, "Valley of Honor", npc = "Snarl" },
        },
        [150] = {
            Alliance = { ironforge, "The Great Forge", npc = "Bengus Deepforge" },
            Horde = { orgrimmar, "Valley of Honor", npc = "Saru Steelfury" },
        },
        [225] = { location = { stranglethorn, "Booty Bay", npc = "Brikk Keencraft" } },
    },
    [333] = { -- Enchanting
        [75] = {
            Alliance = { stormwind, "The Canals", npc = "Lucan Cordell" },
            Horde = { orgrimmar, "The Drag", npc = "Godan" },
        },
        [150] = {
            Alliance = { elwynn, "Tower of Azora", npc = "Kitta Firewind" },
            Horde = { stonetalon, "Sun Rock Retreat", npc = "Hgarth" },
        },
        [225] = { location = { badlands, "Uldaman", npc = "Annora" } },
    },
    [202] = { -- Engineering
        [75] = {
            Alliance = { ironforge, "Tinker Town", npc = "Trixie Quikswitch" },
            Horde = { orgrimmar, "Valley of Honor", npc = "Nogg" },
        },
        [150] = {
            Alliance = springspindle,
            Horde = { orgrimmar, "Valley of Honor", npc = "Roxxik" },
        },
        [225] = { location = { tanaris, "Gadgetzan", npc = "Buzzek Bracketswing" } },
    },
    [165] = { -- Leatherworking
        [75] = {
            Alliance = { stormwind, "Old Town", npc = "Simon Tanner" },
            Horde = { orgrimmar, "The Drag", npc = "Karolek" },
        },
        [150] = {
            Alliance = { darnassus, "Craftsmen's Terrace", npc = "Telonis" },
            Horde = { thunderBluff, "Middle Rise", npc = "Una" },
        },
        [225] = {
            Alliance = { hinterlands, "Aerie Peak", npc = "Drakk Stonehand" },
            Horde = { feralas, "Camp Mojache", npc = "Hahrana Ironhide" },
        },
    },
    [197] = { -- Tailoring
        [75] = {
            Alliance = { stormwind, "Mage Quarter", npc = "Lawrence Schneider" },
            Horde = { orgrimmar, "The Drag", npc = "Magar" },
        },
        [150] = {
            Alliance = { stormwind, "Mage Quarter", npc = "Georgio Bolero" },
            Horde = { undercity, "Magic Quarter", npc = "Josef Gregorian" },
        },
        [225] = {
            Alliance = { dustwallow, "Theramore Isle", npc = "Timothy Worthington" },
            Horde = { hillsbrad, "Tarren Mill", npc = "Daryl Stack" },
        },
    },
    [356] = { -- Fishing
        [75] = {
            Alliance = { stormwind, "The Canals", npc = "Arnold Leland" },
            Horde = { orgrimmar, "Valley of Honor", npc = "Lumak" },
        },
        [150] = { action = "Buy Expert Fishing - The Bass and You", location = bootyBay },
        [225] = { action = "Complete Nat Pagle, Angler Extreme", location = { dustwallow } },
    },
    [185] = { -- Cooking
        [75] = cookingTrainers,
        [150] = {
            action = "Buy Expert Cookbook",
            Alliance = { ashenvale, "Silverwind Refuge" }, Horde = { desolace, "Shadowprey Village" },
        },
        [225] = { action = "Complete Clamlette Surprise", location = gadgetzan },
    },
    [129] = { -- First Aid
        [75] = firstAidTrainers,
        [150] = {
            action = "Buy Expert First Aid - Under Wraps", Alliance = firstAidManuals.Alliance,
            Horde = firstAidManuals.Horde,
        },
        [225] = { action = "Complete Triage", Alliance = theramore, Horde = hammerfall },
    },
}

-- Verified destinations for common trainer recipes and a few recipes with special sources.
-- Use the game's source for other recipes when it has one.
addon.recipeSources = {
    ["Lesser Mana Potion"] = {
        action = "Learn Lesser Mana Potion",
        Alliance = { stormwind, "Mage Quarter", npc = "Lilyssia Nightbreeze" },
        Horde = { orgrimmar, "The Drag", npc = "Yelmak" },
    },
    ["Flying Tiger Goggles"] = { Alliance = springspindle },
    ["Heavy Blasting Powder"] = { Alliance = springspindle },
    ["Ebon Shiv"] = magnusFrostwake,
    ["Ornate Thorium Handaxe"] = magnusFrostwake,
    ["Bold Dirk"] = { action = "Buy the plans from Pexmit", location = { hyjal } },
    ["Wizardweave Turban"] = { action = "Look for the pattern at the auction house" },
    ["Minor Wizard Oil"] = { action = "Buy the formula", Alliance = mageQuarter, Horde = theDrag },
    ["Heavy Linen Bandage"] = firstAidTrainers,
    ["Wool Bandage"] = firstAidTrainers,
    ["Heavy Wool Bandage"] = firstAidTrainers,
    ["Silk Bandage"] = firstAidTrainers,
    ["Heavy Silk Bandage"] = {
        action = "Buy the manual", Alliance = firstAidManuals.Alliance, Horde = firstAidManuals.Horde,
    },
    ["Mageweave Bandage"] = {
        action = "Buy the manual", Alliance = firstAidManuals.Alliance, Horde = firstAidManuals.Horde,
    },
    ["Coyote Steak"] = cookingTrainers,
    ["Dry Pork Ribs"] = cookingTrainers,
    ["Curiously Tasty Omelet"] = { action = "Buy the recipe", Alliance = oldTown, Horde = hammerfall },
    ["Roast Raptor"] = { action = "Buy the recipe", Alliance = { arathi, "Refuge Pointe" }, Horde = hammerfall },
    ["Tender Wolf Steak"] = { action = "Buy the recipe", location = gadgetzan },
}

-- Entries start with the minimum skill and recommended craft, node, or action.
-- The next entry's minimum is the current bracket's target.
addon.routes = {
    [186] = { -- Mining
        -- Recommended start and end for each bar. A recipe may be learnable earlier.
        smelting = {
            { 1, 65, "Copper" },
            { 65, 75, "Tin" },
            { 75, 100, "Bronze" },
            { 100, 125, "Silver" },
            { 125, 140, "Iron" },
            { 155, 185, "Gold", trainers = { Alliance = geofram } },
        },
        { 1, "Copper Vein", zones = { zephras, mulgore, barrens, dunMorogh, elwynn } },
        { 65, "Tin Vein", zones = { redridge, ashenvale, barrens, loch, wetlands } },
        { 125, "Iron Deposit", zones = { riverglades, arathi, desolace, stranglethorn, thousand, duskwood } },
        { 175, "Mithril Deposit", zones = { hinterlands, tanaris, azshara, desolace, badlands } },
        { 245, "Small Thorium Vein", zones = { ungoro, silithus, burning, winterspring } },
        { 275, "Rich Thorium Vein", zones = { winterspring, eastern, azshara, silithus, burning } },
    },
    [182] = { -- Herbalism
        gatherAction = "Gather ",
        { 1, "Peacebloom / Silverleaf", zones = startingZones },
        { 70, "Mageroyal / Briarthorn", zones = { darkshore, silverpine, loch, barrens } },
        { 115, "Wild Steelbloom / Bruiseweed", zones = { hillsbrad, stonetalon, wetlands } },
        { 170, "Goldthorn / Fadeleaf", zones = { arathi, stranglethorn } },
        { 205, "Firebloom", zones = { tanaris, searing } },
        { 230, "Sungrass", zones = { hinterlands, feralas } },
        { 270, "Dreamfoil", zones = { eastern, felwood } },
    },
    [393] = { -- Skinning
        gatherAction = "Skin ",
        { 1, "starter-zone beasts", zones = startingZones },
        { 75, "level 16-17 beasts", zones = { barrens, loch } },
        { 125, "level 25 beasts", zones = { hillsbrad, wetlands } },
        { 150, "level 30 beasts", zones = { arathi, thousand } },
        { 185, "level 37 beasts", zones = { stranglethorn, badlands, dustwallow } },
        { 225, "level 45 beasts", zones = { tanaris, feralas } },
        { 250, "level 50 beasts", zones = { ungoro, felwood } },
        { 275, "level 55 beasts", zones = { western, winterspring } },
    },
    [356] = { -- Fishing
        { 1, "Fish in starter-zone waters", zones = startingZones, tip = "Use a Shiny Bauble if fish get away." },
        { 25, "Fish in starter-zone waters", zones = startingZones },
    },
    [171] = { -- Alchemy
        { 1, "Minor Arcane Elixir" },
        { 10, "Elixir of Minor Defense" },
        { 25, "Elixir of Minor Defense", alternative = { "Minor Mana Potion", "if Mageroyal is cheaper" } },
        { 55, "Minor Mana Potion" },
        { 65, "Elixir of Minor Fortitude" },
        { 90, "Elixir of Wisdom" },
        { 120, "Lesser Mana Potion" },
        { 160, "Mana Potion" },
        { 185, "Elixir of Agility" },
        { 205, "Greater Mana Potion" },
        { 225, "Greater Mana Potion", alternative = { "Fire Protection Potion" } },
        { 230, "Draught of Detect Undead" },
        { 263, "Draught of Detect Demon" },
        { 292, "Superior Mana Potion" },
    },
    [164] = { -- Blacksmithing (Wowhead's Tried & Tested in Forever route)
        { 1, "Rough Sharpening Stone" },
        { 30, "Rough Grinding Stone" },
        { 65, "Copper Chain Belt" },
        { 75, "Silver Skeleton Key" },
        { 80, "Rough Bronze Leggings" },
        { 90, "Runed Copper Belt" },
        { 100, "Heavy Sharpening Stone" },
        { 105, "Runed Copper Belt" },
        { 110, "Rough Bronze Leggings" },
        { 125, "Iron Buckle" },
        { 129, "Bronze Warhammer" },
        { 140, "Patterned Bronze Bracers" },
        { 147, "Green Iron Bracers" },
        { 155, "Green Iron Leggings" },
        { 165, "Green Iron Bracers" },
        { 183, "Heavy Mithril Gauntlet" },
        { 190, "Golden Scale Bracers" },
        { 200, "Heavy Mithril Gauntlet" },
        { 205, "Mithril Plate Pants" },
        { 210, "Heavy Mithril Gauntlet" },
        { 215, "Heavy Mithril Breastplate" },
        { 225, "Dense Weightstone" },
        { 235, "Mithril Coif" },
        { 240, "Heavy Mithril Boots" },
        { 246, "Big Black Mace" },
        { 250, "Arcanite Skeleton Key" },
        { 257, "Ebon Shiv" },
        { 270, "Bold Dirk" },
        { 275, "Ornate Thorium Handaxe" },
        { 279, "Bold Dirk" },
    },
    [333] = { -- Enchanting
        { 1, "Disenchant uncommon gear" },
        { 5, "Minor Wizard Oil", rod = "Runed Copper Rod" },
        { 15, "Enchant Chest - Inferior Stamina" },
        { 70, "Enchant Chest - Minor Absorption" },
        { 90, "Enchant Cloak - Minor Protection" },
        { 110, "Enchant Shield - Minor Stamina" },
        { 130, "Enchant Bracer - Lesser Stamina", rod = "Runed Silver Rod" },
        { 175, "Enchant Boots - Lesser Agility", rod = "Runed Golden Rod" },
        { 180, "Enchant Bracer - Strength" },
        { 220, "Enchant Cloak - Greater Defense", rod = "Runed Truesilver Rod" },
        { 230, "Enchant Chest - Superior Intellect" },
        { 250, "Enchant Bracer - Greater Strength" },
        { 265, "Enchant Shield - Greater Stamina" },
        { 285, "Enchant Cloak - Superior Defense" },
    },
    [202] = { -- Engineering
        { 1, "Rough Blasting Powder" },
        { 34, "Rough Dynamite" },
        { 50, "Handful of Copper Bolts" },
        { 53, "Rough Copper Bomb" },
        { 65, "Copper Tube" },
        { 75, "Coarse Blasting Powder" },
        { 92, "Coarse Dynamite" },
        { 100, "Flying Tiger Goggles" },
        { 125, "Heavy Blasting Powder", alternative = { "Flying Tiger Goggles" } },
        { 136, "Flying Tiger Goggles" },
        { 150, "Aquadynamic Fish Attractor" },
        { 157, "Bronze Framework" },
        { 175, "Iron Grenade" },
        { 189, "Accurate Scope" },
        { 210, "Hi-Impact Mithril Slugs" },
        { 215, "Mithril Casing" },
        { 242, "Deepdive Helmet" },
        { 245, "Mithril Gyro-Shot" },
        { 270, "Thorium Widget" },
        { 285, "Delicate Arcanite Converter" },
    },
    [165] = { -- Leatherworking
        { 1, "Light Armor Kit", alternative = { "Light Leather", "if you have scraps" } },
        { 30, "Cured Light Hide" },
        { 55, "Embossed Leather Gloves" },
        { 75, "Medium Leather" },
        { 80, "Cured Medium Hide" },
        { 90, "Fine Leather Belt" },
        { 100, "Light Leather Pants" },
        { 115, "Dark Leather Belt" },
        { 125, "Heavy Leather" },
        { 130, "Heavy Armor Kit" },
        { 155, "Barbaric Shoulders", alternative = { "Dusky Bracers", "if hides are expensive", from = 160 } },
        { 165, "Guardian Gloves", alternative = { "Dusky Bracers", "if hides are expensive" } },
        { 175, "Thick Armor Kit" },
        { 195, "Nightscape Headband" },
        { 210, "Nightscape Pants" },
        { 225, "Rugged Armor Kit" },
        { 236, "Wicked Leather Gauntlets" },
        { 262, "Frostsaber Boots" },
        { 280, "Heavy Scorpid Helm" },
    },
    [197] = { -- Tailoring
        { 1, "Bolt of Linen Cloth" },
        { 30, "Linen Belt" },
        { 55, "Bolt of Woolen Cloth" },
        { 80, "Woolen Cape" },
        { 100, "Bolt of Silk Cloth" },
        { 120, "Azure Silk Hood" },
        { 135, "Formal White Shirt" },
        { 140, "Bolt of Mageweave" },
        { 150, "Crimson Silk Vest" },
        { 170, "Crimson Silk Pantaloons" },
        { 190, "Black Mageweave Gloves" },
        { 215, "Mageweave Bag" },
        { 225, "Runecloth Belt" },
        { 235, "Runecloth Cloak" },
        { 250, "Runecloth Cuffs" },
        { 290, "Wizardweave Turban", alternative = { "Mooncloth Robe", "if you have Mooncloth" } },
    },
    [185] = { -- Cooking
        { 1, "Roasted Boar Meat", alternative = { "Charred Wolf Meat" } },
        { 50, "Coyote Steak", alternative = { "Boiled Clams" } },
        { 90, "Dry Pork Ribs" },
        { 130, "Curiously Tasty Omelet" },
        { 175, "Roast Raptor" },
        { 225, "Tender Wolf Steak", alternative = { "Monster Omelet", "if Giant Eggs are cheaper" } },
    },
    [129] = { -- First Aid
        { 1, "Linen Bandage" },
        { 40, "Heavy Linen Bandage" },
        { 80, "Wool Bandage" },
        { 115, "Heavy Wool Bandage" },
        { 150, "Silk Bandage" },
        { 180, "Heavy Silk Bandage" },
        { 210, "Mageweave Bandage" },
        { 240, "Heavy Mageweave Bandage" },
        { 260, "Runecloth Bandage" },
        { 290, "Heavy Runecloth Bandage" },
    },
}
