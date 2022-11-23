extends Control

@onready var TOOL_TIP_NODE = $ToolTip
@onready var ITEM_TEXTURE_NODE = $ItemTexture

var item : ItemManager.Item = null
var is_filled : bool = false
var is_mouse_over : bool
var tool_tip_anchor_corner: int = 1 # TL = 0, TR = 1, BL = 3, BR = 4

func _ready():
	pass # Replace with function body.

func set_item(new_item: ItemManager.Item):
	if new_item == null:
		is_filled = false
		ITEM_TEXTURE_NODE.texture = null
	else:
		is_filled = true
		ITEM_TEXTURE_NODE.texture = load(new_item.icon_path)
	
	item = new_item

func _process(_delta):
	if is_mouse_over:
		TOOL_TIP_NODE.visible = true
	else:
		TOOL_TIP_NODE.visible = false

func _mouse_entered():
	print("Mouse Entered")
	is_mouse_over = true

func _mouse_exited():
	print("Mouse Exited")
	is_mouse_over = false
