extends Control
class_name InventorySlot

@onready var TOOL_TIP_NODE = $ToolTip
@onready var ITEM_TEXTURE_NODE = $ItemTexture

var item : ItemManager.Item = null
var is_filled : bool = false
var is_mouse_over : bool
@export var tool_tip_anchor_offset: Vector2 = Vector2(-1, 0)
@export var slot_limits: Array[ItemManager.ItemSlot] = []
@export var slot_overlay: String = ""

var overlay_node = null

signal slot_clicked(slot)
signal item_changed(slot)

func _ready():
	tool_tip_anchor_offset *= Vector2(512, 256) # Tool Tip Size
	
	if slot_overlay != "":
		var resource = load(slot_overlay)
		var sprite = Sprite2D.new()
		sprite.texture = resource
		sprite.name = "Overlay"
		overlay_node = sprite
		add_child(sprite)

func _input(event):
	if event.is_action_pressed("mouse_accept") and is_mouse_over:
		slot_clicked.emit(self)

func set_item(new_item: ItemManager.Item):
	if new_item == null:
		is_filled = false
		ITEM_TEXTURE_NODE.texture = null
	else:
		is_filled = true
		ITEM_TEXTURE_NODE.texture = load(new_item.icon_path)
		$ToolTip/ItemName.text = new_item.item_name
		$ToolTip/ItemDescription.text = new_item.item_description
		
		var mods_node = $ToolTip/ItemMods
		mods_node.text = ""
		
		for mod in new_item.item_mods:
			mods_node.text += mod.text + "\n"
	
	item = new_item
	item_changed.emit(self)
	
	if overlay_node != null:
		overlay_node.visible = !is_filled
	
func swap_item(new_item: ItemManager.Item) -> ItemManager.Item:
	if slot_limits.size() > 0:
		if new_item == null || slot_limits.has(new_item.item_type):
			var current_item = item
			set_item(new_item)
			return current_item
		else:
			return new_item
	else:
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
