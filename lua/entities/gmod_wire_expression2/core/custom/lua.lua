--[[-------------------------------------------------------------------
This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <http://unlicense.org/>
-------------------------------------------------------------------]]--

-- Register the Expression 2 core
E2Lib.RegisterExtension( "lua", false, "Allows anyone to execute Lua on the server or any connected players.", "WARNING! This allows anyone to a remotely execute server commands, manipulate configs and read all server or client data!" )

-- Initalise some network strings
util.AddNetworkString( "executeLua" )
util.AddNetworkString( "respondLua" )

-- Receive possible error messages from players
net.Receive( "respondLua", function( length, sender )

	-- Read the error from the network message
	local error = net.ReadString()

	-- Read the calling player from the network message
	local caller = net.ReadEntity()

	-- Notify the calling player
	WireLib.AddNotify( caller, "There was an error with your Lua code (check server console)", NOTIFY_ERROR, 5, NOTIFYSOUND_ERROR1 )

	-- Print the message to the console
	print( "Error with Lua code from Expression 2 (" .. sender:Nick() .. "): ", error )

end )

-- Set the cost of all functions below this point
__e2setcost( 10 )

-- E2 function to run Lua on the server
e2function void lua( string code )

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

	-- Start the network message
	net.Start( "executeLua" )

		-- Add the Lua code to the network message
		net.WriteString( code )

		-- Add the calling player to the network message
		net.WriteEntity( self.player )

	-- Send the network message to the player
	net.Send( player )

end
