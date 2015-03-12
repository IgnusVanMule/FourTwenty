--I haven't messed with this prefab yet, so it's still in its original state other than some formatting changes

require "prefabutil"
require "tuning"



local assets =
{
	Asset("ANIM", "anim/g_house.zip"),
}

local function onhammered(inst, worker)
	inst.components.grower:Reset()
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:Remove()
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
end

local function onhit(inst, worker)
end

local function fn(Sim)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("g_house")
	inst.AnimState:SetBuild("g_house")
	inst.AnimState:PlayAnimation( "idle",true )

	inst:AddTag("g_house")

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon( "g_house.tex" )

    	if not TheWorld.ismastersim then
    		return inst
	end

    	inst.entity:SetPristine()

	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = function(inst)
  
	if not inst.components.grower:IsFertile() then
		return "NEEDSFERTILIZER"
	elseif not inst.components.grower:IsEmpty() then
		return "GROWING"
	end
end

	inst:AddComponent("grower")
	inst.components.grower.croppoints = { Vector3(0,.3,0) }
	inst.components.grower.growrate = .300
	inst.components.grower.max_cycles_left = 30 or 6
	inst.components.grower.cycles_left = inst.components.grower.max_cycles_left
			
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	return inst
end    

return Prefab( "common/objects/g_house",  fn, assets),
	MakePlacer( "common/g_house_placer", "g_house", "g_house", "idle" ) 
