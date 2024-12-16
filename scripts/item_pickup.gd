extends Node

class_name ItemPickup

# When you attach a script that has an export var to 
# a node, that variable gets exposed in the Godot 
# editor as a property of the node that you can edit 
# in the Inspector
@export var item_id : int

func _on_body_entered(body: Node3D) -> void:
	if body == $"/root/Node3D/Icefisher": # Replace with function body.
		if $/root/Node3D/Icefisher.has_room_for(item_id,1):
			$/root/Node3D/Icefisher.give_item(item_id,1)			
			queue_free()
			return

var anim : float

func _process(delta : float):
	anim += delta
	if is_instance_valid($MeshInstance3D):
		$MeshInstance3D.position.y = sin(anim) * 0.25
		$MeshInstance3D.rotate_y(delta * 0.25)
