extends Area3D

@export var water : bool
@export var paired : NodePath

func _on_body_entered(body: Node3D) -> void:
	if body is RigidBody3D:
		if water:
			body.gravity_scale = -1
			#
			body.linear_velocity *= 0.125
		else:
			body.gravity_scale = 1

func _on_body_exited(body: Node3D) -> void:
	var paired_area : Area3D = get_node(paired)
	if body is RigidBody3D and body in paired_area.get_overlapping_bodies():
		if water:
			body.gravity_scale = 1
		else:
			body.gravity_scale = -1
			
		
