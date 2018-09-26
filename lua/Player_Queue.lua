--Because I would rather not add a for loop of everyone in queue checking for one player in queue when i can just add these options
--Could be better as readyroomplayer. 
local networkVars = 

{ 
  queueTeam = "integer",
  alienQueue = "boolean",
  marineQueue = "boolean",
  --priority -- im not adding this here, regardless of it not losing spot when switching RR to spect for spot saving
}

local origC = Player.OnCreate
function Player:OnCreate()
    origC(self)
    self.queueTeam = 0
    self.alienQueue = false
    self.marineQueue = false
end
local origR = Player.Reset
function Player:Reset()
    origR(self)
    self.queueTeam = 0
end

function Player:setMarineQueue()
   self.queueTeam = 1
   self.marineQueue = true
end

function Player:setAlienQueue()
 self.queueTeam = 2
  self.alienQueue = true
end

function Player:setNoQueue(player)
 self.queueTeam = 0
end

function Player:getIsMarineQueue()
  return self.queueTeam == 1 and self.marineQueue
end

function Player:getIsAlienQueue()
return self.queueTeam == 2 and self.alienQueue
end

function Player:getIsBothQueue()
return self.marineQueue and self.alienQueue
end

function Player:getQueue()
return self.queueTeam
end

  if Server then
    --For spectators team 3 and transitioning from Player to Spectator(Player)
    local orig = Player.CopyPlayerDataFrom
    function Player:CopyPlayerDataFrom(player)
    orig(self, player)
    self.queueTeam = player.queueTeam
    end

  end


Shared.LinkClassToMap("Player", Player.kMapName, networkVars)