-- Init
local frame = CreateFrame("FRAME", "AcceptDailies_Frame");
frame:RegisterEvent("GOSSIP_SHOW");
frame:RegisterEvent("QUEST_GREETING");
frame:RegisterEvent("QUEST_DETAIL");
frame:RegisterEvent("MODIFIER_STATE_CHANGED");
-- Saved globals
ad_PermDisable = false;
ad_DEBUG = false;
-- Locals
local ad_TempDisable = false;

-- Event handler
local function eventHandler(self, event)
	if (ad_DEBUG) then
		print('ad_eventHandler:', event);
		print('ad_PermDisable', ad_PermDisable);
		print('ad_TempDisable', ad_TempDisable);
	end

	-- Track modifier changes
	if (event == "MODIFIER_STATE_CHANGED") then
		ad_ModiferChange();
		return;
	end

	-- Do not accept quests or click through dialogs while disabled
	if (ad_isDisabled()) then
		return;
	end

	-- Track new gossip/greeting frames
	if (event == "GOSSIP_SHOW") then
		ad_GossipShow();
	elseif (event == "QUEST_GREETING") then
		ad_QuestGreeting();
	elseif (event == "QUEST_DETAIL") then
		ad_QuestDetail();
	end
end
frame:SetScript("OnEvent", eventHandler);

-- Slash commands
SLASH_ACCEPTDAILIES1, SLASH_ACCEPTDAILIES2 = '/ad', '/acceptdailies';
SlashCmdList["ACCEPTDAILIES"] = function(msg, editbox)
	local outmsg = "Unrecognized command";
	msg = string.lower(msg);
	
	if (msg == 'disable') then
		ad_PermDisable = true;
		outmsg = "Disabled";
	elseif (msg == 'enable') then
		ad_PermDisable = false;
		outmsg = "Enabled";
	elseif (msg == 'debug') then
		if (ad_DEBUG) then
			ad_DEBUG = false;
			outmsg = "Debug Disabled";
		else
			ad_DEBUG = true;
			outmsg = "Debug Enabled";
		end
	end
	print("AcceptDailies: " .. outmsg);
end

