local Plugin = Plugin
local Shine = Shine
local VoteMenu = Shine.VoteMenu


function Plugin:Initialise()
self.Enabled = true
return true
end



	Shine.VoteMenu:AddPage( "TeamQueue", function( self )
		self:AddTopButton( "Back", function()
			self:SetPage( "Proving Ground" )
		end )
	end )

	Shine.VoteMenu:EditPage( "TeamQueue", function( self )
		self:AddSideButton( "Leave Queue", function()
		--	Shared.ConsoleCommand( "sh_specvoice 1" )
		    local player = Client.GetLocalPlayer()
		   -- player:setNoQueue(player)
		    Shared.ConsoleCommand( "sh_leavequeue" )
			self:SetPage( "Main" )
			self:SetIsVisible( false )
		end )
	end )
	
	
	Shine.VoteMenu:AddPage( "Proving Ground", function( self )
		self:AddTopButton( "Back", function()
			self:SetPage( "Main" )
		end )

	
		 local player = Client.GetLocalPlayer()
		  -- if player:GetTeamNumber() == 3 then 
		self:AddSideButton( "TeamQueue", function()
			self:SetPage( "TeamQueue" )
		end )
		--end
		


		
	end )

	Shine.VoteMenu:EditPage( "Main", function( self )
		self:AddSideButton( "Proving Ground", function()
			self:SetPage( "Proving Ground" )
		end )

	end )	

