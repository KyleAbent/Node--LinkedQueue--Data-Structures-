--Kyle Abent  
--Todo: Aassert a certain amount of nodes is not exceeded by count just incase an exploit doesnt delete nodes correctly.
Script.Load("lua/shine/extensions/teamqueue/commands.lua")
Script.Load("lua/shine/extensions/teamqueue/teamQueue.lua")

local Plugin = Plugin
local Shine = Shine

Plugin.HasConfig = true
Plugin.ConfigName = "TeamQueue.json"
Plugin.DefaultConfig  = { kTeamCapSize = 12, kTeamQueueEnabled = false }


function Plugin:Initialise()
	self.Enabled = true
	self:CreateCommands() 
    self:initqueue()
	return true
end

function Plugin:MapPostLoad()
end



function Plugin:JoinTeam(gamerules, player, newteam, force, ShineForce)


    local AlienCount = gamerules:GetTeam2():GetNumPlayers()
    local MarineCount = gamerules:GetTeam1():GetNumPlayers()

    if newteam == 1 then
                  if  MarineCount >= self.Config.kTeamCapSize  then 
                  Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Marine Team Capped At " .. self.Config.kTeamCapSize )
                    return false
                  end
    elseif newteam == 2 then 
                if AlienCount >= self.Config.kTeamCapSize  then
                Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Alien Team Capped At " .. self.Config.kTeamCapSize )
                    return false
                end
    end
    
end


