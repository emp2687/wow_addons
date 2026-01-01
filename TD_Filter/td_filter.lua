SlashCmdList["TD_FILTER"] = function(msg)
    slashCommandHandler(msg)
end
SLASH_TD_FILTER1 = "/tdf"

if(not badText) then
    badText = {}
end

local events = {
    "CHAT_MSG_ACHIEVEMENT",
    "CHAT_MSG_BATTLEGROUND",
    "CHAT_MSG_BATTLEGROUND_LEADER",
    "CHAT_MSG_CHANNEL",
    "CHAT_MSG_CHANNEL_JOIN",
    "CHAT_MSG_CHANNEL_LEAVE",
    "CHAT_MSG_EMOTE",
    "CHAT_MSG_GUILD",
    "CHAT_MSG_GUILD_ACHIEVEMENT",
    "CHAT_MSG_OFFICER",
    "CHAT_MSG_PARTY",
    "CHAT_MSG_RAID",
    "CHAT_MSG_RAID_LEADER",
    "CHAT_MSG_RAID_WARNING",
    "CHAT_MSG_SAY",
    "CHAT_MSG_SYSTEM",
    "CHAT_MSG_TEXT_EMOTE",
    "CHAT_MSG_WHISPER",
    "CHAT_MSG_WHISPER_INFORM",
    "CHAT_MSG_YELL"
}

function slashCommandHandler(msg)
  if(msg) then
	local command = strlower(msg)
	if (command == "list") then
--        print("bad:")
        for name, value in pairs(badText) do
            if value then
                print(name)
            end
        end
  --      print("end.")
	else
        if badText[command] then
            badText[command] = false
        else
            badText[command] = true
        end
	end
  end
end

--[[
local function isGlobalIgnored(from)
    for name, value in pairs(globalIgnores) do
        if value then
            if from == name then
                print("ignoring from "..name)
                return true
            end
        end
    end
    return false
end
]]--

local function eventHandler(self, event, text, from)
--   print("got text " .. text);
--  print(from);

--[[
    if isGlobalIgnored(from) then
        return true
    end
]]--

    if text ~= nil then
        local t = string.lower(text)
        for name, value in pairs(badText) do
            if value then
                local frag = string.lower(name)
                local startPos, endPos = string.find(t, frag)
                if startPos ~= nil then
                    print("should block " .. text);
                    return true
                end
            end
        end
    end
    return false
end

for i = 1, #events do
	ChatFrame_AddMessageEventFilter(events[i], eventHandler)
end


-- UIDropDownMenu_AddButton

