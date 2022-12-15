extends CharacterBody2D
class_name Player

# Exported Variables
@export var move_speed: float = 200

# Enums
enum EquipmentSlots {
	NONE,
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
var armed: bool = true

var respect_move_held: bool = false

# Constants
const EQUIPED_ITEM = preload("res://entities/shared/EquipedItem.tscn")

@onready var EQUIPMENT_NODES: Dictionary = {
	EquipmentSlots.BODY: Equipment.new(EQUIPED_ITEM, $Equipment/Body, $Shadows/Body, false, false),
	EquipmentSlots.LEGS: Equipment.new(EQUIPED_ITEM, $Equipment/Legs, $Shadows/Legs, true, false),
	EquipmentSlots.FEET: Equipment.new(EQUIPED_ITEM, $Equipment/Feet, $Shadows/Feet, false, false),
	EquipmentSlots.SHIRT: Equipment.new(EQUIPED_ITEM, $Equipment/Shirt, $Shadows/Shirt, true, false),
	EquipmentSlots.HAT: Equipment.new(EQUIPED_ITEM, $Equipment/Head, $Shadows/Head, true, false),
	EquipmentSlots.GLOVES: Equipment.new(EQUIPED_ITEM, $Equipment/Gloves, $Shadows/Gloves, false, false),
	EquipmentSlots.ARMS: Equipment.new(EQUIPED_ITEM, $Equipment/Arms, $Shadows/Arms, false, false),
	EquipmentSlots.MAIN_HAND: Equipment.new(EQUIPED_ITEM, $Equipment/MainHand, $Shadows/MainHand, false, true),
	EquipmentSlots.OFFHAND: Equipment.new(EQUIPED_ITEM, $Equipment/Offhand, $Shadows/Offhand, false, true)
}

func _init():
	Global.player = self

func _ready():
	NAVIGATION.set_target_location(position)

func register_animation_player(player: AnimationPlayer):
	animation_players.push_back(player)
	play_animation("hit/0")
	
func unregister_animation_player(player: AnimationPlayer):
	animation_players.erase(player)

func _unhandled_input(input):
	if input.is_action_pressed("move") && forced_animation == "":
		respect_move_held = true
		look_direction = position.direction_to(get_global_mouse_position())
		NAVIGATION.set_target_location(get_global_mouse_position())

func _physics_process(delta):
	last_delta = delta
	var target_position: Vector2 = NAVIGATION.get_next_location()
	var animation_name: String = "idle"
	
	# Get Inputs
	
	if Input.is_action_pressed("move") && respect_move_held:
		look_direction = position.direction_to(get_global_mouse_position())
		NAVIGATION.set_target_location(get_global_mouse_position())
		
	if Input.is_action_just_released("move"):
		respect_move_held = false
	
	if Input.is_action_just_pressed("inventory"):
		$UI/Inventory.visible = !$UI/Inventory.visible
		
	if Input.is_action_just_pressed("character_menu"):
		$UI/Equipment.visible = !$UI/Equipment.visible
		
	if Input.is_action_just_pressed("attack") && armed:
		NAVIGATION.set_target_location(position)
		forced_animation = "attack"
	
	# Debug Inputs (Will be replaced/removed later
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
	
	# Use a forced animation if one is set.
	if forced_animation != "":
		animation_name = forced_animation
	
	# Set the walk/idle animations to their UNARMED variant if player is unarmed.
	if !armed && (animation_name == "walk" || animation_name == "idle"):
		animation_name += "UNARMED"
	
	# Hide/Show main hand and offhand based on armed status.
	EQUIPMENT_NODES[EquipmentSlots.MAIN_HAND].setHidden(armed)
	EQUIPMENT_NODES[EquipmentSlots.OFFHAND].setHidden(armed)
	
	play_animation(animation_name + "/" + get_look_angle(look_direction))

func item_changed(item_slot: InventorySlot):
	if !(item_slot is EquipmentSlot):
		return
		
	match item_slot.equipmentSlot:
		-1: # NONE
			pass
		0: # BODY
			pass
		1: # LEGS
			EQUIPMENT_NODES[EquipmentSlots.LEGS].setEquipment(item_slot.item)
		2: # FEET
			EQUIPMENT_NODES[EquipmentSlots.FEET].setEquipment(item_slot.item)
		3: # SHIRT
			EQUIPMENT_NODES[EquipmentSlots.SHIRT].setEquipment(item_slot.item)
		4: # HAT
			EQUIPMENT_NODES[EquipmentSlots.HAT].setEquipment(item_slot.item)
		5: # GLOVES
			EQUIPMENT_NODES[EquipmentSlots.GLOVES].setEquipment(item_slot.item)
		6: # ARMS
			EQUIPMENT_NODES[EquipmentSlots.ARMS].setEquipment(item_slot.item)
		7: # MAIN_HAND
			EQUIPMENT_NODES[EquipmentSlots.MAIN_HAND].setEquipment(item_slot.item)
		8: # OFFHAND
			EQUIPMENT_NODES[EquipmentSlots.OFFHAND].setEquipment(item_slot.item)

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

func damage(_amount: float):
	NAVIGATION.set_target_location(position)
	forced_animation = "hit"
	
func die():
	NAVIGATION.set_target_location(position)
	forced_animation = "die"

func animation_finished(_animation_name: String):
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

func get_look_angle(_look_direction: Vector2) -> String:
	var angle: float = rad_to_deg(get_angle_to(position + look_direction))
	var string: String = str(round(angle/22.5)*22.5)
	
	if (string == "-180"):
		string = "180"
	elif (string == "-0"):
		string = "0"
	
	return string

class Equipment:
	var equipmentRootNode = null
	var equipmentRootShadowNode = null
	var hasDefault = false
	var armedOnly = false
	
	var EQUIPED_ITEM = null
	
	var equipmentNode = null
	var equipmentShadowNode = null
	
	func _init(
		EQUIPED_ITEM,
		equipmentRootNode: Node,
		equipmentRootShadowNode: Node,
		hasDefault: bool,
		armedOnly: bool
	):
		self.EQUIPED_ITEM = EQUIPED_ITEM
		self.equipmentRootNode = equipmentRootNode
		self.equipmentRootShadowNode = equipmentRootShadowNode
		self.hasDefault = hasDefault
		self.armedOnly = armedOnly
		
	func setEquipment(item: ItemManager.Item):
		if item == null:
			if hasDefault:
				equipmentRootNode.get_node("default").visible = true
				equipmentRootShadowNode.get_node("default").visible = true
			
			if equipmentNode != null:
				equipmentNode.queue_free()
			if equipmentShadowNode != null:
				equipmentShadowNode.queue_free()
				
			equipmentNode = null
			equipmentShadowNode = null
		else:
			equipmentNode = EQUIPED_ITEM.instantiate()
			equipmentShadowNode = EQUIPED_ITEM.instantiate()
			
			equipmentNode.folder_name = item.equipment_path
			equipmentShadowNode.folder_name = item.equipment_shadow_path
			
			equipmentNode.armed_only = armedOnly
			equipmentShadowNode.armed_only = armedOnly
			
			equipmentRootNode.add_child(equipmentNode)
			equipmentRootShadowNode.add_child(equipmentShadowNode)
			
			if hasDefault:
				equipmentRootNode.get_node("default").visible = false
				equipmentRootShadowNode.get_node("default").visible = false

	func setHidden(hidden: bool):
		equipmentRootNode.visible = hidden
		equipmentRootShadowNode.visible = hidden
