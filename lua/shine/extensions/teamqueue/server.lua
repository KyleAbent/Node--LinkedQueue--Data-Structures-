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






