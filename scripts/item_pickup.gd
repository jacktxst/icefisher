extends Node

class_name ItemPickup

@export var item_id : int


func _on_body_entered(body: Node3D) -> void:
	if body == $"/root/Node3D/Icefisher": # Replace with function body.
		print("enter")
		for item_stack in body.inventory:
			if item_stack.id == item_id and item_stack.count < $"/root/Node3D/Items".items[item_id].max_count:
				item_stack.count += 1
				$"/root/Node3D/Icefisher/InventoryPanel".update_gui()
				queue_free()
				return
				
				