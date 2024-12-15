extends MeshInstance3D

@export var height = 5
@export var width = 5
@export var length = 5

var goTo : Vector3
var spawn_pos : Vector3

func _ready():
	spawn_pos = position
	goTo = spawn_pos + Vector3(randf_range(width*-1, width), randf_range(0, height), randf_range(length*-1, length))

func _physics_process(delta: float) -> void:	
	if position.distance_to(goTo) >= .5:
		var velocity = (goTo-position)/100
		look_at(goTo)
		self.rotate_object_local(Vector3(0,1,0), 3.14)
		position += velocity
	else:
		goTo = spawn_pos + Vector3(randf_range(width*-1, width), randf_range(0, height), randf_range(length*-1, length))
	
