extends CharacterBody2D
class_name Player

# Exported Variables
@export var move_speed: float = 200

# OnReady Variables
@onready var NAVIGATION: NavigationAgent2D = $NavigationAgent2D
# ALL_CAPS because it's technically constant, feel free to change it.

# Other Variables
var last_delta: float = 0
var look_direction: Vector2 = Vector2(0, 0)
var animation_players: Array[AnimationPlayer] = []
var forced_animation: String = ""
var final_animation: bool = false

# Constants

func _ready():
	NAVIGATION.set_target_location(position)

func register_animation_player(player: AnimationPlayer):
	animation_players.push_back(player)
	
func _physics_process(delta):
	last_delta = delta
	var target_position: Vector2 = NAVIGATION.get_next_location()
	var animation_name: String = "idleUNARMED"
	
	# Get Inputs
	if Input.is_action_pressed("move") && forced_animation == "":
		look_direction = position.direction_to(get_global_mouse_position())
		NAVIGATION.set_target_location(get_global_mouse_position())
		target_position = get_global_mouse_position()
	
	# Enter
	if Input.is_action_just_pressed("ui_accept"):
		NAVIGATION.set_target_location(position)
		forced_animation = "attack"
	
	# Shift + D
	if Input.is_action_just_pressed("die"):
		NAVIGATION.set_target_location(position)
		play_animation("die/" + get_look_angle(look_direction))
		forced_animation = "die"
		final_animation = true
	
	# Decide whether the player should try and walk or just be idle
	if !NAVIGATION.is_navigation_finished():
		animation_name = "walkUNARMED"
		NAVIGATION.set_velocity(position.direction_to(target_position) * move_speed)
	
	if forced_animation != "":
		animation_name = forced_animation
	
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
		player.play(animation_name)
		if same_category:
			player.seek(old_time, true) 

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
