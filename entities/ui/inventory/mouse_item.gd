extends Control

@onready var item_texture : TextureRect = get_node("ItemTexture")

var item_contained : ItemManager.Item = null
const ICON_RADIUS : int = 32

func _process(_delta):
	item_texture.position = get_viewport().get_mouse_position() - Vector2(ICON_RADIUS, ICON_RADIUS)


func _on_pick_up_item(item : ItemManager.Item, slot: InventorySlot):
	item_contained = item
	item_texture.texture = load(item.icon_path)
	
	slot.set_item(null)

func _on_drop_item(slot: InventorySlot):
	if slot.slot_limits.size() > 0:
		print(slot.slot_limits.has(item_contained.item_type))
		if slot.slot_limits.has(item_contained.item_type):
			slot.set_item(item_contained)
			item_contained = null
			item_texture.texture = null
	else:
		print("Not Limited")
		slot.set_item(item_contained)
		item_contained = null
		item_texture.texture = null
	
	

func _unhandled_input(input):
	if input.is_action_pressed("mouse_accept"):
		if item_contained != null:
			Global.level.create_loot(item_contained, get_global_mouse_position())
			item_contained = null
			item_texture.texture = null
