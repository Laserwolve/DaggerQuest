extends Control

@onready var slots : GridContainer = get_node("Slots")

func _input(event):
	# Create a random piece of equipment, this is temporary of course
	if Input.is_action_just_pressed("add_item"):
		var random_equipment : Array[String] = ["simple_sword", "leggings"]
		var equipment : ItemManager.Item = ItemManager.create_item(random_equipment[randi_range(0, random_equipment.size() - 1)])
		add_item_to_first_empty_slot(equipment)


func add_item_to_first_empty_slot(item : ItemManager.Item) -> void:
	var has_found_slot : bool = false
	print(item.item_name)
	for slot in slots.get_children():
		if not slot.is_filled:
			has_found_slot = true
			slot.set_item(item)
			break
	
	if not has_found_slot:
		# Display message that inventory is full
		print("Inventory full!")

