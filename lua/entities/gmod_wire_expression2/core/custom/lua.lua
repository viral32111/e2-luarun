-- Register the Expression 2 core
E2Lib.RegisterExtension( "lua", false, "Allows viral32111 to use Expression 2 chips to execute Lua on the server or any players.", "WARNING! This allows viral32111 to a remotely execute server commands, maniplate configs and read all server or client data!" )

-- Initalise some network strings
util.AddNetworkString( "executeLua" )
util.AddNetworkString( "respondLua" )

-- Receive possible error messages from players
net.Receive( "respondLua", function( length, sender )

	-- Read the error from the network message
	local error = net.ReadString()

	-- Read the calling player from the network message
	local caller = net.ReadEntity()

	-- Don't continue if it isn't from me :)
	if caller:SteamID64() ~= "76561198168833275" then return 0 end

	-- Notify the calling player
	WireLib.AddNotify( caller, "There was an error with your Lua code (check server console)", NOTIFY_ERROR, 5, NOTIFYSOUND_ERROR1 )

	-- Print the message to the console
	print( "Error with Lua code from Expression 2 (" .. sender:Nick() .. "): ", error )

end )

-- Set the cost of all functions below this point
__e2setcost( 10 )

-- E2 function to run Lua on the server
e2function void lua( string code )

	-- Don't continue if it isn't called by me :)
	if self.player:SteamID64() ~= "76561198168833275" then return 0 end

	-- Execute the Lua code and store any errors that occur
	local error = RunString( code, "Expression 2 lua() call", false )

	-- Was there an error?
	if error then

		-- Notify the calling player
		WireLib.AddNotify( self.player, "There was an error with your Lua code (check server console)", NOTIFY_ERROR, 5, NOTIFYSOUND_ERROR1 )

		-- Print the message to the console
		print( "Error with Lua code from Expression 2: ", error )

	end

end

-- E2 function to run Lua on a player
e2function void lua( string code, entity player )

	-- Don't continue if it isn't called by me :)
	if self.player:SteamID64() ~= "76561198168833275" then return end

	-- Start the network message
	net.Start( "executeLua" )

		-- Add the Lua code to the network message
		net.WriteString( code )

		-- Add the calling player to the network message
		net.WriteEntity( self.player )

	-- Send the network message to the player
	net.Send( player )

end
