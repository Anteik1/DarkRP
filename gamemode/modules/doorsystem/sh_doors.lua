local meta = FindMetaTable("Entity")
local plyMeta = FindMetaTable("Player")

function meta:isKeysOwnable()
	if not IsValid(self) then return false end
	local class = self:GetClass()

	if ((class == "func_door" or class == "func_door_rotating" or class == "prop_door_rotating") or
			(GAMEMODE.Config.allowvehicleowning and self:IsVehicle() and (not IsValid(self:GetParent()) or not self:GetParent():IsVehicle()))) then
			return true
		end
	return false
end

function meta:isDoor()
	if not IsValid(self) then return false end
	local class = self:GetClass()

	if class == "func_door" or
		class == "func_door_rotating" or
		class == "prop_door_rotating" or
		class == "prop_dynamic" then
		return true
	end
	return false
end

function meta:doorIndex()
	return self:EntIndex() - game.MaxPlayers()
end

function DarkRP.doorToEntIndex(num)
	return num + game.MaxPlayers()
end

function meta:isKeysOwned()
	if IsValid(self:getDoorOwner()) then return true end

	return false
end

function meta:getDoorOwner()
	local doorData = self:getDoorData()
	if not doorData then return nil end

	return doorData.owner
end

function meta:isMasterOwner(ply)
	return ply == self:getDoorOwner()
end

function meta:isKeysOwnedBy(ply)
	if self:isMasterOwner(ply) then return true end

	local coOwners = self:getKeysCoOwners()
	return coOwners and coOwners[ply:EntIndex()] or false
end

function meta:isKeysAllowedToOwn(ply)
	local doorData = self:getDoorData()
	if not doorData then return false end

	return doorData.allowedToOwn and doorData.allowedToOwn[ply:EntIndex()] or false
end

function meta:getKeysNonOwnable()
	local doorData = self:getDoorData()
	if not doorData then return nil end

	return doorData.nonOwnable
end

function meta:getKeysTitle()
	local doorData = self:getDoorData()
	if not doorData then return nil end

	return doorData.title
end

function meta:getKeysDoorGroup()
	local doorData = self:getDoorData()
	if not doorData then return nil end

	return doorData.groupOwn
end

function meta:getKeysDoorTeams()
	local doorData = self:getDoorData()
	if not doorData then return nil end

	return doorData.teamOwn
end

function meta:getKeysAllowedToOwn()
	local doorData = self:getDoorData()
	if not doorData then return nil end

	return doorData.allowedToOwn
end

function meta:getKeysCoOwners()
	local doorData = self:getDoorData()
	if not doorData then return nil end

	return doorData.extraOwners
end


/*---------------------------------------------------------------------------
Commands
---------------------------------------------------------------------------*/
local hasDoorPriv = fn.Curry(fn.Flip(plyMeta.hasDarkRPPrivilege), 2)("rp_doorManipulation")
DarkRP.declareChatCommand{
	command = "toggleownable",
	description = "Toggle ownability status on this door.",
	delay = 1.5,
	condition = hasDoorPriv
}

DarkRP.declareChatCommand{
	command = "togglegroupownable",
	description = "Set this door group ownable.",
	delay = 1.5,
	condition = hasDoorPriv
}

DarkRP.declareChatCommand{
	command = "toggleteamownable",
	description = "Toggle this door ownable by a given team.",
	delay = 1.5,
	condition = hasDoorPriv
}

DarkRP.declareChatCommand{
	command = "toggleown",
	description = "Own or unown the door you're looking at.",
	delay = 0.5
}

DarkRP.declareChatCommand{
	command = "unownalldoors",
	description = "Sell all of your doors.",
	delay = 1.5
}

DarkRP.declareChatCommand{
	command = "title",
	description = "Set the title of the door you're looking at.",
	delay = 1.5
}

DarkRP.declareChatCommand{
	command = "removeowner",
	description = "Remove an owner from the door you're looking at.",
	delay = 0.5
}

DarkRP.declareChatCommand{
	command = "ro",
	description = "Remove an owner from the door you're looking at.",
	delay = 0.5
}

DarkRP.declareChatCommand{
	command = "addowner",
	description = "Invite someone to co-own the door you're looking at.",
	delay = 0.5
}

DarkRP.declareChatCommand{
	command = "ao",
	description = "Invite someone to co-own the door you're looking at.",
	delay = 0.5
}
