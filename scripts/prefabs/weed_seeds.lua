--Not sure if we need this or not or why
require "prefabutil"

--These are basically the custom animations and graphics that we're loading for the prefab 
local Assets =
{
	Asset("ATLAS", "images/inventoryimages/weed_seeds.xml"),
	Asset("IMAGE", "images/inventoryimages/weed_seeds.tex"),
}

--Loads any custom prefabs we're going to reference
local prefabs =
{
	"weed_tree",
} 

--Not really sure
local notags = {'NOBLOCK', 'player', 'FX'}


--Creates a function that tests the ground to determine if the seed can be planted where the person is trying to place it
local function test_ground(inst, pt)
	local tiletype = GetGroundTypeAtPosition(pt)
	local ground_OK = tiletype ~= GROUND.ROCKY and tiletype ~= GROUND.ROAD and tiletype ~= GROUND.IMPASSABLE and
	tiletype ~= GROUND.UNDERROCK and tiletype ~= GROUND.WOODFLOOR and 
	tiletype ~= GROUND.CARPET and tiletype ~= GROUND.CHECKER and tiletype < GROUND.UNDERGROUND
	if ground_OK then
		local ents = TheSim:FindEntities(pt.x,pt.y,pt.z, 4, nil, notags) -- or we could include a flag to the search?
		local min_spacing = inst.components.deployable.min_spacing or 2
		for k, v in pairs(ents) do
			if v ~= inst and v.entity:IsValid() and v.entity:IsVisible() and not v.components.placer and v.parent == nil then
				if distsq( Vector3(v.Transform:GetWorldPosition()), pt) < min_spacing*min_spacing then
					return false
				end
			end
		end
		return true
	end
		return false
end

local function OnDeploy (inst, pt) 
	local weed_seeds = SpawnPrefab("weed_tree")
	if weed_seeds then
		weed_seeds.Transform:SetPosition(pt.x, pt.y, pt.z)
		--inst.AnimState:PlayAnimation("idle_loop")
		inst.components.stackable:Get():Remove()
	end
end

local function fn(Sim)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()	

	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("seeds")
	inst.AnimState:SetBuild("seeds")
	inst.AnimState:SetRayTestOnBB(true)
	inst.AnimState:PlayAnimation("idle")
	
    	if not TheWorld.ismastersim then
    		return inst
	end

    	inst.entity:SetPristine()

	inst:AddComponent("edible")
	inst.components.edible.foodtype = "SEEDS"
	inst.components.edible.healthvalue = TUNING.HEALING_TINY/2
	inst.components.edible.hungervalue = TUNING.CALORIES_TINY

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	inst:AddComponent("tradable")

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/weed_seeds.xml"
	

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERSLOW)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"
	
	inst:AddComponent("bait")

	inst:AddComponent("deployable")
	inst.components.deployable.ondeploy = OnDeploy

	return inst
end

return Prefab( "common/inventory/weed_seeds", fn, Assets),
	--The placer is what creates that silohuette when you've selected something that's placeable but haven't set it down yet.
	MakePlacer( "weed_seeds_placer", "cave_banana_tree", "hybrid_banana_tree", "idle_loop") 
