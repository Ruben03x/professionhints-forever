local _, addon = ...
local MAX_SKILL, MAX_ZONES = 300, 3
local hooked = {}

local function getBracket(route, skill)
    for index = #route, 1, -1 do
        if skill >= route[index][1] then
            local nextBracket = route[index + 1]
            return route[index], nextBracket and nextBracket[1] or MAX_SKILL
        end
    end
end

local function mapName(mapID)
    local map = C_Map.GetMapInfo(mapID)
    return map and map.name or addon.zoneNames[mapID]
end

local function locationHint(entry, action)
    local location = entry and (entry[UnitFactionGroup("player")] or entry.location)
    if not location then
        return action .. "."
    end

    local name = mapName(location[1])
    if location[2] then
        name = location[2] .. ", " .. name
    end
    return ("%s in %s."):format(action, name)
end

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
        if mapID == playerMap then
            distance = 0
        else
            local continent, world = C_Map.GetWorldPosFromMapPos(mapID, center)
            if world and continent == playerContinent then
                local x, y = world:GetXY()
                distance = (x - px) ^ 2 + (y - py) ^ 2
            end
        end
        ordered[index] = { mapID = mapID, index = index, distance = distance }
    end
    table.sort(ordered, function(a, b)
        if a.distance == b.distance then
            return a.index < b.index
        end
        return a.distance < b.distance
    end)
    return ordered
end

local function showZones(bracket)
    local zones = bracket.zones[UnitFactionGroup("player")] or bracket.zones
    -- Some maps have no usable world coordinates, so keep the bundled order if needed.
    local ok, ordered = pcall(orderZones, zones)
    if not ok then
        ordered = nil
    end
    for index = 1, math.min(#zones, MAX_ZONES) do
        local mapID = ordered and ordered[index].mapID or zones[index]
        GameTooltip:AddLine(mapName(mapID), 0.92, 0.92, 0.92)
    end
end

local function showMining(bracket, skill, target, cap, smelting)
    local step
    for _, option in ipairs(smelting) do
        if skill < option[2] then
            step = option
            break
        end
    end

    local mineTo = math.min(target, cap)
    if step and skill < step[1] then
        mineTo = math.min(mineTo, step[1])
    end
    GameTooltip:AddLine(("Mine %s to %d"):format(bracket[2], mineTo), 1, 0.82, 0.37)
    showZones(bracket)

    if not step then
        GameTooltip:AddLine("Smelting skill-ups end at 185.", 0.8, 0.8, 0.8)
    elseif skill < step[1] then
        GameTooltip:AddLine(("Smelt %s unlocks at %d."):format(step[3], step[1]), 0.8, 0.8, 0.8)
    else
        GameTooltip:AddLine(("Or smelt %s to %d at a forge."):format(step[3], math.min(step[2], cap)),
            0.8, 0.8, 0.8)
    end
end

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

local function showCrafting(bracket, skill, target, inCraftingPage)
    local name, alternative = bracket[2], bracket.alternative
    if alternative and alternative.from and skill < alternative.from then
        alternative = nil
    end

    GameTooltip:AddLine(("Next target %d"):format(target), 0.7, 0.7, 0.7)
    GameTooltip:AddLine(name, 1, 0.82, 0.37)

    local recipe, other
    if inCraftingPage then
        recipe, other = findRecipes(name, alternative and alternative[1])
    end

    local unlearned = recipe and recipe.learned == false
    if unlearned then
        local entry = addon.recipeSources[name]
        local source
        if entry then
            source = locationHint(entry, entry.action or "Learn it from a trainer")
        elseif C_TradeSkillUI.GetRecipeSourceText then
            local sourceText = C_TradeSkillUI.GetRecipeSourceText(recipe.recipeID)
            source = sourceText and sourceText:match("[^\r\n]*%S[^\r\n]*")
        end
        GameTooltip:AddLine(source or "Recipe unlearned.", 0.8, 0.8, 0.8, true)
    end

    local alternateLearned = other and other.learned
    if alternative and (alternateLearned == true or (not unlearned and alternateLearned ~= false)) then
        local note = alternative[2] and (" " .. alternative[2]) or ""
        GameTooltip:AddLine(("Alternative · %s%s."):format(alternative[1], note), 0.8, 0.8, 0.8, true)
    end
end

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
        local action = entry and entry.action
        local hint = locationHint(entry, action or "Train the next rank")
        GameTooltip:AddLine(hint, 0.92, 0.92, 0.92, true)
    elseif route.smelting then
        showMining(bracket, skill, target, cap, route.smelting)
    elseif bracket.zones then
        local action = route.gatherAction or ""
        GameTooltip:AddLine(("%s%s to %d"):format(action, bracket[2], math.min(target, cap)), 1, 0.82, 0.37)
        showZones(bracket)
        if bracket.alternative then
            GameTooltip:AddLine("Alternative · " .. bracket.alternative, 0.8, 0.8, 0.8, true)
        end
    else
        showCrafting(bracket, skill, math.min(target, cap), inCraftingPage)
    end
    GameTooltip:Show()
end

local function hideHint(bar)
    if GameTooltip:GetOwner() == bar then
        GameTooltip:Hide()
    end
end

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

local function readBookSkill(index)
    local profession = select(index, GetProfessions())
    if not profession then
        return
    end
    local name, _, rank, cap, _, _, id = GetProfessionInfo(profession)
    return id, name, rank, cap
end

local function readCraftingSkill()
    local info = Professions.GetProfessionInfo()
    if info then
        return info.parentProfessionID or info.professionID, info.displayName, info.skillLevel, info.maxSkillLevel, true
    end
end

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
