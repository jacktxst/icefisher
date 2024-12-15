extends Node

var items = [
	{
		"max_count":64,
		"holdable": false,
		"name":"Normal Bait",},
	{
		"max_count":1,
		"holdable": true,
		"name":"Ice Drill",},
	{
		"max_count":1,
		"holdable": true,
		"name":"Fishing Rod",},
	{
		"max_count":1,
		"holdable": false,
		"name":"Bobber",}
]

func get_id(name):
	for index in range(len(items)):
		if items[index].name == name:
			return index
			
func use_item(id : int):
	if id == 1:
		use_ice_drill()
	elif id == 2:
		use_fishing_rod()

func use_fishing_rod():
	var projectile = FishHookProjectile.new()
	projectile.position = $"/root/Node3D/Icefisher".position + $"/root/Node3D/Icefisher/Camera3D".position
	if is_instance_valid($"/root/Node3D/FishHookProjectile"):
		$"/root/Node3D/FishHookProjectile".free()
	$"/root/Node3D".add_child(projectile)

func use_ice_drill():
	if $"/root/Node3D/Icefisher".drill_energy < 1:
		return
	
	$"/root/Node3D/Icefisher".drill_energy -= 1
	$"/root/Node3D/LakeSurface/CSGIce/CSGHole".position.x = $"/root/Node3D/Icefisher".position.x
	$"/root/Node3D/LakeSurface/CSGIce/CSGHole".position.z = $"/root/Node3D/Icefisher".position.z
