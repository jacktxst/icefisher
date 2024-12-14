extends Node3D

class_name Fish

const despawn_distance = 10

var active : bool = false
var spawner : FishSpawner

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !active:
		return
	var player_distance = position.distance_to($"/root/Node3D/Icefisher".position)
	if player_distance > despawn_distance:
		spawner.population -= 1
		print("bye")
		queue_free()
		
func activate():
	active = true
	visible = true
