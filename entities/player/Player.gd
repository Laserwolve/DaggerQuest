extends CharacterBody2D
class_name Player

# Exported Variables
@export var move_speed: float = 200

# Enums
enum EquipmentSlots {
	BODY,
	LEGS,
	FEET,
	SHIRT,
	HAT,
	GLOVES,
	ARMS,
	MAIN_HAND,
	OFFHAND
}

# OnReady Variables
@onready var NAVIGATION: NavigationAgent2D = $NavigationAgent2D
# ALL_CAPS because it's technically constant, feel free to change it.

# Other Variables
var last_delta: float = 0
var look_direction: Vector2 = Vector2(0, 0)
var animation_players: Array[AnimationPlayer] = []
var forced_animation: String = ""
var final_animation: bool = false
var armed = true

@onready var EQUIPMENT_NODES: Dictionary = {
	EquipmentSlots.BODY: $Equipment/Body,
	EquipmentSlots.LEGS: $Equipment/Legs,
	EquipmentSlots.FEET: $Equipment/Feet,
	EquipmentSlots.SHIRT: $Equipment/Shirt,
	EquipmentSlots.HAT: $Equipment/Hat,
	EquipmentSlots.GLOVES: $Equipment/Gloves,
	EquipmentSlots.ARMS: $Equipment/Arms,
	EquipmentSlots.MAIN_HAND: $Equipment/MainHand,
	EquipmentSlots.OFFHAND: $Equipment/Offhand
}

@onready var SHADOW_NODES: Dictionary = {
	EquipmentSlots.BODY: $Shadows/Body,
	EquipmentSlots.LEGS: $Shadows/Legs,
	EquipmentSlots.FEET: $Shadows/Feet,
	EquipmentSlots.SHIRT: $Shadows/Shirt,
	EquipmentSlots.HAT: $Shadows/Hat,
	EquipmentSlots.GLOVES: $Shadows/Gloves,
	EquipmentSlots.ARMS: $Shadows/Arms,
	EquipmentSlots.MAIN_HAND: $Shadows/MainHand,
	EquipmentSlots.OFFHAND: $Shadows/Offhand
}

# Constants
const EQUIPED_ITEM = preload("res://entities/shared/EquipedItem.tscn")

func _ready():
	NAVIGATION.set_target_location(position)

func register_animation_player(player: AnimationPlayer):
	animation_players.push_back(player)
	play_animation("hit/0")
	
func unregister_animation_player(player: AnimationPlayer):
	animation_players.erase(player)
	
func _physics_process(delta):
	last_delta = delta
	var target_position: Vector2 = NAVIGATION.get_next_location()
	var animation_name: String = "idle"
	
	# Get Inputs
	if Input.is_action_pressed("move") && forced_animation == "":
		look_direction = position.direction_to(get_global_mouse_position())
		NAVIGATION.set_target_location(get_global_mouse_position())
		target_position = get_global_mouse_position()
	
	# Debug Inputs (Will be replaced/removed later
	
	if Input.is_action_just_pressed("toggle_legs"): # Enter
		toggle_legs()
	
	if Input.is_action_just_pressed("ui_accept") && armed: # Enter
		NAVIGATION.set_target_location(position)
		forced_animation = "attack"
	
	if Input.is_action_just_pressed("toggle_armed"): # A
		armed = !armed
	
	if Input.is_action_just_pressed("die"): # Shift + D
		NAVIGATION.set_target_location(position)
		play_animation("die/" + get_look_angle(look_direction))
		forced_animation = "die"
		final_animation = true
		
	#====================================================
	
	# Decide whether the player should try and walk or just be idle
	if !NAVIGATION.is_navigation_finished():
		animation_name = "walk"
		NAVIGATION.set_velocity(position.direction_to(target_position) * move_speed)
	
	if forced_animation != "":
		animation_name = forced_animation
	
	if !armed && (animation_name == "walk" || animation_name == "idle"):
		animation_name += "UNARMED"
	
	EQUIPMENT_NODES[EquipmentSlots.MAIN_HAND].visible = armed
	SHADOW_NODES[EquipmentSlots.MAIN_HAND].visible = armed
	
	play_animation(animation_name + "/" + get_look_angle(look_direction))

func play_animation(animation_name: String):
	if final_animation:
		return
	if animation_players.size() == 0:
		return
	if animation_name == animation_players[0].current_animation:
		return
	
	var same_category = false
	if animation_name.split("/")[0] == animation_players[0].current_animation.split("/")[0]:
		same_category = true
	
	for player in animation_players:
		var old_time: float = player.current_animation_position
		if player.has_animation(animation_name):
			player.play(animation_name)
		if same_category:
			player.seek(old_time, true) 
		else:
			player.seek(0, true)

func damage(amount: float):
	NAVIGATION.set_target_location(position)
	forced_animation = "hit"
	
func die():
	NAVIGATION.set_target_location(position)
	forced_animation = "die"

func animation_finished(animation_name: String):
	if !final_animation:
		forced_animation = ""

func _safe_velocity_computed(safe_velocity):
	velocity = safe_velocity;
	look_direction = position.direction_to(NAVIGATION.get_next_location())
	
	# Move to target location if close or move towards next point.
	if position.distance_to(NAVIGATION.get_next_location()) < move_speed * last_delta:
		position = NAVIGATION.get_next_location()
	else:
		move_and_slide()

func get_look_angle(look_direction: Vector2) -> String:
	var angle: float = rad_to_deg(get_angle_to(position + look_direction))
	var string: String = str(round(angle/22.5)*22.5)
	
	if (string == "-180"):
		string = "180"
	elif (string == "-0"):
		string = "0"
	
	return string

func toggle_legs():
	if EQUIPMENT_NODES[EquipmentSlots.LEGS].get_child_count() == 0:
		var legs = EQUIPED_ITEM.instantiate()
		var legs_shadow = EQUIPED_ITEM.instantiate()
		legs.folder_name = Items.items[Items.ItemID.SIMPLE_LEGGINGS].equipment_path
		legs_shadow.folder_name = Items.items[Items.ItemID.SIMPLE_LEGGINGS].shadow_path
		
		EQUIPMENT_NODES[EquipmentSlots.LEGS].add_child(legs)
		SHADOW_NODES[EquipmentSlots.LEGS].add_child(legs_shadow)
	else:
		for child in EQUIPMENT_NODES[EquipmentSlots.LEGS].get_children():
			child.delete()
		for child in SHADOW_NODES[EquipmentSlots.LEGS].get_children():
			child.delete()
