globalIgnores = {}
local localIgnores = {}
local localsRead = false
local syncLock = false

local function syncToGlobal()
    local len = GetNumIgnores()
    local newLocalIgnores = {}
    for i = 1, len do
        local name = GetIgnoreName(i)
        globalIgnores[name] = true
        newLocalIgnores[name] = true
    end

    for name, value in pairs(localIgnores) do
        if not newLocalIgnores[name] then
            globalIgnores[name] = false
        end
    end

    localIgnores = newLocalIgnores
    localsRead = true
end

local function syncToLocal()
    for name, value in pairs(globalIgnores) do
        if value then
            if not localIgnores[name] and not IsIgnored(name) then
                print("adding "..name)
                AddIgnore(name)
            end
        else
            if not localIgnores[name] and IsIgnored(name) then
                print("removing "..name)
                DelIgnore(name)
            end
        end
    end
end

local function removeFromLocal()
    for name, value in pairs(globalIgnores) do
        if not value then
            if IsIgnored(name) then
                print("removing "..name)
                DelIgnore(name)
            end
        end
    end
end

local tdFrame = CreateFrame("Frame", "TD_IGNORES_FRAME")

tdFrame:SetScript("OnEvent", function(self, event, ...)
    if not syncLock then
        syncLock = true
        if not localsRead then
            removeFromLocal()
        end
        syncToGlobal()
        syncToLocal()
        syncLock = false
    end
end)

tdFrame:RegisterEvent("IGNORELIST_UPDATE")

