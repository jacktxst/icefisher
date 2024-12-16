extends Node

var items = [
	{
		"max_count":64,
		"holdable": false,
		"name":"Normal Bait",},
	{
		"max_count":1,
		"holdable": true,
		"name":"Ice Drill",
		"viewmodel":"res://models/viewmodels/drill.obj"},
	{
		"max_count":1,
		"holdable": false,
		"name":"Fish"},
	{
		"max_count":999,
		"holdable": false,
		"name":"Money"},
	{
		"max_count":1,
		"holdable": true,
		"name":"Fishing Rod",
		"viewmodel":"res://models/viewmodels/rod1.obj"},
	{
		"max_count":1,
		"holdable": false,
		"name":"Bobber",}
]

var line_is_cast : bool = false

func get_id(name):
	for index in range(len(items)):
		if items[index].name == name:
			return index

# This code is really bad I know

func use_item(id : int):
	if id == 1:
		use_ice_drill()
	elif id == 4:
		use_fishing_rod()

func release_item(id : int):
	if id == 4:
		release_fishing_rod()

func release_fishing_rod():
	
	if cast_in_progress:
		var projectile = FishHookProjectile.new()
		var power = $"/root/Node3D/Icefisher/QuickTimeProgressBar".value
		# negative absolute value function transformed
		power = (-1.7 * abs(power-5) )+10
		projectile.power = power
		print("throw!" + str(projectile.power))
		projectile.position = $"/root/Node3D/Icefisher".position + $"/root/Node3D/Icefisher/Camera3D".position
		$"/root/Node3D".add_child(projectile)
		$"/root/Node3D/Icefisher/QuickTimeProgressBar".visible = false
		cast_in_progress = false
		line_is_cast = true
		
func _process(delta : float):
	if cast_in_progress:
		$"/root/Node3D/Icefisher/QuickTimeProgressBar".value += delta * 4
		if $"/root/Node3D/Icefisher/QuickTimeProgressBar".value >= $"/root/Node3D/Icefisher/QuickTimeProgressBar".max_value:
			cast_in_progress = false
			$"/root/Node3D/Icefisher/QuickTimeProgressBar".visible = false

var cast_in_progress = false

func use_fishing_rod():
	if !line_is_cast:
		# Show the timewheel
		$"/root/Node3D/Icefisher/QuickTimeProgressBar".visible = true
		$"/root/Node3D/Icefisher/QuickTimeProgressBar".value = $"/root/Node3D/Icefisher/QuickTimeProgressBar".min_value
		cast_in_progress = true
	elif line_is_cast:
		# Reel
		if $"/root/Node3D/FishHookProjectile".get_child_count() > 2:
			$"/root/Node3D/FishHookProjectile".get_child(2).spawner.population -=1
			$"/root/Node3D/Icefisher".give_item($"/root/Node3D/FishHookProjectile".get_child(2).item_id, 1)
		$"/root/Node3D/FishHookProjectile".free()
		line_is_cast = false

func use_ice_drill():
	if $"/root/Node3D/Icefisher".drill_energy < 1:
		return
	$"/root/Node3D/Icefisher".drill_energy -= 1
	$"/root/Node3D/LakeSurface/CSGIce/CSGHole".position.x = $"/root/Node3D/Icefisher".position.x
	$"/root/Node3D/LakeSurface/CSGIce/CSGHole".position.z = $"/root/Node3D/Icefisher".position.z
