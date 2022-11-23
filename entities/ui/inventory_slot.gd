extends Control

var equipment : EquipmentManager.Equipment = null
var is_filled : bool = false
var is_mouse_over : bool

func _ready():
	pass # Replace with function body.


func _input(event):
	# Create a random piece of equipment, this is temporary of course
	if Input.is_key_pressed(KEY_S):
		var random_equipment : Array[String] = ["Fart", "Penis"]
#		var equipment : EquipmentManager.Equipment =
		pass
