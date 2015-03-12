--This file defines the tokeable component action, which is the guts of the TOKE action that we created in the modmain file.
--This is all still a work in progress as I try to figure shit out. A lot of it is based on the "playable" action used by instruments since that's what the pipe animation is based off of. 
--Long story short: some of this can be removed and more will be added when the joint gets created.

--I guess this creates the main class
local Tokeable = Class(
	function(self, inst)
    		self.inst = inst
		--These are just kind of placeholders for the AOE effect I have considered giving the joint.
		self.range = 15
    		self.onheard = nil
	
	end,
	nil,
	{}
)


function Tokeable:bowlHit(stoner)
	--I added this when I was trying to get the bowl animation to work and I'm not sure if I still need it. It's also kind of a placeholder for the AOE effect I considered giving the joints.
	local pos = Vector3(stoner.Transform:GetWorldPosition())
	local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, self.range)
	for k,v in pairs(ents) do
		if v ~= self.inst and self.onheard then
			self.onheard(v, stoner, self.inst)
		end
	end
	
	--This is the only thing that this function really does that's the useful.
	stoner.components.sanity:DoDelta(TUNING.SANITY_TINY)
	
	--Return that the function was successful. Not really used currently but good practice.
	return true	
end

return Tokeable
