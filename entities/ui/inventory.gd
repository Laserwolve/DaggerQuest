extends Control


func _input(event):
	# Create a random piece of equipment, this is temporary of course
	if Input.is_key_pressed(KEY_S):
		var random_equipment : Array[String] = ["Simple Sword", "Leggings"]
		var equipment : ItemManager.Item = ItemManager.create_item(random_equipment[randi_range(0, random_equipment.size())])

