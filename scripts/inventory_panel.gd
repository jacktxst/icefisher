extends Panel


func _input(event: InputEvent):
	if event.is_action_pressed("show_inventory"):
		visible = !visible

# Change the labels to match what items the player has
func update_gui():
	for child in $VBoxContainer.get_children():
		child.free()
	for item_stack in $"..".inventory:
		var label = Label.new()
		if item_stack.id == -1:
			label.text = "Empty Slot"
		else:
			label.text = "Qt: " + str(item_stack.count) + " Item: " + $"/root/Node3D/Items".items[item_stack.id].name
		if item_stack.equipped:
			label.text += " (Equipped)"
		$VBoxContainer.add_child(label)
