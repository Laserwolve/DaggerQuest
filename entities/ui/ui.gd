extends CanvasLayer

@onready var inventory : Control = get_node("Inventory")
@onready var mouse_item : Control = get_node("MouseItem")

func _ready():
	connect_signals()


# connect all the signals together so the various slots can comminicate with each other
func connect_signals() -> void:
	for slot in get_node("Inventory/Slots").get_children():
		slot.pick_up_item.connect(mouse_item._on_pick_up_item)
		slot.drop_item.connect(mouse_item._on_drop_item)
		pass
