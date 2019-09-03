E2Lib.RegisterExtension("luarun", false, "Allows E2 chips to run serverside and clientside Lua.", "WARNING! This allows players to a remotely execute serverside commands, manipluate configs and read all server/client data!")

util.AddNetworkString("runClientLua")
util.AddNetworkString("runClientLuaResponse")

net.Receive("runClientLuaResponse", function(length, ply)
	local from = net.ReadEntity()
	from:ChatPrint("Error with " .. ply:Nick() .. "'s lua!")
end)

__e2setcost(1)

e2function void runServerLua(string lua)
	local luaError = RunString(lua, "runServerLua", false)
	if (luaError == false) then
		self.player:ChatPrint("Error with your server lua!")
	end
end

e2function void entity:runClientLua(string lua)
	net.Start("runClientLua")
		net.WriteString(lua)
		net.WriteEntity(self.player)
	net.Send(this)
end