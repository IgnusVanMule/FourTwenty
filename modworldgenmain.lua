GLOBAL.require("map/terrain")
local weed_tree_rate = 1.4
local weed_tree_regions = 4


--This is all based on a mod that spawned a new type of stone, so the values all need to be adjusted for weed trees eventually

GLOBAL.terrain.rooms.BGNoise.contents.distributeprefabs.weed_tree = weed_tree_rate
--GLOBAL.terrain.rooms.NoisyCave.contents.distributeprefabs.weed_tree = weed_tree_rate
--GLOBAL.terrain.rooms.CaveRoom.contents.distributeprefabs.weed_tree = weed_tree_rate
GLOBAL.terrain.rooms.BGDirt.contents.distributeprefabs.weed_tree = weed_tree_rate
--GLOBAL.terrain.rooms.BGBadlands.contents.distributeprefabs.weed_tree = weed_tree_rate
--GLOBAL.terrain.rooms.BGChessRocky.contents.distributeprefabs.weed_tree = (weed_tree_rate/2)
--GLOBAL.terrain.rooms.BGRocky.contents.distributeprefabs.weed_tree = weed_tree_rate*2
--GLOBAL.terrain.rooms.Rocky.contents.distributeprefabs.weed_tree = weed_tree_rate*2
print("Spawned Weed Treess in Rocky Biomes")
if weed_tree_regions~=nil then
	if weed_tree_regions>1 then
		GLOBAL.terrain.rooms.Marsh.contents.distributeprefabs.weed_tree = (weed_tree_rate/16)
		GLOBAL.terrain.rooms.BGMarsh.contents.distributeprefabs.weed_tree = (weed_tree_rate/16)
		GLOBAL.terrain.rooms.SlightlyMermySwamp.contents.distributeprefabs.weed_tree = (weed_tree_rate/16)
		print("Spawned Weed Trees in Marsh Biomes")
	end
	if weed_tree_regions>2 then
		GLOBAL.terrain.rooms.CrappyForest.contents.distributeprefabs.weed_tree = (weed_tree_rate/20)
		GLOBAL.terrain.rooms.Forest.contents.distributeprefabs.weed_tree = (weed_tree_rate/20)
		GLOBAL.terrain.rooms.DeepForest.contents.distributeprefabs.weed_tree = (weed_tree_rate/20)
		GLOBAL.terrain.rooms.CrappyDeepForest.contents.distributeprefabs.weed_tree = (weed_tree_rate/20)
		GLOBAL.terrain.rooms.BGForest.contents.distributeprefabs.weed_tree = (weed_tree_rate/20)
		print("Spawned Weed Trees in Forrest Biomes")
		--GLOBAL.terrain.rooms.Graveyard.contents.distributeprefabs.weed_tree = (weed_tree_rate/4) --glitched? Did I mispell it?
	end
	if weed_tree_regions>3 then
		GLOBAL.terrain.rooms.BGNoise.contents.distributeprefabs.weed_tree = (weed_tree_rate/60)	-- not quite sure if this does what i think it does
		GLOBAL.terrain.rooms.Plain.contents.distributeprefabs.weed_tree = (weed_tree_rate/80)
		GLOBAL.terrain.rooms.BarePlain.contents.distributeprefabs.weed_tree = (weed_tree_rate/50)
		GLOBAL.terrain.rooms.BGSavanna.contents.distributeprefabs.weed_tree = (weed_tree_rate/70)
		GLOBAL.terrain.rooms.BGGrass.contents.distributeprefabs.weed_tree = (weed_tree_rate/50)
		GLOBAL.terrain.rooms.EvilFlowerPatch.contents.distributeprefabs.weed_tree = (weed_tree_rate/50)
		print("Spawned Weed Trees almost fucking everywhere!")
	end
else
	print("weed_tree_regions is nil/null")
end

--Don't grwo on the road, wood floor, carpet, or checker tiles
GLOBAL.terrain.filter.weed_tree = {GLOBAL.GROUND.ROAD, GLOBAL.GROUND.WOODFLOOR, GLOBAL.GROUND.CARPET, GLOBAL.GROUND.CHECKER}