local dailyQuests = {
	-- PVP - Bone Wastes
	"Spirits of Auchindoun",
	
	-- PvP - Halaa
	"In Defense of Halaa",
	"Enemies, Old and New",
		
	-- PvP - Battlegrounds
	"Call to Arms: Alterac Valley",
	"Call to Arms: Arathi Basin",
	"Call to Arms: Warsong Gulch",
	"Call to Arms: Eye of the Storm",
	"Call to Arms: Strand of the Ancients",
	"Call to Arms: Isle of Conquest",
	
	-- PvP - Venture Bay
	"Down With Captain Zorna!",
	"Keep Them at Bay!",
	"Pieces Parts",
	"Riding the Red Rocket",
	"Shredder Repair",
	"Smoke 'Em Out",
	"Blackriver Brawl",
	"Crush Captain Brightwater!",
	"Riding the Red Rocket",
	"Seeking Solvent",
		
	-- Valiance Expedition
	"Break the Blockade",
	"Capture More Dispatches",
	"Blackriver Skirmish",
	"Life or Death",
	"Kick 'Em While They're Down",
	
	-- Warsong Offensive
	"Keep 'Em on Their Heels",
	"Making Repairs",
	"Overwhelmed!",
	"Shred the Alliance",
	"Keeping the Alliance Blind",

	-- Valiance Expedition / Warsong Offensive
	"Assault by Air",
	"Assault by Ground",
	"Blood of the Chosen",
	"King of the Mountain",
	
	-- PvP Hellfire Peninsula
	"Hellfire Fortifications",	

	-- Dalaran Cooking
	"Cheese for Glowergold",
	"Convention at the Legerdemain",
	"Infused Mushroom Meatloaf",
	"Mustard Dogs!",
	"Sewer Stew",
	
	-- Dalaran Fishing
	"Blood Is Thicker",
	"Dangerously Delicious",
	"Disarmed!",
	"Jewel Of The Sewers",
	"Monsterbelly Appetite",
	"The Ghostfish",
	
	-- Shattrath Cooking
	"Manalicious",
	"Revenge is Tasty",
	"Soup for the Soul",
	"Super Hot Stew",
	
	-- Shattrath Fishing
	"Crocolisks in the City",
	"Bait Bandits",
	"Felblood Fillet",
	"Shrimpin' Ain't Easy",
	"The One That Got Away",
	
	-- Jewelcrafting
	"Shipment: Blood Jade Amulet",
	"Shipment: Bright Armor Relic",
	"Shipment: Glowing Ivory Figurine",
	"Shipment: Intricate Bone Figurine",
	"Shipment: Shifting Sun Curio",
	"Shipment: Wicked Sun Brooch",
		
	-- Kalu'ak
	"Preparing for the Worst",
	"Planning for the Future",
	"The Way to His Heart...",

	-- The Wyrmrest Accord
	"Aces High!",
	"Drake Hunt",
	"Defending Wyrmrest Temple",
	
	-- Shattered Sun Offensive
	"Your Continued Support",
	"Arm the Wards!",
	"Crush the Dawnblade",
	"Disrupt the Greengill Coast",
	"Don't Stop Now...",
	"Further Conversions",
	"Open for Business",
	"Keeping the Enemy at Bay",
	"The Air Strikes Must Continue",
	"The Battle Must Go On",
	"Sunfury Attack Plans",
	"Blast the Gateway",
	"Blood for Blood",
	"Ata'mal Armaments",
	"Gaining the Advantage",
	"Rediscovering Your Roots",
	"The Multiphase Survey",
	"Maintaining the Sunwell Portal",
	"Know Your Ley Lines",
	
	-- Netherwing
	"A Slow Death",
	"Nethercite Ore",
	"Netherdust Pollen",
	"Nethermine Flayer Hide",
	"Netherwing Crystals",
	"The Not-So-Friendly Skies...",
	"Picking Up The Pieces...",	
	"Disrupting the Twilight Portal",
	"Dragons are the Least of Our Problems",
	"The Booterang: A Cure For The Common Worthless Peon",
	"The Deadliest Trap Ever Laid",
	
	-- Argent Tournament
	"A Blade Fit For A Champion", 
	"A Chip Off the Ulduar Block",
	"A Leg Up", 
	"A Valiant's Field Training",
	"A Worthy Weapon", 
	"Among the Champions", 
	"At The Enemy's Gates", 
	"Battle Before The Citadel", 
	"Breakfast Of Champions", 
	"Contributin' To The Cause",
	"Deathspeaker Kharos",
	"Drottinn Hrothgar",
	"Get Kraken!", 
	"Gormok Wants His Snobolds",
	"Identifying the Remains",
	"Jack Me Some Lumber",
	"Learning The Reins", 
	"Mistcaller Yngvar",
	"Ornolf The Scarred", 
	"Rescue at Sea",
	"Stop The Aggressors",
	"Taking Battle To The Enemy", 
	"The Edge Of Winter", 
	"The Fate Of The Fallen", 
	"The Grand Melee", 
	"The Light's Mercy", 
	"Threat From Above", 
	"Training In The Field", 
	"What Do You Feed a Yeti, Anyway?", 
	"You've Really Done It This Time, Kul",
	
	-- Argent Crusade
	"Troll Patrol: Can You Dig It?",
	"Troll Patrol: High Standards",
	"Troll Patrol: Something for the Pain",
	"Troll Patrol: Couldn't Care Less",
	"Troll Patrol: Creature Comforts",
	"Troll Patrol: Whatdya Want, a Medal?",
	"Troll Patrol: Done to Death",
	"Troll Patrol: Intestinal Fortitude",
	"Troll Patrol: Throwing Down",
	"Troll Patrol: The Alchemist's Apprentice",
	"Congratulations!",

	-- Explorers League
	"Steel Gate Patrol",
	
	-- The Frostborn
	"Pushed Too Far", 
	
	-- The Oracles 
	"Hand of the Oracles", 
	"Mastery of the Crystals",
	"Will of the Titans", 
	"Power of the Great Ones", 
	"Appeasing the Great Rain Stone", 
	"A Cleansing Song", 
	"Song of Fecundity", 
	"Song of Reflection", 
	"Song of Wind and Water", 
	
	-- Frenzyheart Tribe 
	"Frenzyheart Champion",
	"Kartak's Rampage", 
	"Tools of War",
	"Secret Strength of the Frenzyheart", 
	"A Hero's Headgear", 
	"Chicken Party!", 
	"Rejek: First Blood", 
	"Strength of the Tempest", 
	"The Heartblood's Strength", 
	
	-- Sons of Hodir 
	"Blowing Hodir's Horn", 
	"Feeding Arngrim", 
	"Hot and Cold", 
	"Polishing the Helm", 
	"Spy Hunter", 
	"Thrusting Hodir's Spear", 
	
	-- Brunnhildar Village
	"Back to the Pit", 
	"Defending Your Title", 
	"Maintaining Discipline", 
	"The Aberrations Must Die", 
	
	-- K3 
	"Overstock", 
	
	-- Ebon Blade 
	"From Their Corpses, Rise!",
	"Intelligence Gathering", 
	"Leave Our Mark",
	"No Fly Zone", 
	"Vile Like Fire!", 
	"Shoot 'Em Up", 
	
	-- Brewfest
	"Bark for Drohn's Distillery!",
	"Bark for T'chali's Voodoo Brewery!",
	"Bark for the Barleybrews!",
	"Bark for the Thunderbrews!",
	
	-- Blade's Edge Mountains (Sha'tari Skyguard / Ogri'la)
	"Banish More Demons",
	"Bomb Them Again!",
	"Escape from Skettis",
	"Fires Over Skettis",
	"The Relic's Emanation",
	"Wrangle More Aether Rays!",
	
	-- Icecrown (The Skybreaker / Orgrim's Hammer)
	"Drag and Drop",
	"No Mercy!",
	"The Solution Solution",
	"Retest Now",
	"That's Abominable!",
	"Not a Bug",
	"Neutralizing the Plague",
	"No Rest For The Wicked",
	"Keeping the Alliance Blind",
	"Volatility",
	
	-- Icecrown (Aldur'thar: The Desolation Gate)
	"Putting the Hertz: The Valley of Lost Hope",
	"Static Shock Troops: the Bombardment",
	"Total Ohmage: The Valley of Lost Hope!",
	"Riding the Wavelength: The Bombardment",
	
	-- Un'Goro Crater
	"Gorishi Grub",	
	
	-- Grizzly Hills
	"Shipment: Wicked Sun Brooch",
	
	-- Shattrath Dungeon Dailies
	"Wanted: Arcatraz Sentinels",
	"Wanted: Coilfang Myrmidons",
	"Wanted: Malicious Instructors",
	"Wanted: Rift Lords",
	"Wanted: Shattered Hand Centurions",
	"Wanted: Sisters of Torment",
	"Wanted: Sunseeker Channelers",
	"Wanted: Tempest-Forge Destroyers",
	"Wanted: Nazan's Riding Crop",
	"Wanted: Keli'dan's Feathered Stave",
	"Wanted: Bladefist's Seal",
	"Wanted: The Heart of Quagmirran",
	"Wanted: A Black Stalker Egg",
	"Wanted: The Warlord's Treatise",
	"Wanted: The Headfeathers of Ikiss",
	"Wanted: Shaffar's Wondrous Pendant",
	"Wanted: The Exarch's Soul Gem",
	"Wanted: Murmur's Whisper",
	"Wanted: The Epoch Hunter's Head",
	"Wanted: Aeonus's Hourglass",
	"Wanted: A Warp Splinter Clipping",
	"Wanted: Pathaleon's Projector",
	"Wanted: The Scroll of Skyriss",
	"Wanted: The Signet Ring of Prince Kael'thas",
	
	-- Midsummer Festival
	"Honor the Flame",
	"Desecrate this Fire!",
	"Summon Ahune",
	"Torch Tossing",
	"Torch Catching",
	"More Torch Tossing",
	"More Torch Catching",
	
	-- Pilgrim's Bounty
	"Can't Get Enough Turkey",
	"Don't Forget The Stuffing!",
	"Easy As Pie",
	"We're Out of Cranberry Chutney Again?",
	"She Says Potato",
	
	-- Hallow's End
	"Let the Fires Come!",
	"Call the Headless Horseman",
	"Stop the Fires!",
	"Smash the Pumpkin",
	
	-- Love is in the Air
	"A Cloudlet of Classy Cologne",
	"A Gift for the Banshee Queen",
	"A Gift for the High Chieftain",
	"A Gift for the High Priestess of Elune",
	"A Gift for the King of Stormwind",
	"A Gift for the Lord of Ironforge",
	"A Gift for the Prophet",
	"A Gift for the Regent Lord of Quel'Thalas",
	"A Gift for the Warchief",
	"A Perfect Puff of Perfume",
	"Bonbon Blitz",
	"Crushing the Crown"
};

local weeklyQuests = {
	--Dalaran Raid
	"Anub'Rekhan Must Die!",
	"Flame Leviathan Must Die!",
	"Ignis the Furnace Master Must Die!",
	"Instructor Razuvious Must Die!",
	"Lord Jaraxxus Must Die!",
	"Malygos Must Die!",
	"Noth the Plaguebringer Must Die!",
	"Patchwerk Must Die!",
	"Razorscale Must Die!",
	"Sartharion Must Die!",
	"XT-002 Deconstructor Must Die!",
	
	--Icecrown
	"Deprogramming",
	"Securing the Ramparts",
	"Residue Rendezvous",
	"Blood Quickening",
	"Respite for a Tormented Soul",
	
	--Wintergrasp
	"Defend the Siege",
	"No Mercy for the Merciless",
	"Stop the Siege",
	"Victory in Wintergrasp",
	"Slay them all!",
	"A Rare Herb",
	"Healing with Roses",
	"Bones and Arrows",
	"Fueling the Demolishers",
	"Jinxing the Walls",
	"Warding the Walls",
	"Warding the Warriors",
	
	--Dalaran Fishing
	"Better Luck Next Time",
}

-- Search the gossip text for available quests
function ad_GossipShow()
	local q = { GetGossipAvailableQuests() };
	local i = 1;
	local accept = 0;
	while(q[i]) do
		if (ad_DEBUG) then
			print('ad_GossipShow: Checking quest:', q[i]);
		end
	
		-- Check daily
		if (accept > 0) then
			break;
		end
		for j,v in ipairs(dailyQuests) do
			if (q[i] == v) then
				accept = ((i - 1) / 3) + 1;
				break;
			end
		end
		
		-- Check weekly
		if (accept > 0) then
			break;
		end
		for j,v in ipairs(weeklyQuests) do
			if (q[i] == v) then
				accept = ((i - 1) / 3) + 1;
				break;
			end
		end
		
		-- Loop control
        i = i + 3;
    end

	-- Select the quest
	if (accept > 0) then
		if (ad_DEBUG) then
			print('ad_GossipShow: Selecting quest:', q[accept]);
		end
		SelectGossipAvailableQuest(accept);
	end
end

-- Search the quest greeting for available quests
function ad_QuestGreeting()
	local numQ = GetNumAvailableQuests();
	local accept = 0;
	for i=1,numQ do
		local qName = GetAvailableTitle(i);
		if (ad_DEBUG) then
			print('ad_QuestGreeting: Checking quest:', qName);
		end
		
		-- Check daily
		if (accept > 0) then
			break;
		end
		for j,v in ipairs(dailyQuests) do
			if (qName == v) then
				accept = i;
				break;
			end
		end
			
		-- Check weekly
		if (accept > 0) then
			break;
		end
		for j,v in ipairs(weeklyQuests) do
			if (qName == v) then
				accept = i;
				break;
			end
		end
	end

	-- Select quest
	if (accept > 0) then
		if (ad_DEBUG) then
			print('ad_QuestGreeting: Selecting quest:', GetAvailableTitle(accept));
		end
		SelectAvailableQuest(accept);
	end
end

-- Automatically accept quests named in the dailyQuests array
function ad_QuestDetail()
	local accept = false;
	local qName = GetTitleText();
	if (ad_DEBUG) then
		print('ad_QuestDetail: Checking quest: ', qName);
	end

	-- Check daily
	if (not accept) then
		for j,v in ipairs(dailyQuests) do
			if (qName == v) then
				accept = true;
				break;
			end
		end
	end
		
	-- Check weekly
	if (not accept) then
		for j,v in ipairs(weeklyQuests) do
			if (qName == v) then
				accept = true;
				break;
			end
		end
	end
	
	-- Accept the quest
	if (accept) then
		if (ad_DEBUG) then
			print('ad_QuestDetail: Accepting quest: ', qName);
		end
		AcceptQuest();
	end
end

-- Temporarily disable processing if the hotkey is pressed
-- Currently hard-coded to shift, but abstracted to a function should I ever to to writing a UI to allow user configuration
function ad_ModiferChange()
	if (IsShiftKeyDown()) then
		ad_TempDisable = true;
	else
		ad_TempDisable = false;
	end
end

-- Return true if AD is disabled for any reason
function ad_isDisabled()
	if (ad_TempDisable or ad_PermDisable) then
		return true;
	end
	return false;
end
