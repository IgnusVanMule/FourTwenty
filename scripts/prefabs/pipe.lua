--These are basically the custom animations and graphics that we're loading for the prefab
local Assets =
{

  	Asset("ANIM", "anim/pipe.zip"),
   	Asset("ANIM", "anim/swap_pipe.zip"),
	--All uses of the horn animation are temporary until I can get custom animations working
   	Asset("ANIM", "anim/horn.zip"),
   	Asset("ATLAS", "images/inventoryimages/pipe.xml"),
   	Asset("IMAGE", "images/inventoryimages/pipe.tex"),
}

--What to do when equipping the pipe
local function OnEquip(inst, owner)
	
	--Increase hunger rate when equipped
    	owner.components.hunger:DoDelta(3*(-owner.components.hunger.hungerrate))

	--Temporary until custom swap animation is working
    	owner.AnimState:OverrideSymbol("swap_object", "swap_pipe", "swap_shovel")

    	owner.AnimState:Show("ARM_carry")
    	owner.AnimState:Hide("ARM_normal")
end

--What to do when un-equipping the pipe
local function OnUnequip(inst, owner)
	
	--Return hunger rate to normal on unequip
  	owner.components.hunger:DoDelta(owner.components.hunger.burnrate*(-owner.components.hunger.hungerrate))

   	owner.AnimState:Hide("ARM_carry")
   	owner.AnimState:Show("ARM_normal")
end

--What to do when the pipe is used up
local function onfinished(inst)
    	inst:Remove()
end

--This function defines the pipe.
--I have no idea what the "Sim" variable inside the function is used for.
local function fn(Sim)

    	local inst = CreateEntity()
    	inst.entity:AddTransform()
    	inst.entity:AddAnimState()
    	inst.entity:AddNetwork()
    	
	MakeInventoryPhysics(inst)
    	
	--Temporary until I get custom animations working.
	inst.AnimState:SetBank("horn")
    	inst.AnimState:SetBuild("pipe")
    	inst.AnimState:PlayAnimation("idle")

    	--This is unique to DST
	if not TheWorld.ismastersim then
		return inst
    	end

	--This is also unique to DST
    	inst.entity:SetPristine()
	 
    	inst:AddComponent("inspectable")
	
	--I had to add hunger and health to give the equip-based debuff. This is temporary until I figure out a way to make it a debuff over time
	inst:AddComponent("hunger")
	inst:AddComponent("health")
	
	inst:AddComponent("inventoryitem")
    	inst.components.inventoryitem.imagename = "pipe"
    	inst.components.inventoryitem.atlasname = "images/inventoryimages/pipe.xml"
    
	inst:AddComponent("equippable")
    	inst.components.equippable:SetOnEquip(OnEquip)
    	inst.components.equippable:SetOnUnequip(OnUnequip)
	  
    	inst:AddTag("horn")
	
	--This is temporary until I get custom animations working  
    	inst:AddComponent("instrument")
    	inst.AnimState:SetBank("smoke")
    	inst.AnimState:SetBuild("horn")
    	inst.AnimState:PlayAnimation("idle")
	 
	--This is our custom "tokeable" component 
    	inst:AddComponent("tokeable")

	--I'm just using the tuning values for the horn for now.
    	inst:AddComponent("finiteuses")
    	inst.components.finiteuses:SetMaxUses(TUNING.HORN_USES)
    	inst.components.finiteuses:SetUses(TUNING.HORN_USES)
    	inst.components.finiteuses:SetOnFinished(onfinished)
    	inst.components.finiteuses:SetConsumption(ACTIONS.TOKE, 1)

    	return inst
end

--Creates the prefab named "pipe" using the methods/variables defined in the "fn" function and the assets defined in Assets
return Prefab("common/inventory/pipe", fn, Assets)

