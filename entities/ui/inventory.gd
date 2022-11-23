extends Control

@onready var slots : GridContainer = get_node("Slots")

func _input(event):
	# Create a random piece of equipment, this is temporary of course
	if Input.is_action_just_pressed("add_item"):
		var random_equipment : Array[String] = ["simple_sword", "leggings"]
		var equipment : ItemManager.Item = ItemManager.create_item(random_equipment[randi_range(0, random_equipment.size() - 1)])
		add_item_to_first_empty_slot(equipment)


# Does as described, adds to first empty slot, if all full display message saying inventory is full
func add_item_to_first_empty_slot(item : ItemManager.Item) -> void:
	var has_found_slot : bool = false
	
	# Check each slot for an empty one to add item too
	for slot in slots.get_children():
		if not slot.is_filled:
			slot.add_item(item)
			break
	
	# If no empty slots were found then display a message saying inventory was full
	if not has_found_slot:
		# TODO Display message that inventory is full
		pass

