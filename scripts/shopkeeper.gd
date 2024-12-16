extends Node3D

class_name npc

# NOTE: for items with a max count of 1, do not make trades for more than 1 at a time please, it will not work

var trade_sets

var hint_no = 0

var hints = [
	"Buy somethin will ya!",
	"press v for noclip if you get stuck",
	"power just makes you cast further. try doing fun trickshots",
	"if you catch red fish you basically beat the game",
	"I hear red fish only like rare bait",
	"You only have to have the rare bait in your inventory for it to work!",
	"Legend tells of a rare item found on top of mountains",
	"Don't fall under the ice!",
	"Dont fall into the nearby canyon!",
	"I hear there's exotic fish somewhere around here",
	"You can find a lot of stuff just walking around in these hills"
]

# This value is the index (from 0) of the trade set 
# which an individual npc will use
@export var npc_id : int

func _ready():
	var items = $/root/Node3D/Items
	var money = items.get_id("Money")
	var fish = items.get_id("Fish 1")
	$Panel.visible = false
	trade_sets = [
		[
		{"cost":{"count":1,"id":money},"reward":{"count":1,"id":fish}},
		{"cost":{"count":1,"id":fish},"reward":{"count":1,"id":money}},
		{"cost":{"count":1,"id":money},"reward":{"count":2,"id":money}},
		]
		
		
	]

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
	var icefisher : Icefisher = $/root/Node3D/Icefisher
	
	if icefisher.has_at_least(cost.count,cost.id) and icefisher.has_room_for(reward.id,reward.count):
		icefisher.remove_items(cost.count,cost.id)
		icefisher.give_item(reward.id,reward.count)
		pass
	update_gui()

var anim_timer : float = 0

func _physics_process(delta : float):
	anim_timer += delta
	$Duck.scale.y = 0.25 + 0.005 * sin(anim_timer) 

func interact():
	hint_no = ( hint_no + 1 ) % len(hints)
	if hint_no == 0:
		hints.shuffle()
	$Panel/Panel/Label.text = hints[hint_no]
	$Panel.visible = true
	update_gui()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$/root/Node3D/Icefisher.paused = true

func _on_exit_button_pressed() -> void:
	$Panel.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$/root/Node3D/Icefisher.paused = false
