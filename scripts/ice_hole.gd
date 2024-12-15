extends Area3D

func _on_body_entered(body: PhysicsBody3D) -> void:
	body.collision_mask &= ~(1 << 1) # Replace with function body.

func _on_body_exited(body: PhysicsBody3D) -> void:
	body.collision_mask |= (1 << 1)
