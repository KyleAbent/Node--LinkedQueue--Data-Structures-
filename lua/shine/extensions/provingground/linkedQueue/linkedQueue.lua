--Kyle Abent -- Data Structures -- linked Queue (Java to Lua) -- better perf, less time
 --J3 Queue

  class 'linkedQueue' (Entity)
  linkedQueue.kMapName = "linkedqueue"


   local networkVars = 
{
    front = "private entityid",
    back = "private entityid",
    sett = "integer",
    size = "integer",
}

function linkedQueue:OnCreate() 
     --  if Server then
     self.front = Entity.invalidI 
     self.back = Entity.invalidI 
     self.sett = -1
     self.size = 0
    -- end
end

function linkedQueue:GetIsMapEntity()
return true --onreset destroy each node!
end

 function linkedQueue:insertBack( data,  priority) 
 
     print("~~~~~~~~~~~~~~~~~~~~~~~~" )
      print("LinkedQueue myQueue insertBack()" )
      print("~~~~~~~~~~~~~~~~~~~~~~~~" )   
        
        self.size = self.size + 1
        local insertLocation
        local newNode = Server.CreateEntity(queueNode.kMapName) 
                        newNode:Node(data, 0, 0, priority)
               newNode = newNode:GetId() --Aint nothin without this ID lol
        insertLocation = self:findBackLocation(newNode)
       -- Print("insertLocation is %s", insertLocation)
        if (insertLocation == 0) then // Insert as first node at back
            if (self.back == 0 or self.back == Entity.invalidI) then// Empty queue
              -- Print("self.back is %s", self.back)
                self.back = newNode
                self.front = newNode
                return
           -- end
            else // Insert at back
                Shared.GetEntity(newNode):setNextNode(self.back)
                Shared.GetEntity(self.back):setPreviousNode(newNode)
                self.back = newNode              
            end
        --end
        else // Insert to thr right of the back node based on priority
        
            if (Shared.GetEntity(insertLocation):getNextNode() ~= 0 or Shared.GetEntity(insertLocation):getNextNode() == Entity.invalidI) then
                Shared.GetEntity(insertLocation:getNextNode()):setPrevNode(newNode)
            else
            self.front = newNode
            Shared.GetEntity(newNode):setNextNode(Shared.GetEntity(insertLocation):getNextNode())
            Shared.GetEntity(newNode):setPrevNode(insertLocation)
            Shared.GetEntity(insertLocation):setNextNode(newNode)
            end
        end
    end

   function linkedQueue:findBackLocation(newNode)

        if (self.back == 0 or self.back == Entity.invalidI) then //Check for empty queue
            return 0
        end
        

        if (Shared.GetEntity(newNode):getPriority() < Shared.GetEntity(self.back):getPriority()) then// Check for new back
            return 0
         end
          
        while(Shared.GetEntity(self.back):getNextNode() ~= 0) do // Find location to insert based on priority
            if (Shared.GetEntity(newNode):getPriority() > Shared.GetEntity(Shared.GetEntity(self.back):getNextNode()):getPriority()  ) then
                self.back = Shared.GetEntity(self.back):getNextNode()
            else
                return self.back
           end
        end
        return self.back
    end
 
  //insertFront   // inserts a new integer at the front of the dequeue
  function linkedQueue:insertFront(newEntry) --I've been advised to breakoff this into seperate functions
      print("~~~~~~~~~~~~~~~~~~~~~~~~" )
      print("LinkedQueue myQueue insertFront()" )
      print("~~~~~~~~~~~~~~~~~~~~~~~~" )
  
          
  end

    function linkedQueue:findFrontLocation( newNode)

        if (self.front == 0 or self.front == Entity.invalidI) then // Check for empty queue
            Print("findFrontLocation == 0")
            return 0
        end
        if (Shared.GetEntity(newNode):getPriority() > Shared.GetEntity(front):getPriority()) then // Check for new front
             Print("findFrontLocation == 0")
            return 0
        end
   
        while(Shared.GetEntity(self.front):getPrevNode() ~= 0 and Shared.GetEntity(self.front):getPrevNode() ~= Entity.invalidI) do // Find location to insert based on priority
        
            if (Shared.GetEntity(newNode):getPriority() < Shared.GetEntity(self.front):getPrevNode():getPriority()) then
                self.front = Shared.GetEntity(self.front):getPrevNode()
            else
                return self.front
            end
        end
        return self.front
    end   
    
    function linkedQueue:deleteBack() 
    
        if (self.back ~= 0 and self.back ~= Entity.invalidI) then
            self.back = Shared.GetEntity(self.back):getNextNode()
           if (self.back ~= 0 and self.back ~= Entity.invalidI) then
                Shared.GetEntity(self.back):setPreviousNode(0)
            end
        end

    end
     function linkedQueue:dequeue() --delete front
    
       print("~~~~~~~~~~~~~~~~~~~~~~~~" )
      print("LinkedQueue myQueue dequeue()" )
      print("~~~~~~~~~~~~~~~~~~~~~~~~" )
      
        if (self.front ~= 0 and self.front ~= Entity.invalidI) then
                 local Gamerules = GetGamerules()
                 local front = Shared.GetEntity(self.front)
                 local player
                 if front then player = Shared.GetEntity(front:getData())  DestroyEntity(front)  self.size = self.size - 1 end
                 if player and player:getQueue() == self.sett then
                 Gamerules:JoinTeam( player  , self.sett, 0, true )
                 Print("First in line set to team, node destroyed")
                 
                 end

                  --Not necessary, but here because i didnt set as Entity.invalidI and checked for 0. derp.        
                 if self.front ~= self.back then
                 local prev = Shared.GetEntity(self.front)
                      if prev then
                       prev = prev:getPrevNode()
                       end
                    if prev then
                     self.front = prev
                    end
                 end

            if (self.front ~= 0 and self.front ~= Entity.invalidI) then
               local front = Shared.GetEntity(self.front)
                  if front then
                    front:setNextNode(Entity.invalidI)
                  end
            end
        end
    end
    function linkedQueue:print() // print the contents of the queue on one line
    
            print("Queue contents")
       if (self.back == 0) then
            print("<<empty>>")
        else
            local ptr = self.back
            while (ptr ~= 0) do
                ptr = Shared.GetEntity(ptr)
             --   print(" [" + ptr:getData() +"," + ptr:getPriority() + "] ")
                print(  string.format("%s , %s",  ptr:getData(), ptr:getPriority() ))
                ptr = ptr:getNextNode()
            end
                 print( string.format("Size is %s", self.size ))
        end
        print("")
    end
   function linkedQueue:isEmpty()     
      if self.front == 0 or self.front == Entity.invalidI then
         --Print("Is Empty")
         return true
      end
       Print("Is not Empty")
      return false
   end
Shared.LinkClassToMap("linkedQueue", linkedQueue.kMapName, networkVars)