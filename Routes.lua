local _, addon = ...

-- WoW Forever UiMapIDs. Each gathering route lists its preferred zones first.
local durotar, mulgore, barrens = 1411, 1412, 1413
local arathi, badlands = 1417, 1418
local tirisfal, silverpine, western, eastern = 1420, 1421, 1422, 1423
local hillsbrad, hinterlands, dunMorogh = 1424, 1425, 1426
local searing, burning, elwynn = 1427, 1428, 1429
local loch, redridge, stranglethorn = 1432, 1433, 1434
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
    [loch] = "Loch Modan", [redridge] = "Redridge Mountains", [stranglethorn] = "Stranglethorn Vale",
    [wetlands] = "Wetlands", [teldrassil] = "Teldrassil", [darkshore] = "Darkshore", [ashenvale] = "Ashenvale",
    [thousand] = "Thousand Needles", [stonetalon] = "Stonetalon Mountains", [desolace] = "Desolace",
    [feralas] = "Feralas", [dustwallow] = "Dustwallow Marsh", [tanaris] = "Tanaris", [azshara] = "Azshara",
    [felwood] = "Felwood", [ungoro] = "Un'Goro Crater", [silithus] = "Silithus", [winterspring] = "Winterspring",
    [stormwind] = "Stormwind City", [orgrimmar] = "Orgrimmar", [ironforge] = "Ironforge",
    [thunderBluff] = "Thunder Bluff", [darnassus] = "Darnassus", [undercity] = "Undercity",
    [swampOfSorrows] = "Swamp of Sorrows",
    [hyjal] = "Mount Hyjal", [zephras] = "Zephras Isle", [riverglades] = "Riverglades",
}

local startingZones = {
    Alliance = { elwynn, dunMorogh, teldrassil, zephras },
    Horde = { durotar, mulgore, tirisfal, zephras },
    zephras,
}

local dwarvenDistrict = { stormwind, "Dwarven District" }
local mageQuarter = { stormwind, "Mage Quarter" }
local oldTown = { stormwind, "Old Town" }
local valleyOfHonor = { orgrimmar, "Valley of Honor" }
local theDrag = { orgrimmar, "The Drag" }
local theGreatForge = { ironforge, "The Great Forge" }
local tinkerTown = { ironforge, "Tinker Town" }
local craftsmensTerrace = { darnassus, "Craftsmen's Terrace" }
local bootyBay = { stranglethorn, "Booty Bay" }
local gadgetzan = { tanaris, "Gadgetzan" }
local theramore = { dustwallow, "Theramore Isle" }
local hammerfall = { arathi, "Hammerfall" }
local firstAidManuals = {
    Alliance = { arathi, "Stromgarde Keep" }, Horde = { dustwallow, "Brackenwall Village" },
}

