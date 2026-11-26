local _, addon = ...
local MAX_SKILL = 300

-- Find the active row in a profession's route. The next row's starting skill is
-- the target. The last row targets MAX_SKILL.
local function getBracket(route, skill)
    for index = #route, 1, -1 do
        if skill >= route[index][1] then
            local nextBracket = route[index + 1]
            return route[index], nextBracket and nextBracket[1] or MAX_SKILL
        end
    end
end

-- Use the game's map name when available, with the bundled zone name as a fallback.
local function mapName(mapID)
    local map = C_Map.GetMapInfo(mapID)
    return map and map.name or addon.zoneNames[mapID]
end

-- Put the current zone first when listed, then sort by straight-line distance
-- from the player's position to the center of each zone.
-- Keep the route order for ties and zones without comparable coordinates.
-- TODO: Consider flight path availability and travel times when ranking zones.
local function orderZones(zones)
    local playerMap = C_Map.GetBestMapForUnit("player")
    local playerPosition = playerMap and C_Map.GetPlayerMapPosition(playerMap, "player")
    if not playerPosition then
        return
    end

    local playerContinent, playerWorld = C_Map.GetWorldPosFromMapPos(playerMap, playerPosition)
    if not playerContinent or not playerWorld then
        return
    end
    local px, py = playerWorld:GetXY()
    local center = CreateVector2D(0.5, 0.5)
    local ordered = {}
    for index, mapID in ipairs(zones) do
        local distance = math.huge
        local otherContinent = false
        if mapID == playerMap then
            distance = 0
        else
            local continent, world = C_Map.GetWorldPosFromMapPos(mapID, center)
            otherContinent = continent ~= nil and continent ~= playerContinent
            if world and continent == playerContinent then
                local x, y = world:GetXY()
                distance = (x - px) ^ 2 + (y - py) ^ 2
            end
        end
        ordered[index] = { mapID = mapID, index = index, distance = distance, otherContinent = otherContinent }
    end
    table.sort(ordered, function(a, b)
        if a.distance == b.distance then
            return a.index < b.index
        end
        return a.distance < b.distance
    end)
    return ordered
end

-- Prefer a trainer on the player's map even when world coordinates are unavailable.
-- Otherwise rank the listed destinations by zone distance, with the first as a fallback.
local function nearestLocation(locations)
    local playerMap = C_Map.GetBestMapForUnit("player")
    local maps = {}
    for index, location in ipairs(locations) do
        local mapID = location[1]
        if mapID == playerMap then
            return location
        end
        maps[index] = mapID
    end

    local ok, ordered = pcall(orderZones, maps)
    local nearest = ok and ordered and ordered[1]
    return locations[nearest and nearest.index or 1]
end

-- Use a single destination for fixed sources and rank eligible trainers when listed.
local function locationHint(entry, action)
    if not entry then
        return action .. "."
    end

    local faction = UnitFactionGroup("player")
    local location = entry[faction] or entry.location
    local locations = entry.locations and entry.locations[faction]
    if locations then
        location = nearestLocation(locations) or location
    end
    action = action or entry.action
    if not location then
        return action and (action .. ".")
    end

    action = action or (location.npc and "Learn it" or "Learn it from a trainer")
    if location.npc then
        action = action .. " with " .. location.npc
    end
    local name = mapName(location[1])
    if location[2] then
        name = location[2] .. ", " .. name
    end
    return ("%s in %s."):format(action, name)
end

