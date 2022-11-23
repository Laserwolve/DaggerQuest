extends Node
class_name ItemManager

func _ready():
	pass # Replace with function body.

static func create_item(item_name : String) -> Item: # Probably don't use string in future but an enum
	var equipment : Dictionary = {}
	return null


class Item:
	func _init(item_name : String, icon_path : String, item_mods : Array[ItemMod]):
		self.item_name = item_name
		self.icon_path = icon_path
		self.item_mods = item_mods

	var item_name : String = "" 
	var icon_path : String = "" # asset path to load texture for item
	var item_mods : Array[ItemMod] = [] # list of modications that effect item


class ItemMod:
	var mod_name : String = "" # this will just be used for ease of access, should probably be replaced with enum in future
	var description : String = ""  # this will be displayed in item stat window
	var target = null # This will generally be the player, but could be an enemy
	
	# This function will be overridden and programmed to do exactly what player needs
	func use() -> void:
		pass
