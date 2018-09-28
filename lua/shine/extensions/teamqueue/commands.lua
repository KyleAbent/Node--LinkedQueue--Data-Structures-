function Plugin:CreateCommands()

local function JoinQueue(Client, Number)
   local Player = Client:GetControllingPlayer()
   if Player:GetTeamNumber() ~= 3 then
     Shine:NotifyDualColour( Player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You must be spectator, and team size must be " .. self.Config.kTeamCapSize )
     return
   end
     
    
   if Number == 1 then
     if   GetGamerules():GetTeam1():GetNumPlayers() >= self.Config.kTeamCapSize then
       if self:getIsAlienQueue(Player) then
          Shine:NotifyDualColour( Player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You're already in the Alien Queue"   )
          Shine:NotifyDualColour( Player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "M > Proving Ground > TeamQueue > Join Both or sh_joinqueue 3"   )
          return
       end
     self:marineEnqueue(Player)
     else
     Shine:NotifyDualColour( Player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Team Size must be  " .. self.Config.kTeamCapSize  )
     end
   elseif Number == 2  then
       if self:getIsMarineQueue(Player) then
          Shine:NotifyDualColour( Player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You're already in the Marine Queue"   )
          Shine:NotifyDualColour( Player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "M > Proving Ground > TeamQueue > Join Both or sh_joinqueue 3"   )
          return
       end
     if   GetGamerules():GetTeam2():GetNumPlayers() >= self.Config.kTeamCapSize then
     self:alienEnqueue(Player)
     else
     Shine:NotifyDualColour( Player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Team Size must be " .. self.Config.kTeamCapSize  )
     end
     
   elseif Number == 3 then
       Shine:NotifyDualColour( Player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Attempting to join both team queue"   )
       self:marineEnqueue(Player)
       self:alienEnqueue(Player)
   end
   
end


	local JoinQueueQueueCommand = self:BindCommand( "sh_joinqueue", "joinqueue" , JoinQueue, true )
		JoinQueueQueueCommand:AddParam{ Type = "number" }
    JoinQueueQueueCommand:Help( "leave team queue" )
    
    
local function LeaveQueue(Client)
   local Player = Client:GetControllingPlayer()
   self:alienLeaveQueue(Player)
   self:marineLeaveQueue(Player)
end


	local LeaveTeamQueueCommand = self:BindCommand( "sh_leavequeue", "leavequeue" , LeaveQueue, true )

    
local function TeamCap(Client, Number)--Assert Number <= 12
  self.Config.kTeamCapSize = Number
  Shine:NotifyDualColour( nil, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Team Cap Size has been changed to " .. Number )
  Shine:NotifyDualColour( nil, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "If Team Queue is enabled then it will apply to team queue size requirement (Default 12)" )
  --SetTeamJoinMaxTeamSize(Number)
  GetMarineTeamJoin():setMaxTeamSize(Number)
  GetAlienTeamJoin():setMaxTeamSize(Number)
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