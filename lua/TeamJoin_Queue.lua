--Why? Because Queue team from 2013 did. Plus, it's good idea. Faster than players. DOES NOT TRICK SERVER BROWSER.

--Players go spectate, then RR, then team. This does same, but skips rr and does it faster than any human. NO TRICKERY INVOLVED.

local networkVars = 

{
  maxTeamSize = "private integer", --for directing. I dont wanna mess with vanilla target. eh?
} 



local cCreate = TeamJoin.OnCreate
function TeamJoin:OnCreate()
    cCreate(self)
    if Server then self.maxTeamSize = 12 end
end










if Server then


function TeamJoin:setMaxTeamSize(int)
   self.maxTeamSize = int
end

function TeamJoin:marineQueueEmpty()
  -- shine
end

function TeamJoin:alienQueueEmpty()
  -- shine
end


function TeamJoin:dequeueMarine()
  -- shine
end

function TeamJoin:dequeueAlien()
  -- shine
end


function TeamJoin:getMaxTeamSize()
  return self.maxTeamSize
end

local origU = TeamJoin.OnUpdate--if I overwrite this with shine then i can hook the 12 to a convar unless i write networkvar here

  function TeamJoin:OnUpdate()

     origU(self)                                                              --change 12 to plugin teamsize
        if self.teamNumber == 1 and self.playerCount < self:getMaxTeamSize() then
           if  self:marineQueueEmpty() == false then
            -- Print("Umm 1")
               self:dequeueMarine()
           end
        elseif self.teamNumber == 2  and self.playerCount < self:getMaxTeamSize() then
           if self:alienQueueEmpty()== false then
          --  Print("Umm 2")
               self:dequeueAlien()
           end
        end
  end


end

Shared.LinkClassToMap("TeamJoin", TeamJoin.kMapName, networkVars)