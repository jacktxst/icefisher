extends Node


var items = [
	{"max_count":64,"name":"Normal Bait","lore":""},
	{"max_count":1,"name":"Ice Drill","lore":"","quest":true},
	{"max_count":1,"name":"Fishing Rod","lore":"","quest":true},
	{"max_count":1,"name":"Bobber","lore":"","quest":true}
]

func get_id(name):
	for index in range(len(items)):
		if items[index].name == name:
			return index