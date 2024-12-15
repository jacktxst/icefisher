extends Node3D

class_name npc

# NOTE: for items with a max count of 1, do not make trades for more than 1 at a time please, it will not work

const trade_sets = [
	[
	{"cost":{"count":1,"id":0},"reward":{"count":1,"id":2}},
	{"cost":{"count":1,"id":1},"reward":{"count":4,"id":1}},
	{"cost":{"count":1,"id":2},"reward":{"count":2,"id":2}},
	]
	
	
]

# This value is the index (from 0) of the trade set 
# which an individual npc will use
@export var npc_id : int

func update_gui():
	for child in $Panel/PlayerInventory.get_children():
		child.free()
	for item_stack in $"/root/Node3D/Icefisher".inventory:
		var label = Label.new()
		if item_stack.id == -1:
			label.text = "Empty Slot"
		else:
			label.text = "Qt: " + str(item_stack.count) + " Item: " + $"/root/Node3D/Items".items[item_stack.id].name
		if item_stack.equipped:
			label.text += " (Equipped)"
		$Panel/PlayerInventory.add_child(label)
		
	for child in $Panel/Trades.get_children():
		child.queue_free()
	for i in range(len(trade_sets[npc_id])):
		var button = Button.new()
		button.pressed.connect(self._on_trade_button_pressed.bind(i))
		button.text = str(trade_sets[npc_id][i].reward.count) + " " + $/root/Node3D/Items.items[trade_sets[npc_id][i].reward.id].name + " for " + str(trade_sets[npc_id][i].cost.count) + " " + $/root/Node3D/Items.items[trade_sets[npc_id][i].cost.id].name
		$Panel/Trades.add_child(button)

# Function to handle button presses
func _on_trade_button_pressed(button_index):
	var cost = trade_sets[npc_id][button_index].cost
	var reward = trade_sets[npc_id][button_index].reward
	# Find stack which can provide the cost
	for cost_stack in $"/root/Node3D/Icefisher".inventory:
		if cost_stack.id == cost.id and cost_stack.count >= cost.count:
			# Find stack which can accept the reward
			for reward_stack in $"/root/Node3D/Icefisher".inventory:
				if reward_stack.id == -1 or (reward_stack.id == reward.id and reward_stack.count + reward.count <= $/root/Node3D/Items.items[reward.id].max_count):
					# Perform transaction
					cost_stack.count -= cost.count
					if cost_stack.count == 0:
						cost_stack.id = -1
					reward_stack.id = reward.id
					reward_stack.count += reward.count
	update_gui()

func interact():
	$Panel.visible = true
	update_gui()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$/root/Node3D/Icefisher.paused = true

func _on_exit_button_pressed() -> void:
	$Panel.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$/root/Node3D/Icefisher.paused = false
