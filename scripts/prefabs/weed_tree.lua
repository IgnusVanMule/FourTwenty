--These are basically the custom animations and graphics that we're loading for the prefab
local assets=
{
	Asset("ANIM", "anim/weed_plant.zip"),
	Asset("ANIM", "anim/weed_tree.zip")
}

--Loads any prefabs we're going to reference
local prefabs =
{
    	"weed_fresh",
    	"charcoal",
    	"log",
    	"twigs",
}    

--Creates a function that defines how to display a tree during "regen" (I guess that means "regrow")
local function onregenfn(inst)
	--inst.AnimState:PlayAnimation("grow") 
	inst.AnimState:PushAnimation("idle_loop", true)
	--inst.AnimState:Show("BANANA") 
end

--Creates a function that defines how to display the "full" tree. I have no idea what the difference between makefull and onregen is, except that the onregen function contains the "grow" animation.
local function makefullfn(inst)
	inst.AnimState:PlayAnimation("idle_loop", true)
	--inst.AnimState:Show("BANANA") 
end

--Creates a function that defines how to display the picked tree
local function onpickedfn(inst)
	inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds") 
	inst.AnimState:PlayAnimation("pick") 
	inst.AnimState:PushAnimation("idle_barren")  
end

--Creates a function that defines how to display the empty tree
local function makeemptyfn(inst)
	inst.AnimState:PlayAnimation("idle_barren")
	--inst.AnimState:Hide("BANANA") 
end

--Creates a function that defines what to do when the tree is dug up.
local function dug(inst)
	inst:Remove()
	inst.components.lootdropper:SpawnLootPrefab("log")
end

--Creates a function that defines how to make the stump after the tree is cut down
local function setupstump(inst)
	inst.stump = true
	inst:RemoveComponent("pickable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
    	inst.components.workable:SetWorkLeft(1)
    	inst.components.workable:SetOnWorkCallback(dug)
	inst.AnimState:PlayAnimation("idle_stump")
end

--Creates a function that defines what to do when the weed_tree is choppped
local function chopped(inst, worker)
	if inst.stump then
		return
	end
	if not worker or (worker and not worker:HasTag("playerghost")) then
		inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
	end
	if inst.burnt then
		inst:RemoveComponent("workable")
		inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")
		inst.components.lootdropper:SpawnLootPrefab("charcoal")
		inst.persists = false
		--inst.AnimState:PlayAnimation("chop_burnt")
		inst:DoTaskInTime(50*FRAMES, function() inst:Remove() end)
	else
	              
		inst.SoundEmitter:PlaySound("dontstarve/forest/treefall")

		inst.components.lootdropper:SpawnLootPrefab("log")
		inst.components.lootdropper:SpawnLootPrefab("twigs")
		inst.components.lootdropper:SpawnLootPrefab("twigs")
		--inst.AnimState:Hide("BANANA") 
		if inst.components.pickable and inst.components.pickable.canbepicked then
			inst.components.lootdropper:SpawnLootPrefab("weed_fresh")
		end
		setupstump(inst)
		inst.AnimState:PlayAnimation("fall")
		inst.AnimState:PushAnimation("idle_stump")
	end

end

--Creates a function that defines how the tree is displayed while being chopped
local function chop(inst, worker)
	--inst.AnimState:PlayAnimation("chop")
	inst.AnimState:PushAnimation("idle_loop", true)
	if not worker or (worker and not worker:HasTag("playerghost")) then
    		inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")         
    	end
end

--Creates a function that defines what to do when the tree begins burning
local function startburn(inst)
	inst.burnt = true
    	if inst.components.pickable then
        	inst:RemoveComponent("pickable")
    	end
end

--Creates a function that defines what to do when the tree is actually burnt
local function makeburnt(inst)
	inst.burnt = true
	
	inst:RemoveComponent("burnable")
	inst:RemoveComponent("propagator")
	inst:RemoveComponent("pickable")

	if inst.stump then
		inst:Remove()
	else
		--inst.AnimState:PlayAnimation("burnt")
		inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")
    		inst.components.workable:SetWorkAction(ACTIONS.CHOP)
    		inst.components.workable:SetWorkLeft(1)
    	end
end

--I'm not sure what the purpose of this function is yet
local function onsave(inst, data)
	data.stump = inst.stump
	data.burnt = inst.burnt
end

--Or this one
local function onload(inst, data)
	if data and data.stump then
		setupstump(inst)
	elseif data and data.burnt then
		makeburnt(inst)
	end
end

--This function defines the weed tree and will call all of the functions used above. 
local function fn(Sim)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	MakeObstaclePhysics(inst,.5)
	minimap:SetIcon( "cave_banana_tree.png" )
    
    	inst.AnimState:SetBank("weed_plant")
    	inst.AnimState:SetBuild("weed_plant")
    	inst.AnimState:PlayAnimation("idle_loop",true)
    	inst.AnimState:SetTime(math.random()*2)

    	if not TheWorld.ismastersim then
		return inst
	end

    	inst.entity:SetPristine()

	inst:AddComponent("pickable")
	inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"
	
	inst.components.pickable:SetUp("weed_fresh", TUNING.CAVE_BANANA_GROW_TIME)
	inst.components.pickable.onregenfn = onregenfn
	inst.components.pickable.onpickedfn = onpickedfn
	inst.components.pickable.makeemptyfn = makeemptyfn
	inst.components.pickable.makefullfn = makefullfn


	inst:AddComponent("workable")
    	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
    	inst.components.workable:SetWorkLeft(3)
    	inst.components.workable:SetOnFinishCallback(chopped)
    	inst.components.workable:SetOnWorkCallback(chop)


	inst:AddComponent("lootdropper")
    	
	inst:AddComponent("inspectable")    
      
    	MakeMediumBurnable(inst)
    	MakeSmallPropagator(inst)

	MakeNoGrowInWinter(inst)

    	inst.components.burnable:SetOnIgniteFn(startburn)
	inst.components.burnable:SetOnBurntFn(makeburnt)
    	inst.OnSave = onsave
    	inst.OnLoad = onload
  
    	return inst
end

--Creates the prefab named "weed_tree" using the "fn" function from above and the assets and prefabs defined in their variables at the top.
return Prefab("weed_tree", fn, assets, prefabs)
