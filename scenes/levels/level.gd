extends Node2D
class_name Level

const LOOT_INSTANCE = preload("res://entities/loot/Loot.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.level = self

func create_loot(item: ItemManager.Item, pos: Vector2):
	var loot = LOOT_INSTANCE.instantiate()
	loot.item = item
	loot.position = pos
	
	$Loot.add_child(loot)
