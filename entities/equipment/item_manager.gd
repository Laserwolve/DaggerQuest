extends Node
class_name ItemManager

func _ready():
	pass # Replace with function body.

# Create an item from a string value, returns the item from a dictionary value
static func create_item(item_name : String) -> Item: # Probably don't use string in future but an enum
	# TODO this dictionary is kinda rough, lets figure out a json solution that is clean to edit outside of here
	var equipment : Dictionary = {
		"simple_sword" : Item.new("Simple Sword", "A sword that kills things", "res://assets/sprites/ui/equipment_icons/sword.png", []), 
		"leggings" : Item.new("Leggings", "Makes your ass look great", "res://assets/sprites/ui/equipment_icons/pants.png", []) }
	return equipment[item_name]


class Item:
	func _init(item_name : String, item_description : String, icon_path : String, item_mods : Array[ItemMod]):
		self.item_name = item_name
		self.item_description = item_description
		self.icon_path = icon_path
		self.item_mods = item_mods

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