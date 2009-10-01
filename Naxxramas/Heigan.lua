----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewBoss("Heigan the Unclean", "Naxxramas")
if not mod then return end
mod:RegisterEnableMob(15936)
mod.toggleOptions = {"engage", "teleport", "bosskill"}

----------------------------
--      Localization      --
----------------------------

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Heigan the Unclean", "enUS", true)
if L then
	L.starttrigger = "You are mine now."
	L.starttrigger2 = "You... are next."
	L.starttrigger3 = "I see you..."

	L.engage = "Engage"
	L.engage_desc = "Warn when Heigan is engaged."
	L.engage_message = "Heigan the Unclean engaged! 90 sec to teleport!"

	L.teleport = "Teleport"
	L.teleport_desc = "Warn for Teleports."
	L.teleport_trigger = "The end is upon you."
	L.teleport_1min_message = "Teleport in 1 min"
	L.teleport_30sec_message = "Teleport in 30 sec"
	L.teleport_10sec_message = "Teleport in 10 sec!"
	L.on_platform_message = "Teleport! On platform for 45 sec!"

	L.to_floor_30sec_message = "Back in 30 sec"
	L.to_floor_10sec_message = "Back in 10 sec!"
	L.on_floor_message = "Back on the floor! 90 sec to next teleport!"

	L.teleport_bar = "Teleport!"
	L.back_bar = "Back on the floor!"
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Heigan the Unclean")
mod.locale = L

------------------------------
--      Initialization      --
------------------------------

function mod:OnBossEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Death("Win", 15936)
end

------------------------------
--      Event Handlers      --
------------------------------

local function backToRoom()
	mod:Message("teleport", L["on_floor_message"], "Attention")
	mod:DelayedMessage("teleport", 60, L["teleport_30sec_message"], "Urgent")
	mod:DelayedMessage("teleport", 80, L["teleport_10sec_message"], "Important")
	mod:Bar("teleport", L["teleport_bar"], 90, "Spell_Arcane_Blink")
end

function mod:CHAT_MSG_MONSTER_YELL(event, msg)
	if msg:find(L["starttrigger"]) or msg:find(L["starttrigger2"]) or msg:find(L["starttrigger3"]) then
		self:Message("engage", L["engage_message"], "Important")
		self:Bar("teleport", L["teleport_bar"], 90, "Spell_Arcane_Blink")
		self:DelayedMessage("teleport", 30, L["teleport_1min_message"], "Attention")
		self:DelayedMessage("teleport", 60, L["teleport_30sec_message"], "Urgent")
		self:DelayedMessage("teleport", 80, L["teleport_10sec_message"], "Important")
	elseif msg:find(L["teleport_trigger"]) then
		self:ScheduleEvent("BWBackToRoom", backToRoom, 45)
		self:Message("teleport", L["on_platform_message"], "Attention")
		self:DelayedMessage("teleport", 15, L["to_floor_30sec_message"], "Urgent")
		self:DelayedMessage("teleport", 35, L["to_floor_10sec_message"], "Important")
		self:Bar("teleport", L["back_bar"], 45, "Spell_Magic_LesserInvisibilty")
	end
end

