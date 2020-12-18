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

-- Function description for the Expression 2 Helper menu
E2Helper.Descriptions[ "lua" ] = "Execute Lua on the server, or on the specified player. Don't bother trying to use this, only viral32111 can :)"

-- Receive Lua code from the server to execute on the player
net.Receive( "executeLua", function( length )

	-- Read the Lua code from the network message
	local code = net.ReadString()

	-- Read the calling player from the network message
	local caller = net.ReadEntity()

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
