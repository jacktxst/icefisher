extends Panel


func _input(event: InputEvent):
	if event.is_action_pressed("show_inventory"):
		visible = !visible
