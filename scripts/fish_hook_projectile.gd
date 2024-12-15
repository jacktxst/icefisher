extends RigidBody3D

class_name FishHookProjectile

var collision_shape = CollisionShape3D.new()
var mesh = MeshInstance3D.new()
var power : float
var touched_ground : bool = false

func _ready():
	#mesh.mesh = BoxMesh.new() 
	mesh.mesh = load("res://models/bobber.obj") as Mesh
	mesh.set_surface_override_material(0,load("res://materials/bobber.tres") as StandardMaterial3D)
	mesh.scale = Vector3(0.125,0.125,0.125)
	#mesh.mesh.size = Vector3(0.25,0.25,0.25)
	collision_layer = 0b1000
	collision_mask = 0b0011
	name = "FishHookProjectile"
	collision_shape.shape = BoxShape3D.new()
	collision_shape.shape.size = Vector3(0.25,0.25,0.25)
	add_child(collision_shape)
	add_child(mesh)
	var dir = -$"/root/Node3D/Icefisher".transform.basis.z
	dir.y = -$"/root/Node3D/Icefisher/Camera3D".transform.basis.z.y
	apply_impulse(dir * power, Vector3(0,0,0))
	
