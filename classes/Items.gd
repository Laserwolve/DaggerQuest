extends Node

enum ItemID {
	UNSET,
	SIMPLE_LEGGINGS
}

var items: Dictionary = {
	ItemID.SIMPLE_LEGGINGS: Item.new().register(
		ItemID.SIMPLE_LEGGINGS,
		"res://assets/sprite_sheets/simple_leggings/sprites.simpleLeggings/",
		"res://assets/sprite_sheets/simple_leggings/sprites.simpleLeggings_shadow/",
		"res://assets/sprites/ui/equipment_icons/pants.png"
	)
}

class Item:
	var id : ItemID = ItemID.UNSET
	var equipment_path: String = ""
	var shadow_path: String = ""
	var icon_path: String = ""
	
	func register(id: ItemID, equipmentPath: String, shadowPath: String, iconPath: String) -> Item:
		equipment_path = equipmentPath
		shadow_path = shadowPath
		icon_path = iconPath
		return self
