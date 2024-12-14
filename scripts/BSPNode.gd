extends Node

class_name BSPNode

# Properties for the node
var is_leaf: bool = false
var split_axis: String = "" # "x" or "z"
var split_coord: float = 0.0
var left: BSPNode = null
var right: BSPNode = null
var bounds: Rect2 = Rect2() # Bounds for leaf nodes


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
