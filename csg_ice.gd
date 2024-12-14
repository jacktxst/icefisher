extends CSGBox3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dev_icehole"):
		$CSGHole.position.x = $"/root/Node3D/Player".position.x
		$CSGHole.position.z = $"/root/Node3D/Player".position.z

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
