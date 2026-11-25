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
        local map = C_Map.GetMapInfo(mapID)
        local name = map and map.name or addon.zoneNames[mapID]
        GameTooltip:AddLine(name, 0.92, 0.92, 0.92)
    end
end

local function showHint(bar, id, name, skill, cap)
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
        local unlock = route.unlock and route.unlock[cap]
        GameTooltip:AddLine(unlock or "Train the next rank with a profession trainer.", 0.92, 0.92, 0.92, true)
    else
        GameTooltip:AddLine(("Next target %d"):format(math.min(target, cap)), 0.7, 0.7, 0.7)
        GameTooltip:AddLine(bracket[2], 1, 0.82, 0.37)
        if bracket.zones then
            showZones(bracket)
        end
        if bracket.alternative then
            GameTooltip:AddLine("Alternative · " .. bracket.alternative, 0.8, 0.8, 0.8, true)
        end
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
    return info.parentProfessionID or info.professionID, info.displayName, info.skillLevel, info.maxSkillLevel
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
