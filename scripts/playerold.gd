extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const LOOK_SENSITIVITY = 0.001

var paused = false

# 
var rod_level = 1
var drill_level = 1
var drill_energy = 100
var inventory = []
var selected_item : int = 2

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	inventory = [
		{"count":0,"id":0,"equipped":true},
		{"count":1,"equipped":true,"id":$"../Items".get_id("Bobber")},
		{"count":1,"equipped":true,"id":$"../Items".get_id("Ice Drill")},
		{"count":1,"equipped":true,"id":$"../Items".get_id("Fishing Rod")}
	]
	$InventoryPanel.update_gui()
	$SelectedItemLabel.text = "Selected Item: " +  $"/root/Node3D/Items".items[inventory[selected_item].id].name


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
				$SelectedItemLabel.text = "Selected Item: " +  $"/root/Node3D/Items".items[inventory[index].id].name
				break
			index = ( index + 1 ) % len(inventory)
	
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
	$DrillEnergyLabel.text = "drill_energy" + str(drill_energy)

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
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
