/*
  Kyle Abent
  Alright, the node , linked was fun. However unnecessary. Why am I trying to avoid loops with only 6 count? Such need is only useful with large data quantity. 
  GameState -- For every reset, reset the queue ?
*/

function Plugin:SetGameState( Gamerules, State, OldState )
     if State == kGameState.Team1Won or State == kGameState.Team2Won or State == kGameState.Draw then
        self:initqueue()
     end
end
function Plugin:initqueue()
	self.marineQueue = {} 
    self.alienQueue = {}
    --self.teamQueue[priority] = {userid = steamid, team = desiredteam} -- teamnum function parameter reducing function count
    
    --Improvement would be to write for one, and adjust for two. I'm writing for two, and it's confusing.
end
function Plugin:alienLeaveQueue(player)
--       Print("1")
      local i = self:getIsAlienQueue(player)
      if i then
          -- Print("2 " .. i)
            self.alienQueue[i] = nil
            self:adjustHigherPriorityAlien() 
            Print("Player Removed from Alien Queue")
             Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You've been removed from the Alien Team Queue" )
      end

end


function Plugin:marineLeaveQueue(player)
     --  Print("1")
      local i = self:getIsMarineQueue(player)
      if i then
        --  Print("2 " .. i)
            self.alienQueue[i] = nil 
            self:adjustHigherPriorityMarine() 
            Print("Player Removed from Marine Queue")
             Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You've been removed from the Marine Team Queue" )
      end
end

function Plugin:getIsAlienQueue(player)

      for i = 1, #self.alienQueue do
      local current = self.alienQueue[i]
          if current.id and current.id ==  player:GetClient():GetUserId()  then
            return i
          end
      
      end
      return false
end


function Plugin:getIsMarineQueue(player)

      for i = 1, #self.marineQueue do
      local current = self.marineQueue[i]
          if current.id and current.id == player:GetClient():GetUserId() then
            return i
          end
      end
      
      return false
end
function Plugin:marinePrint()
       Print("Marine Front")
      for i = 1, #self.marineQueue do
         local current = self.marineQueue[i]
            if current.id then
               Print("Priority: %s, ID: %s", i, current.id)
            end
      end
       Print("Marine Back")
end
function Plugin:alienPrint()
       Print("Alien Front")
      for i = 1, #self.alienQueue do
      local current = self.alienQueue[i]
            if current.id then
               Print("Priority: %s, ID: %s", i, current.id)
            end
      end
       Print("Alien Back")
end

/*

function Plugin:ClientDisconnect(Client)
       --if in queue, adjust.
end
*/


function Plugin:alienEnqueue(player)--only if gamestarted
        Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Alien Team Full" )
        if self:getIsMarineQueue(player) then
                        Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You're now in a queue for both teams. Whichever has a spot open first (combined with your priority)" )
        end
        if not self:getIsAlienQueue(player) then
              local i = #self.alienQueue ~= 0 and #self.alienQueue or 1
              self.alienQueue[i] = { id = player:GetClient():GetUserId() }  
              Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You've entered the Alien Queue at priority # " .. #self.alienQueue )
        else
              Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You've already entered the Alien Team Queue" )
        end
        self:alienPrint()
end

function Plugin:marineEnqueue(player)--only if gamestarted
        Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Marine Team Full" )
        if self:getIsAlienQueue(player) then
            Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You're now in a queue for both teams. Whichever has a spot open first (combined with your priority)" )
        end
        if not self:getIsMarineQueue(player) then
               local i = #self.marineQueue ~= 0 and #self.marineQueue or 1
              self.marineQueue[i] = { id = player:GetClient():GetUserId() }
              Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You've entered the Marine Queue at priority # " .. #self.marineQueue )
        else
              Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You've already entered the Marine Team Queue" )
        end
        self:marinePrint()
end


function Plugin:JoinTeam(gamerules, player, newteam, force, ShineForce)


    local AlienCount = gamerules:GetTeam2():GetNumPlayers()
    local MarineCount = gamerules:GetTeam1():GetNumPlayers()

    if newteam == 1 then
                  if  MarineCount >= self.Config.kTeamCapSize  then 
                  Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Marine Team Capped At " .. self.Config.kTeamCapSize )
                    return false
                  elseif MarineCount < AlienCount then
                  self:alienLeaveQueue(player)
                  self:marineLeaveQueue(player)
                  end
    elseif newteam == 2 then 
                if AlienCount >= self.Config.kTeamCapSize  then
                Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Alien Team Capped At " .. self.Config.kTeamCapSize )
                    return false
                  elseif MarineCount < AlienCount then
                  self:alienLeaveQueue(player)
                  self:marineLeaveQueue(player)
                end
    end
    
end



Shine.Hook.SetupClassHook( "TeamJoin", "alienQueueEmpty", "isalienQueueEmpty", "Replace" )


function Plugin:isalienQueueEmpty(player) 
         return #self.alienQueue == 0
end


Shine.Hook.SetupClassHook( "TeamJoin", "marineQueueEmpty", "ismarineQueueEmpty", "Replace" )


function Plugin:ismarineQueueEmpty(player) 
         return #self.marineQueue == 0
end



Shine.Hook.SetupClassHook( "TeamJoin", "dequeueMarine", "dodequeueMarine", "Replace" )


function Plugin:dodequeueMarine() 
          local Gamerules = GetGamerules()
            local player =  self.marineQueue[1].id
             if player then
            Shared.ConsoleCommand( string.format("sh_setteam %s 1",player )) 
            Shared.ConsoleCommand( string.format("sh_pm %s You've been de-queue-d. ",player )) 
             end 
             self.marineQueue[1] = nil  
             self:adjustHigherPriorityMarine()
end

Shine.Hook.SetupClassHook( "TeamJoin", "dequeueAlien", "dodequeueAlien", "Replace" )


function Plugin:dodequeueAlien()
          local Gamerules = GetGamerules()
            local player = self.alienQueue[1].id
             if player then
             Shared.ConsoleCommand( string.format("sh_setteam %s 2",player )) 
              Shared.ConsoleCommand( string.format("sh_pm %s You've been de-queue-d. ",player )) 
             end
             self.alienQueue[1] = nil
             self:adjustHigherPriorityAlien() 
end
 --Kyle Abent
function Plugin:adjustHigherPriorityAlien()
   for i = 1, #self.alienQueue do
        local current = self.alienQueue[i]
        local next = self.alienQueue[i+1]
            
        
        if next then
           current = next
            local player = current.id
             if player then
                   Shared.ConsoleCommand( string.format("sh_pm %s Your new priority for Alien Queue is %s ", player, i    ) ) 
             end 
        end
        
   end
   
   return count

end

function Plugin:adjustHigherPriorityMarine()
   for i = 1, #self.marineQueue do
        local current = self.marineQueue[i]
        local next = self.marineQueue[i+1]
              
        
        if next then
           current = next
            local player =  current.id
             if player then
                   Shared.ConsoleCommand( string.format("sh_pm %s Your new priority for Marine Queue is %s", player, i  ) ) 
             end 
        end
        
   end
   
   return count

end