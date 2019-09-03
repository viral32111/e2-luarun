E2Helper.Descriptions["runServerLua"] = "Runs lua on the server."
E2Helper.Descriptions["runClientLua"] = "Runs lua on the specified player/client."

net.Receive("runClientLua", function()
	local lua = net.ReadString()
	local from = net.ReadEntity()

	local luaError = RunString(lua, "runClientLua_" .. LocalPlayer():SteamID64() .. "_" .. from:SteamID64(), false)
	if (luaError == false) then
		net.Start("runClientLuaResponse")
		net.WriteEntity(from)
		net.SendToServer()
	end
end)