extends AnimatedSprite2D

var mouse_over: bool = false

var item: ItemManager.Item = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event):
	if event.is_action_pressed("mouse_accept") && mouse_over:
		var added = Global.player_inventory.add_item_to_first_empty_slot(item)
		if added:
			queue_free()
		

func _mouse_entered():
	mouse_over = true

func _mouse_exited():
	mouse_over = false
