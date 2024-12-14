extends CharacterBody3D

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

var crappiePosition = Vector3(4, -.1, 4)



func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("reset positions"):
		var random_position := Vector3.ZERO
		random_position.x = crappiePosition.x + randf_range(-5.0, 5.0)
		random_position.y = crappiePosition.y + randf_range(-5.0, 5.0)
		random_position.z = crappiePosition.z + randf_range(-5.0, 5.0) #creating random position to go to
		navigation_agent_3d.set_target_position(random_position) #setting the destination

func _physics_process(delta: float) -> void:
	var speed = .5
	var destination = navigation_agent_3d.get_next_path_position()
	var local_destination = destination - global_position
	var direction = local_destination.normalized()
	
	velocity = direction * speed
	look_at((global_position - velocity), Vector3.UP)
	move_and_slide() #apply velocity to itself

		
