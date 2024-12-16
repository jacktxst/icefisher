extends CharacterBody3D

class_name Icefisher

const JUMP_VELOCITY = 4.5
const LOOK_SENSITIVITY = 0.001
var paused = false
# 
var rod_level = 1
var drill_level = 1
var drill_energy = 100
var inventory = []
var selected_item : int = 2
var footstep_timer = 0
var SPEED  = 5.0

var spawn_pos : Vector3
var death_fadeout : float = -100

func _ready():
	spawn_pos = Vector3(position.x,position.y,position.z)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	inventory = [
		{"count":0,"id":-1,"equipped":false},
		{"count":0,"id":-1,"equipped":false},
		{"count":0,"id":-1,"equipped":false},
		{"count":0,"id":-1,"equipped":false},
		{"count":0,"id":-1,"equipped":false},
		{"count":0,"id":-1,"equipped":false},
		{"count":0,"id":-1,"equipped":false},
		{"count":1,"equipped":true,"id":$"../Items".get_id("Bobber")},
		{"count":1,"equipped":true,"id":$"../Items".get_id("Ice Drill")},
		{"count":1,"equipped":true,"id":$"../Items".get_id("Fishing Rod")}
	]
	$InventoryPanel.update_gui()
	$SelectedItemLabel.text = "Selected Item: " +  $"/root/Node3D/Items".items[inventory[selected_item].id].name

func has_at_least(count : int, item_id: int) -> bool:
	var remaining = count
	for item_stack in self.inventory:
		if item_stack.id == item_id:
			remaining -= item_stack.count
			if remaining <= 0:
				return true
	return false
	

func has_room_for(item_id : int, count : int) -> bool:
	var items = $/root/Node3D/Items.items
	var remaining = count
	for item_stack in self.inventory:
		if item_stack.id == -1:
			remaining -= items[item_id].max_count
			if remaining <= 0:
				return true
		elif item_stack.id == item_id:
			remaining -= items[item_id].max_count - item_stack.count
			if remaining <= 0:
				return true
	return false

func remove_items(count : int, item_id : int):
	var remaining = count
	for item_stack in self.inventory:
		if item_stack.id == item_id:
			if item_stack.count > remaining:
				item_stack.count -= remaining
				if item_stack.count == 0:
					item_stack.id = -1
				return
			else:
				remaining -= item_stack.count
				item_stack.count = 0
				item_stack.id = -1
				if remaining <= 0:
					return

func give_item(item_id : int, count : int) -> int:
	if count <= 0:
		return -1
	var items = $/root/Node3D/Items.items
	var remaining = count
	for item_stack in self.inventory:
		if item_stack.id == -1:
			var slot_room = items[item_id].max_count
			if remaining <= slot_room:
				item_stack.count = remaining
				item_stack.id = item_id
				$InventoryPanel.update_gui()
				return 0
			else:
				remaining -= slot_room
				item_stack.count = slot_room
		elif item_stack.id == item_id:
			var slot_room = items[item_id].max_count - item_stack.count
			if remaining <= slot_room:
				item_stack.count += remaining
				$InventoryPanel.update_gui()
				return 0
			else:
				remaining -= slot_room
				item_stack.count += slot_room
	return remaining
	$InventoryPanel.update_gui()

func _input(event: InputEvent) -> void:
	if not paused and event is InputEventMouseMotion:
		$Camera3D.rotate_x(event.screen_relative.y * -1 * LOOK_SENSITIVITY)
		rotate_y(event.screen_relative.x * -1 * LOOK_SENSITIVITY)
		pass
	
	if event.is_action_pressed("switch_item"):
		var index = ( selected_item + 1 ) % len(inventory)
		while(1):
			if $"/root/Node3D/Items".items[inventory[index].id].holdable:
				selected_item = index
				$WeaponViewModel.mesh =load($"/root/Node3D/Items".items[inventory[index].id].viewmodel) as Mesh
				$SelectedItemLabel.text = "Selected Item: " +  $"/root/Node3D/Items".items[inventory[index].id].name
				break
			index = ( index + 1 ) % len(inventory)
			
	if event.is_action_pressed("interact"):
		var col = $Camera3D/RayCast3D.get_collider()
		if col and col.name == "Shopkeeper":
			print("h")
			col.interact()
			
	if event.is_action_pressed("use_item"):
		$"/root/Node3D/Items".use_item(inventory[selected_item].id)
	if event.is_action_released("use_item"):
		$"/root/Node3D/Items".release_item(inventory[selected_item].id)
	
	if event.is_action_pressed("game_pause"):
		if paused:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			paused = false
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			paused = true


func _process(delta: float) -> void:
	if position.y < 0 and death_fadeout == -100:
		death_fadeout = 1
		$DeathScreen.visible = true
		$DeathScreen.color = Color(0,0,0,0)
	if death_fadeout > 0:
		death_fadeout -= delta
		$DeathScreen.color = Color(0,0,0,clamp(1-death_fadeout,0,1))
	if death_fadeout <= 0 and not death_fadeout == -100:
		$DeathScreen.visible = false
		position = spawn_pos
		death_fadeout = -100
	$DrillEnergyLabel.text = "drill_energy" + str(drill_energy)
	footstep_timer = footstep_timer - delta if footstep_timer > 0 else footstep_timer

func _physics_process(delta: float) -> void:
	if paused:
		return
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if Input.is_key_pressed(KEY_P):
		print(position)
	
	if Input.is_action_pressed("Sprint") and (Input.is_action_pressed("Crouch")==false):
		SPEED = 7.0
	if Input.is_action_just_released("Sprint"):
		SPEED = 5.0
	if Input.is_action_just_pressed("Crouch"):
		SPEED = 3.0
		$Camera3D.translate(Vector3(0, -.5, 0))
	if Input.is_action_just_released("Crouch"):
		SPEED = 5.0
		$Camera3D.translate(Vector3(0, .5, 0))

	if velocity.length() != 0 and is_on_floor():
		var rng = randi_range(1, 42)
		if(footstep_timer <= 0):
			#get_node("Footsteps/Step"+str(rng)).pitch_scale = randf_range(.9, 1.1)
			#get_node("Footsteps/Step"+str(rng)).play()
			
			footstep_timer = randf_range(1-(SPEED/10), 1-(SPEED/10)+.1)
		
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
