function Plugin:CreateCommands()

local function LeaveQueue(Client)
   local Player = Client:GetControllingPlayer()
   Player:setNoQueue(Player)
end


	local LeaveTeamQueueCommand = self:BindCommand( "sh_leavequeue", "leavequeue" , LeaveQueue, true )
    LeaveTeamQueueCommand:Help( "leave team queue" )
    
local function TeamCap(Client, Number)
  self.Config.kTeamCapSize = Number
  Shine:NotifyDualColour( nil, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Team Cap Size has been changed to " .. Number )
end


	local TeamCapCommand = self:BindCommand( "sh_teamcap", "teamcap" , TeamCap )
	TeamCapCommand:AddParam{ Type = "number" }
    TeamCapCommand:Help( "Sets team cap size" )
    
local function TeamQueue(Client, Boolean)
  self.Config.kTeamQueueEnabled = Boolean
     if Boolean == true then
       Shine:NotifyDualColour( nil, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Team Queue has been set to  true " )
     else
       Shine:NotifyDualColour( nil, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Team Queue has been set to  false " )
     end

end


	local TeamQueueCommand = self:BindCommand( "sh_teamqueue", "teamqueue" , TeamQueue )
	TeamQueueCommand:AddParam{ Type = "boolean" }
    TeamQueueCommand:Help( "Enables or disables team queue" )
    


end