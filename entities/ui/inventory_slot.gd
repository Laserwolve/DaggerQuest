extends Control

@onready var TOOL_TIP_NODE = $ToolTip
@onready var ITEM_TEXTURE_NODE = $ItemTexture

var item : ItemManager.Item = null
var is_filled : bool = false
var is_mouse_over : bool
var tool_tip_anchor_offset: Vector2 = Vector2(-1, 0) * Vector2(512, 256) # ToolTip size

func _ready():
	pass # Replace with function body.

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
