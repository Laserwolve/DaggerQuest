extends Node
class_name ItemManager

func _ready():
	pass # Replace with function body.

# Define Item IDs
enum ItemId {
	SIMPLE_SWORD,
	LEGGINGS
}

# Define Item Types
enum ItemType {
	GENERIC,
	WEAPON,
	SHIELD,
	HEAD,
	CHEST,
	LEGS,
	FEET,
	ARMS,
	HANDS
}

# Lets you get the string value of an ID
static func get_item_name_from_id(item_id: ItemId) -> String:
	return ItemId.keys()[item_id]

# Create an item from an ItemId, returns the item from a dictionary value
static func create_item(item_id : ItemId) -> Item:
	# TODO this dictionary is kinda rough, lets figure out a json solution that is clean to edit outside of here
	
	var mods: Array[ItemMod] = []
	
	for i in range(0, randi_range(1, 8)):
		var mod = randi_range(0, 5) # 0 - 5
		mods.push_back(ItemMod.new(mod, randi_range(-10, 10), ModTarget.HOLDER, randf() < .5))
	
	var equipment : Dictionary = {
		ItemId.SIMPLE_SWORD : Item.new(ItemId.SIMPLE_SWORD, ItemType.WEAPON, "Simple Sword", "A sword that kills things", "res://assets/sprites/ui/equipment_icons/sword.png", mods), 
		ItemId.LEGGINGS : Item.new(ItemId.LEGGINGS, ItemType.LEGS, "Leggings", "Makes your ass look great", "res://assets/sprites/ui/equipment_icons/pants.png", mods)
	}
	
	return equipment[item_id]


class Item:
	func _init(
		item_id: ItemId,
		item_type: ItemType,
		item_name : String,
		item_description : String,
		icon_path : String,
		item_mods : Array[ItemMod]):
		
		self.item_id = item_id
		self.item_type = item_type
		self.item_name = item_name
		self.item_description = item_description
		self.icon_path = icon_path
		self.item_mods = item_mods

	var item_id: ItemId = -1
	var item_type: ItemType = ItemType.GENERIC
	var item_name : String = ""
	var item_description : String = ""
	var icon_path : String = "" # asset path to load texture for item
	var item_mods : Array[ItemMod] = [] # list of modications that effect item

# TODO lets move this to its own script, this is currently a proof concept
enum ModType {
	HEATLH,
	MANA_REGEN,
	BLOCK_CHANCE,
	STAB_DAMAGE,
	SLASH_DAMAGE,
	SMASH_DAMAGE
}

enum ModTarget {
	HOLDER,
	ATTACKED,
	OTHER
}

# I changed mod_name to mod_type since it doesnt really need to be customizable
# I've also just made text (use to be mod_description) generate based on type + modifier.

class ItemMod:
	func _init(
		mod_type: ModType,
		mod_amount: float,
		mod_target: ModTarget,
		mod_is_percentage: bool
	):
		self.target = mod_target
		
		# Get amount text
		if mod_amount < 0:
			self.text = "-" + str(abs(mod_amount))
		else:
			self.text = "+" + str(mod_amount)
		
		# Add percent sign if mod is a percentage.
		if mod_is_percentage:
			self.text += "% "
		else:
			self.text += " "
		
		# Figure out which mod name to use.
		match mod_type:
			0: # HEALTH
				self.text += "Health"
			1: # MANA_REGEN
				self.text += "Mana Regen"
			2: # BLOCK_CHANCE
				self.text += "Block Chance"
			3: # STAB_DAMAGE
				self.text += "Stab Damage"
			4: # SLASH_DAMAGE
				self.text += "Slash Damage"
			5: # SMASH_DAMAGE
				self.text += "Smash Damage"
	
	var text : String = "" # What shows up in the item mod list
	var target = null # This will generally be the player, but could be an enemy
	
	# This function will be overridden and programmed to do exactly what player needs
	func use() -> void:
		pass
