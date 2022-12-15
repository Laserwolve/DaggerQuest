extends CanvasLayer

@onready var inventory : Control = get_node("Inventory")
@onready var mouse_item : Control = get_node("MouseItem")
@onready var FPS_NODE = $FPS
@onready var ENTITIES_NODE = $ENTITIES
@onready var LOOT_NODE = $LOOT

var level_entities_node = null
var level_loot_node = null

func _ready():
	connect_signals()

func _process(_delta):
	FPS_NODE.text = "FPS: " + str(Engine.get_frames_per_second())
	
	if level_loot_node != null:
		ENTITIES_NODE.text = "Entity Count: " + str(level_entities_node.get_child_count())
		LOOT_NODE.text = "Loot Count: " + str(level_loot_node.get_child_count())
	else:
		level_entities_node = Global.level.get_node("Entities")
		level_loot_node = Global.level.get_node("Loot")

# connect all the signals together so the various slots can comminicate with each other
func connect_signals() -> void:
	for slot in get_node("Inventory/Slots").get_children():
		slot.slot_clicked.connect(mouse_item.slot_clicked)
		#slot.pick_up_item.connect(mouse_item._on_pick_up_item)
		#slot.drop_item.connect(mouse_item._on_drop_item)
		pass
		
	for slot in get_node("Equipment/Slots").get_children():
		slot.slot_clicked.connect(mouse_item.slot_clicked)
		slot.item_changed.connect(Global.player.item_changed)
		#slot.pick_up_item.connect(mouse_item._on_pick_up_item)
		#slot.drop_item.connect(mouse_item._on_drop_item)
		pass
