extends Control

@onready var item_texture : TextureRect = get_node("ItemTexture")

var item : ItemManager.Item = null
var is_filled : bool = false
var is_mouse_over : bool

func _ready():
	pass # Replace with function body.


func add_item(item : ItemManager.Item) -> void:
	self.item = item
	is_filled = true
	item_texture.texture = load(item.icon_path)
