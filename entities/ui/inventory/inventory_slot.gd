extends Control
class_name InventorySlot

@onready var TOOL_TIP_NODE = $ToolTip
@onready var ITEM_TEXTURE_NODE = $ItemTexture

var item : ItemManager.Item = null
var is_filled : bool = false
var is_mouse_over : bool
var tool_tip_anchor_offset: Vector2 = Vector2(-1, 0)

signal pick_up_item(item)
signal drop_item(slot)

func _ready():
	tool_tip_anchor_offset *= Vector2(512, 256) # Tool Tip Size

func _input(event):
	if event.is_action_pressed("mouse_accept") and is_mouse_over:
		if is_filled:
			pick_up_item.emit(item)
			call_deferred("set_item", null)
		else:
			drop_item.emit(self)

func set_item(new_item: ItemManager.Item):
	if new_item == null:
		is_filled = false
		ITEM_TEXTURE_NODE.texture = null
	else:
		is_filled = true
		ITEM_TEXTURE_NODE.texture = load(new_item.icon_path)
		$ToolTip/ItemName.text = new_item.item_name
		$ToolTip/ItemDescription.text = new_item.item_description
	
	item = new_item
	
func swap_item(new_item: ItemManager.Item) -> ItemManager.Item:
	var current_item = item
	set_item(new_item)
	return current_item

func _process(_delta):
	if is_mouse_over && item != null:
		TOOL_TIP_NODE.visible = true
		TOOL_TIP_NODE.global_position = get_global_mouse_position() + tool_tip_anchor_offset
	else:
		TOOL_TIP_NODE.visible = false

func _mouse_entered():
	is_mouse_over = true

func _mouse_exited():
	is_mouse_over = false
