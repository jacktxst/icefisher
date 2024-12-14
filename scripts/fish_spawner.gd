extends Node3D

class_name FishSpawner

@export var minimum_wait : float
@export var maximum_wait : float
@export var far_distance : float
@export var near_distance : float
@export var population_cap : int

var timer : float = 0.0
var population : int = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player_distance = position.distance_to($"/root/Node3D/Icefisher".position)
	if  player_distance < far_distance and player_distance > near_distance:
		if timer > 0.0:
			timer -= delta
			if timer <= 0 and population < population_cap:
				var fish : Fish = get_child(0).duplicate()
				fish.position = position
				fish.spawner = self
				fish.activate()
				population += 1
				$"/root/Node3D".add_child(fish)
		else:
			timer = randf_range(minimum_wait, maximum_wait)
