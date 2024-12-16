extends MeshInstance3D

class_name Fish

@export var height = 5
@export var width = 5
@export var length = 5

@export var item_id : int
@export var bite_chance = 5
@export var unbite_chance = 250
@export var view_distance = 10
@export var bait_level = 0

var target : Vector3
var spawn_pos : Vector3

const despawn_distance = 75

var active : bool = false
var hooked : bool = false
var spawner : FishSpawner
		
func activate():
	active = true
	spawn_pos = position
	visible = true

func _ready():
	target = spawn_pos + Vector3(randf_range(width*-1, width), randf_range(0, height), randf_range(length*-1, length))
		
func _physics_process(delta: float) -> void:	
	if !active:
		return
	
	# Fish despawn
	var player_distance = position.distance_to($"/root/Node3D/Icefisher".position)
	if active and not hooked and player_distance > despawn_distance:
		if is_instance_valid(spawner):
			spawner.population -= 1
		print("bye! pos was" + str(position) )
		queue_free()
	
	# On-Hook Behavior (Leaves the Hook randomly)
	if hooked:
		var rng = randi_range(0,unbite_chance)
		if rng == 0:
			target = spawn_pos + Vector3(randf_range(width*-1, width), randf_range(0, height), randf_range(length*-1, length))
			self.reparent($/root/Node3D)
			position = $/root/Node3D/FishHookProjectile.position
			hooked = false
			return
			
	# Hook-Biting
	if $/root/Node3D/Items.line_is_cast and position.distance_to($/root/Node3D/FishHookProjectile.position) <= 0.5:
		var rng = randi_range(0,bite_chance) # This can be influenced by personality
		if rng == 0 and $/root/Node3D/FishHookProjectile.get_child_count() == 2:
			print("yum")
			if bait_level == 3 and !$/root/Node3D/Icefisher.has_at_least(1, $/root/Node3D/Items.get_id("Rare Bait")):
				return
			self.reparent($/root/Node3D/FishHookProjectile)
			position = Vector3(0,0,0)
			hooked = true
			return
	
	# Movement AI
	if hooked:
		return
	elif position.distance_to(target) >= .5:
		var velocity = (target-position)/100
		look_at(target)
		self.rotate_object_local(Vector3(0,1,0), 3.14)
		position += velocity
	elif $/root/Node3D/Items.line_is_cast and $/root/Node3D/FishHookProjectile.gravity_scale < 0 and position.distance_to($/root/Node3D/FishHookProjectile.position) < view_distance:
		print("saw bobber")
		target = $/root/Node3D/FishHookProjectile.position
	else:
		target = spawn_pos + Vector3(randf_range(width*-1, width), randf_range(0, height), randf_range(length*-1, length))
	
	