-- Add destinations from the shared zone list for this skill bracket.
local function showZones(bracket)
    local maxZones = 3
    local zones = bracket.zones
    -- Fall back to the route order if the player position is unavailable or sorting fails.
    local ok, ordered = pcall(orderZones, zones)
    if not ok then
        ordered = nil
    end
    for index = 1, math.min(#zones, maxZones) do
        local zone = ordered and ordered[index]
        local name = mapName(zone and zone.mapID or zones[index])
        if zone and zone.otherContinent then
            name = name .. " (other continent)"
        end
        GameTooltip:AddLine(name, 0.92, 0.92, 0.92)
    end
end

-- Add a mining target, gathering zones, and the current or upcoming smelting step.
-- The mining target can stop at the next recommended smelting step.
local function showMining(bracket, skill, target, cap, smelting)
    local switchSkill, smeltTo, barName, trainers
    for _, option in ipairs(smelting) do
        local stepTarget = option[2]
        if skill < stepTarget then
            switchSkill, smeltTo, barName, trainers = option[1], stepTarget, option[3], option.trainers
            break
        end
    end

    local mineTo = math.min(target, cap)
    if switchSkill and skill < switchSkill then
        mineTo = math.min(mineTo, switchSkill)
    end
    GameTooltip:AddLine(("Mine %s to %d"):format(bracket[2], mineTo), 1, 0.82, 0.37)
    showZones(bracket)

    if not switchSkill then
        GameTooltip:AddLine("Smelting skill-ups end at 185.", 0.8, 0.8, 0.8)
    elseif skill < switchSkill then
        GameTooltip:AddLine(("Switch to smelting %s at %d."):format(barName, switchSkill), 0.8, 0.8, 0.8)
    else
        GameTooltip:AddLine(("Or smelt %s to %d at a forge."):format(barName, math.min(smeltTo, cap)),
            0.8, 0.8, 0.8)
        local trainer = trainers and trainers[UnitFactionGroup("player")]
        if trainer and trainer[1] == C_Map.GetBestMapForUnit("player") then
            -- TODO: Check whether the player has learned the smelting recipe when the game can tell us.
            local hint = ("If you haven't learned it, %s teaches Smelt %s in %s.")
                :format(trainer.npc, barName, trainer[2])
            GameTooltip:AddLine(hint, 0.8, 0.8, 0.8, true)
        end
    end
end

-- Match the suggested recipes by name in the player's own crafting window.
-- Prefer a learned match when multiple recipes share a name.
local function findRecipes(name, alternativeName)
    local trade = C_TradeSkillUI
    if not trade or not trade.GetAllRecipeIDs or not trade.GetRecipeInfo
        or (trade.IsTradeSkillReady and not trade.IsTradeSkillReady())
        or (trade.IsTradeSkillLinked and trade.IsTradeSkillLinked())
        or (trade.IsTradeSkillGuild and trade.IsTradeSkillGuild())
        or (trade.IsNPCCrafting and trade.IsNPCCrafting()) then
        return
    end

    local primary, alternative
    for _, recipeID in ipairs(trade.GetAllRecipeIDs() or {}) do
        local recipe = trade.GetRecipeInfo(recipeID)
        if recipe and recipe.name == name then
            if not primary or recipe.learned then
                primary = recipe
            end
        elseif recipe and recipe.name == alternativeName then
            if not alternative or recipe.learned then
                alternative = recipe
            end
        end
        if primary and primary.learned and (not alternativeName or (alternative and alternative.learned)) then
            break
        end
    end
    return primary, alternative
end

-- Add the crafting recommendation and any available alternative or rod hint.
-- Check recipe knowledge and show acquisition hints inside the crafting window.
local function showCrafting(bracket, skill, target, inCraftingPage)
    local name, alternative = bracket[2], bracket.alternative
    if alternative and alternative.from and skill < alternative.from then
        alternative = nil
    end

    GameTooltip:AddLine(("Next target %d"):format(target), 0.7, 0.7, 0.7)
    GameTooltip:AddLine(name, 1, 0.82, 0.37)
    if bracket.rod then
        GameTooltip:AddLine(("Make a %s if you need one."):format(bracket.rod), 0.8, 0.8, 0.8, true)
    end

    local recipe, alternativeRecipe
    if inCraftingPage then
        recipe, alternativeRecipe = findRecipes(name, alternative and alternative[1])
    end

    local primaryUnlearned = recipe and recipe.learned == false
    if primaryUnlearned then
        local entry = addon.recipeSources[name]
        local source
        if entry then
            source = locationHint(entry)
        end
        if not source and C_TradeSkillUI.GetRecipeSourceText then
            local sourceText = C_TradeSkillUI.GetRecipeSourceText(recipe.recipeID)
            source = sourceText and sourceText:match("[^\r\n]*%S[^\r\n]*")
        end
        GameTooltip:AddLine(source or "Recipe unlearned.", 0.8, 0.8, 0.8, true)
    end

    local alternativeLearned = alternativeRecipe and alternativeRecipe.learned
    -- If the alternative's status is unknown, show it only when the primary
    -- recipe isn't known to be unlearned. The overview doesn't check either recipe.
    local showAlternative = alternative
        and (alternativeLearned == true or (not primaryUnlearned and alternativeLearned ~= false))
    if showAlternative then
        local note = alternative[2] and (" " .. alternative[2]) or ""
        GameTooltip:AddLine(("Alternative · %s%s."):format(alternative[1], note), 0.8, 0.8, 0.8, true)
    end
end

local rankAfterCap = { [75] = "Journeyman", [150] = "Expert", [225] = "Artisan" }

-- Show the hint for the hovered skill bar. The cap is the current trained rank's
-- limit. At that cap, show where to unlock the next rank until the player reaches MAX_SKILL.
local function showHint(bar, id, name, skill, cap, inCraftingPage)
    local route = addon.routes[id]
    if not route or not skill or not cap or skill < 1 or cap < 1 then
        return
    end
    local bracket, target = getBracket(route, skill)
    if not bracket then
        return
    end

    if GameTooltip:GetOwner() == bar then
        GameTooltip:AddLine(" ")
    else
        GameTooltip:SetOwner(bar, "ANCHOR_RIGHT")
    end
    GameTooltip:AddLine(("%s %d / %d"):format(name, skill, cap), 1, 0.82, 0.37)

    if skill >= MAX_SKILL then
        GameTooltip:AddLine("Maximum skill reached.", 0.92, 0.92, 0.92)
    elseif skill >= cap then
        local training = addon.training[id]
        local entry = training[cap] or training.allRanks
        local rank = rankAfterCap[cap]
        local action = (entry and entry.action) or (rank and ("Train %s %s"):format(rank, name))
        local hint = locationHint(entry, action or "Train the next rank")
        GameTooltip:AddLine(hint, 0.92, 0.92, 0.92, true)
    elseif route.smelting then
        showMining(bracket, skill, target, cap, route.smelting)
    elseif bracket.zones then
        local action = route.gatherAction or ""
        GameTooltip:AddLine(("%s%s to %d"):format(action, bracket[2], math.min(target, cap)), 1, 0.82, 0.37)
        showZones(bracket)
        if bracket.tip then
            GameTooltip:AddLine(bracket.tip, 0.8, 0.8, 0.8, true)
        end
    else
        showCrafting(bracket, skill, math.min(target, cap), inCraftingPage)
    end
    GameTooltip:Show()
end

-- Hide the tooltip only if the bar still owns it.
local function hideHint(bar)
    if GameTooltip:GetOwner() == bar then
        GameTooltip:Hide()
    end
end

local hooked = {}

-- Hook each bar once. Read the latest skill on hover and hide the hint when the
-- cursor leaves or the bar is hidden.
local function hookBar(bar, readSkill)
    if not bar or hooked[bar] then
        return
    end
    bar:HookScript("OnEnter", function(self)
        showHint(self, readSkill())
    end)
    bar:HookScript("OnLeave", hideHint)
    bar:HookScript("OnHide", hideHint)
    bar:SetMouseMotionEnabled(true)
    hooked[bar] = true
end

-- Read the profession ID, name, skill, and trained cap for a slot on the overview page.
local function readBookSkill(index)
    local profession = select(index, GetProfessions())
    if not profession then
        return
    end
    local name, _, rank, cap, _, _, id = GetProfessionInfo(profession)
    return id, name, rank, cap
end

-- Read the same values for the open crafting window. Use the parent profession
-- ID when available and pass true so showHint can check recipes on this page.
local function readCraftingSkill()
    local info = Professions.GetProfessionInfo()
    if info then
        return info.parentProfessionID or info.professionID, info.displayName, info.skillLevel, info.maxSkillLevel, true
    end
end

-- Find the skill bars on the professions overview and in the crafting window.
local function hookProfessions()
    local frame = ProfessionsFrame
    local book = frame and frame.BookPage or ProfessionsBookFrame
    local content = book and book.ProfessionsContentFrame
    if content then
        -- GetProfessions returns the two primary skills, then First Aid, Fishing, Cooking.
        local indices = {
            PrimaryProfession1 = 1, PrimaryProfession2 = 2,
            SecondaryProfession1 = 5, SecondaryProfession2 = 4, SecondaryProfession3 = 3,
        }
        for key, index in pairs(indices) do
            local card = content[key]
            if card then
                local professionIndex = index
                hookBar(card.StatusBar, function()
                    return readBookSkill(professionIndex)
                end)
            end
        end
    end
    if frame and frame.CraftingPage and Professions and Professions.GetProfessionInfo then
        hookBar(frame.CraftingPage.RankBar, readCraftingSkill)
    end
end

local events = CreateFrame("Frame")
events:RegisterEvent("ADDON_LOADED")
events:RegisterEvent("PLAYER_LOGIN")
events:SetScript("OnEvent", function(_, event, name)
    if event == "PLAYER_LOGIN" or name == "Blizzard_Professions" or name == "Blizzard_ProfessionsBook" then
        hookProfessions()
    end
end)
