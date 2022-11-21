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

# Constants

func _ready():
	NAVIGATION.set_target_location(position)

func register_animation_player(player: AnimationPlayer):
	animation_players.push_back(player)
	
func _physics_process(delta):
	last_delta = delta
	var target_position: Vector2 = NAVIGATION.get_next_location()
	
	# Get Inputs
	if Input.is_action_pressed("move"):
		look_direction = position.direction_to(get_global_mouse_position())
		NAVIGATION.set_target_location(get_global_mouse_position())
		target_position = get_global_mouse_position()
	
	# Decide whether the player should try and walk or just be idle
	if !NAVIGATION.is_navigation_finished():
		NAVIGATION.set_velocity(position.direction_to(target_position) * move_speed)
	else:
		play_animation("idleUNARMED/" + get_look_angle(look_direction))

	#print(look_direction)
	#print(get_look_angle(look_direction))

func play_animation(animation_name: String):
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

func _safe_velocity_computed(safe_velocity):
	velocity = safe_velocity;
	look_direction = position.direction_to(NAVIGATION.get_next_location())
	
	# Move to target location if close or move towards next point.
	if position.distance_to(NAVIGATION.get_next_location()) < move_speed * last_delta:
		position = NAVIGATION.get_next_location()
	else:
		move_and_slide()
	
	play_animation("walkUNARMED/" + get_look_angle(look_direction))

func get_look_angle(look_direction: Vector2) -> String:
	var angle: float = rad_to_deg(get_angle_to(position + look_direction))
	var string: String = str(round(angle/22.5)*22.5)
	
	if (string == "-180"):
		string = "180"
	elif (string == "-0"):
		string = "0"
	
	return string
