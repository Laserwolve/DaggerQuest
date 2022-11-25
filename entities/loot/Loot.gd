extends AnimatedSprite2D

var mouse_over: bool = false

var item: ItemManager.Item = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if item == null:
		queue_free()
		return
	
	frames = Global.loot
	
	match item.item_id:
		0:
			set_animation("simplesword")
		1:
			set_animation("simpleleggings")
			
	frame = randi_range(0, 16)

func _input(event):
	if event.is_action_pressed("mouse_accept") && mouse_over:
		var added = Global.player_inventory.add_item_to_first_empty_slot(item)
		if added:
			queue_free()
		

func _mouse_entered():
	mouse_over = true

func _mouse_exited():
	mouse_over = false
