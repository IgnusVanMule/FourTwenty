--These are basically the custom animations and graphics that we're loading for the prefab
local assets=
{
	Asset("ANIM", "anim/weed.zip"),
	Asset("ATLAS", "images/inventoryimages/weed_fresh.xml"),
	Asset("ATLAS", "images/inventoryimages/weed_dried.xml"),
}

--Loads any custom prefabs we're going to reference
local prefabs =
{
	"weed_seeds",
	"spoiled_food",
	
}    

--This function defines the "fresh" weed prefab.
local function fresh()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("hybrid_banana")
	inst.AnimState:SetBuild("hybrid_banana")
	inst.AnimState:PlayAnimation("raw")
	inst.Transform:SetScale(3,3,3)    

    	if not TheWorld.ismastersim then
		return inst
	end

    	inst.entity:SetPristine()

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("edible")
	inst.components.edible.hungervalue = TUNING.CALORIES_MED
	inst.components.edible.foodtype = FOODTYPE.VEGGIE
	

    	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/weed_fresh.xml"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
        
	inst:AddComponent("cookable")
	inst.components.cookable.product = "weed_seeds"
	
	inst:AddComponent("dryable")
    	inst.components.dryable:SetProduct("weed_dried")
    	inst.components.dryable:SetDryTime(TUNING.DRY_FAST)

	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function dried()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("hybrid_banana")
	inst.AnimState:SetBuild("hybrid_banana")
	--Using the "raw" animation for now because I think we turned the "cooked" banana png into seeds
	inst.AnimState:PlayAnimation("raw")
	inst.Transform:SetScale(3,3,3)

    	if not TheWorld.ismastersim then
		return inst
	end

    	inst.entity:SetPristine()

    	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/weed_dried.xml"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)

	MakeHauntableLaunchAndPerish(inst)

	return inst
end

--Creates the prefabs named "weed_fresh" and weed_dried using the crap defined in the "fresh" and "dried" functions along with all the other crap above. 
return Prefab( "weed_fresh", fresh, assets, prefabs),
	Prefab( "weed_dried", dried, assets, prefabs)
