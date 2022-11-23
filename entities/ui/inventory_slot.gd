extends Control

@onready var item_texture : TextureRect = get_node("ItemTexture")

var item : ItemManager.Item = null
var is_filled : bool = false
var is_mouse_over : bool

signal pick_up_item(item)

func _ready():
	pass # Replace with function body.


func _input(event):
	if event.is_action_pressed("mouse_accept") and is_mouse_over and is_filled:
		print("hey")
		pick_up_item.emit(item)
		call_deferred("remove_item")


func add_item(item : ItemManager.Item) -> void:
	self.item = item
	is_filled = true
	item_texture.texture = load(item.icon_path)


func remove_item() -> void:
	item = null
	is_filled = false
	item_texture.texture = null


func _on_mouse_entered():
	is_mouse_over = true


func _on_mouse_exited():
	is_mouse_over = false
