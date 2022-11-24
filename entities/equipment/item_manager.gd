extends Node
class_name ItemManager

func _ready():
	pass # Replace with function body.

# Define Item IDs
enum ItemId {
	SIMPLE_SWORD,
	LEGGINGS
}

# Lets you get the string value of an ID
func get_item_name_from_id(item_id: ItemId) -> String:
	return ItemId.keys()[item_id]

# Create an item from an ItemId, returns the item from a dictionary value
static func create_item(item_id : ItemId) -> Item:
	# TODO this dictionary is kinda rough, lets figure out a json solution that is clean to edit outside of here
	var equipment : Dictionary = {
		ItemId.SIMPLE_SWORD : Item.new(ItemId.SIMPLE_SWORD, "Simple Sword", "A sword that kills things", "res://assets/sprites/ui/equipment_icons/sword.png", []), 
		ItemId.LEGGINGS : Item.new(ItemId.LEGGINGS, "Leggings", "Makes your ass look great", "res://assets/sprites/ui/equipment_icons/pants.png", []) }
	return equipment[item_id]


class Item:
	func _init(
		item_id: ItemId,
		item_name : String,
		item_description : String,
		icon_path : String,
		item_mods : Array[ItemMod]):
		self.item_id = item_id
		self.item_name = item_name
		self.item_description = item_description
		self.icon_path = icon_path
		self.item_mods = item_mods

	var item_id: ItemId = null
	var item_name : String = ""
	var item_description : String = ""
	var icon_path : String = "" # asset path to load texture for item
	var item_mods : Array[ItemMod] = [] # list of modications that effect item


# TODO lets move this to its own script, this is currently a proof concept
class ItemMod:
	var mod_name : String = "" # this will just be used for ease of access, should probably be replaced with enum in future
	var description : String = ""  # this will be displayed in item stat window
	var target = null # This will generally be the player, but could be an enemy
	
	# This function will be overridden and programmed to do exactly what player needs
	func use() -> void:
		pass