-- One suggested destination per faction and current rank cap.
addon.training = {
    [186] = { allRanks = { Alliance = dwarvenDistrict, Horde = valleyOfHonor } },
    [182] = { allRanks = { Alliance = mageQuarter, Horde = theDrag } },
    [393] = { allRanks = { Alliance = oldTown, Horde = theDrag } },
    [171] = { -- Alchemy
        [75] = { Alliance = mageQuarter, Horde = theDrag },
        [150] = { Alliance = craftsmensTerrace, Horde = { undercity, "The Apothecarium" } },
        [225] = { Alliance = { feralas, "Feathermoon Stronghold" }, Horde = { swampOfSorrows, "Stonard" } },
    },
    [164] = { -- Blacksmithing
        [75] = { Alliance = dwarvenDistrict, Horde = valleyOfHonor },
        [150] = { Alliance = theGreatForge, Horde = valleyOfHonor },
        [225] = { location = bootyBay },
    },
    [333] = { -- Enchanting
        [75] = { Alliance = mageQuarter, Horde = theDrag },
        [150] = { Alliance = { elwynn, "Tower of Azora" }, Horde = { stonetalon, "Sun Rock Retreat" } },
        [225] = { action = "Train the next rank from Annora", location = { badlands, "Uldaman" } },
    },
    [202] = { -- Engineering
        [75] = { Alliance = tinkerTown, Horde = valleyOfHonor },
        [150] = { Alliance = tinkerTown, Horde = valleyOfHonor },
        [225] = { location = gadgetzan },
    },
    [165] = { -- Leatherworking
        [75] = { Alliance = oldTown, Horde = theDrag },
        [150] = { Alliance = craftsmensTerrace, Horde = { thunderBluff, "Middle Rise" } },
        [225] = { Alliance = { hinterlands, "Aerie Peak" }, Horde = { feralas, "Camp Mojache" } },
    },
    [197] = { -- Tailoring
        [75] = { Alliance = mageQuarter, Horde = theDrag },
        [150] = { Alliance = mageQuarter, Horde = { undercity, "Magic Quarter" } },
        [225] = { Alliance = theramore, Horde = { hillsbrad, "Tarren Mill" } },
    },
    [356] = { -- Fishing
        [75] = { Alliance = { stormwind }, Horde = valleyOfHonor },
        [150] = { action = "Buy Expert Fishing - The Bass and You", location = bootyBay },
        [225] = { action = "Complete Nat Pagle, Angler Extreme", location = { dustwallow } },
    },
    [185] = { -- Cooking
        [75] = { Alliance = oldTown, Horde = theDrag },
        [150] = {
            action = "Buy Expert Cookbook",
            Alliance = { ashenvale, "Silverwind Refuge" }, Horde = { desolace, "Shadowprey Village" },
        },
        [225] = { action = "Complete Clamlette Surprise", location = gadgetzan },
    },
    [129] = { -- First Aid
        [75] = { Alliance = { stormwind, "Cathedral Square" }, Horde = { orgrimmar, "Valley of Spirits" } },
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
    ["Lesser Mana Potion"] = addon.training[171][150],
    ["Coarse Grinding Stone"] = addon.training[164][150],
    ["Flying Tiger Goggles"] = addon.training[202][150],
    ["Heavy Blasting Powder"] = addon.training[202][150],
    ["Mageweave Bag"] = addon.training[197][150],
    ["Argent Shoulders"] = {
        action = "Buy the pattern at Argent Dawn Revered", location = { eastern, "Light's Hope Chapel" },
    },
    ["Minor Wizard Oil"] = { action = "Buy the formula", Alliance = mageQuarter, Horde = theDrag },
    ["Heavy Linen Bandage"] = addon.training[129][75],
    ["Wool Bandage"] = addon.training[129][75],
    ["Heavy Wool Bandage"] = addon.training[129][75],
    ["Silk Bandage"] = addon.training[129][75],
    ["Heavy Silk Bandage"] = {
        action = "Buy the manual", Alliance = firstAidManuals.Alliance, Horde = firstAidManuals.Horde,
    },
    ["Mageweave Bandage"] = {
        action = "Buy the manual", Alliance = firstAidManuals.Alliance, Horde = firstAidManuals.Horde,
    },
    ["Coyote Steak"] = addon.training[185][75],
    ["Dry Pork Ribs"] = addon.training[185][75],
    ["Curiously Tasty Omelet"] = { action = "Buy the recipe", Alliance = oldTown, Horde = hammerfall },
    ["Roast Raptor"] = { action = "Buy the recipe", Alliance = { arathi, "Refuge Pointe" }, Horde = hammerfall },
    ["Tender Wolf Steak"] = { action = "Buy the recipe", location = gadgetzan },
}

-- Entries are {minimum skill, action or node, zones = ..., alternative = ...}.
-- The next entry's minimum is the current bracket's target.
addon.routes = {
    [186] = { -- Mining
        -- Recommended smelting route. Endpoints below the gray threshold are recipe switches.
        smelting = {
            { 1, 65, "Copper" },
            { 65, 75, "Tin" },
            { 75, 100, "Bronze" },
            { 100, 125, "Silver" },
            { 125, 140, "Iron" },
            { 155, 185, "Gold" },
        },
        { 1, "Copper Vein", zones = { zephras, mulgore, barrens, dunMorogh, elwynn } },
        { 65, "Tin Vein", zones = { redridge, ashenvale, barrens, loch, wetlands } },
        { 125, "Iron Deposit", zones = { riverglades, arathi, desolace, stranglethorn, thousand } },
        { 175, "Mithril Deposit", zones = { hinterlands, tanaris, azshara, desolace, badlands } },
        { 245, "Small Thorium Vein", zones = { ungoro, silithus, burning, winterspring } },
        { 275, "Rich Thorium Vein", zones = { winterspring, eastern, azshara, hyjal, burning } },
    },
    [182] = { -- Herbalism
        gatherAction = "Gather ",
        { 1, "Peacebloom / Silverleaf", zones = startingZones },
        { 70, "Mageroyal / Briarthorn", zones = {
            Alliance = { darkshore, loch }, Horde = { barrens, silverpine }, darkshore, silverpine,
        } },
        { 115, "Wild Steelbloom / Bruiseweed", zones = {
            Alliance = { wetlands, hillsbrad, stonetalon }, Horde = { hillsbrad, stonetalon }, hillsbrad, stonetalon,
        } },
        { 170, "Goldthorn / Fadeleaf", zones = { arathi, stranglethorn } },
        { 205, "Firebloom", zones = { tanaris, searing } },
        { 230, "Sungrass", zones = { hinterlands, feralas } },
        { 270, "Dreamfoil", zones = { eastern, felwood } },
    },
    [393] = { -- Skinning
        gatherAction = "Skin ",
        { 1, "starter-zone beasts", zones = startingZones },
        { 75, "level 16-17 beasts", zones = {
            Alliance = { loch }, Horde = { barrens }, barrens, loch,
        } },
        { 125, "level 25 beasts", zones = {
            Alliance = { wetlands, hillsbrad }, Horde = { hillsbrad, wetlands }, hillsbrad, wetlands,
        } },
        { 150, "level 30 beasts", zones = {
            Alliance = { arathi, thousand }, Horde = { thousand, arathi }, arathi, thousand,
        } },
        { 185, "level 37 beasts", zones = {
            Alliance = { stranglethorn, badlands, dustwallow }, Horde = { dustwallow, badlands, stranglethorn },
            stranglethorn, badlands, dustwallow,
        } },
        { 225, "level 45 beasts", zones = { tanaris, feralas } },
        { 250, "level 50 beasts", zones = { ungoro, felwood } },
        { 275, "level 55 beasts", zones = { western, winterspring } },
    },
    [356] = { -- Fishing
        { 1, "Fish in starter-zone waters", zones = startingZones },
        { 75, "Fish in low-level waters", zones = {
            Alliance = { loch, darkshore, elwynn }, Horde = { barrens, silverpine, mulgore }, loch, barrens,
        } },
        { 150, "Fish with a lure", zones = { dustwallow, stranglethorn }, alternative = "Stay in starter-zone waters." },
        { 225, "Fish in open water", zones = { dustwallow, tanaris, feralas }, alternative = "Use a lure in Tanaris or Feralas." },
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
    [164] = { -- Blacksmithing
        { 1, "Rough Sharpening Stone" },
        { 25, "Rough Grinding Stone" },
        { 50, "Coarse Grinding Stone" },
        { 67, "Runed Copper Gauntlets" },
        { 75, "Runed Copper Belt", alternative = { "Silver Skeleton Key", "if silver is cheaper" } },
        { 80, "Rough Bronze Leggings" },
        { 95, "Patterned Bronze Bracers" },
        { 100, "Heavy Grinding Stone" },
        { 112, "Patterned Bronze Bracers" },
        { 125, "Bronze Warhammer" },
        { 165, "Green Iron Bracers" },
        { 175, "Golden Scale Bracers" },
        { 185, "Heavy Mithril Gauntlet" },
        { 200, "Mithril Plate Pants" },
        { 215, "Heavy Mithril Breastplate" },
        { 225, "Dense Sharpening Stone" },
        { 232, "Heavy Mithril Boots" },
        { 245, "Thorium Greatsword" },
        { 260, "Ornate Thorium Handaxe" },
        { 275, "Bold Dirk" },
    },
    [333] = { -- Enchanting
        { 1, "Disenchant uncommon gear" },
        { 5, "Runed Copper Rod" },
        { 6, "Minor Wizard Oil" },
        { 15, "Enchant Chest - Inferior Stamina" },
        { 70, "Enchant Chest - Minor Absorption" },
        { 90, "Enchant Cloak - Minor Protection" },
        { 110, "Enchant Shield - Minor Stamina" },
        { 130, "Runed Silver Rod" },
        { 131, "Enchant Bracer - Lesser Stamina" },
        { 160, "Enchant Boots - Lesser Agility" },
        { 175, "Runed Golden Rod" },
        { 176, "Enchant Boots - Lesser Agility" },
        { 180, "Enchant Bracer - Strength" },
        { 205, "Enchant Cloak - Greater Defense" },
        { 220, "Runed Truesilver Rod" },
        { 221, "Enchant Gloves - Agility" },
        { 230, "Enchant Chest - Superior Intellect" },
        { 250, "Enchant Bracer - Greater Strength" },
        { 265, "Enchant Shield - Greater Stamina" },
        { 285, "Enchant Cloak - Superior Defense" },
        { 290, "Runed Arcanite Rod" },
        { 291, "Enchant Cloak - Superior Defense" },
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
        { 215, "Mageweave Bag", alternative = { "Runecloth Belt", "if you have Runecloth" } },
        { 225, "Runecloth Belt" },
        { 235, "Runecloth Cloak" },
        { 250, "Runecloth Cuffs" },
        { 291, "Argent Shoulders" },
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
