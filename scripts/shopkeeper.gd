extends Node3D

class_name npc
# Copies from another class. this is bad programming.
func update_gui():
	for child in $Panel/PlayerInventory.get_children():
		child.free()
	for item_stack in $"/root/Node3D/Icefisher".inventory:
		var label = Label.new()
		label.text = "Qt: " + str(item_stack.count) + " Item: " + $"/root/Node3D/Items".items[item_stack.id].name
		if item_stack.equipped:
			label.text += " (Equipped)"
		$Panel/PlayerInventory.add_child(label)

func interact():
	$Panel.visible = true
	update_gui()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$/root/Node3D/Icefisher.paused = true
	
