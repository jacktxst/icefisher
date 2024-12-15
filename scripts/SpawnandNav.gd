extends NavigationRegion3D

var enemy_scene = preload("res://scenes/Crappie.tscn")
var spawnlimit = 5
var spawn = 0


func _on_timer_timeout() -> void:
	var x = position.x
	var y = position.y
	var z = position.z
	if spawn <= spawnlimit:
		var enemy = enemy_scene.instantiate()
		enemy.position = Vector3(randf_range(x-4, x+4), randf_range(y-0, y+5), randf_range(z-4, z+4))
		add_child(enemy)
		spawn +=1
