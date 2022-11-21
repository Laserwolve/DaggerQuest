extends CharacterBody2D
class_name Player

# Exported Variables
@export var move_speed: float = 200

# OnReady Variables
@onready var NAVIGATION: NavigationAgent2D = $NavigationAgent2D # ALL_CAPS because it's technically constant.

# Other Variables
var last_delta: float = 0
var look_direction: Vector2 = Vector2(0, 0)
var animation_players: Array[AnimationPlayer] = []

# Constants

# Tempory implementation of rotation (Still need the .5 values as well)
const LOOK_ANGELS: Array[Vector2] = [
	Vector2(-.5, -.5), # -135
	Vector2(0, -1), # -90
	Vector2(.5, -.5), # -45
	Vector2(1, 0), # 0
	Vector2(.5, .5), # 45
	Vector2(0, 1), # 90
	Vector2(-.5, .5), # 135
	Vector2(-1, 0) # 180
]

const LOOK_NAMES: Array[String] = [
	"-135",
	"-90",
	"-45",
	"0",
	"45",
	"90",
	"135",
	"180"
]

func _ready():
	NAVIGATION.set_target_location(position)

func register_animation_player(player: AnimationPlayer):
	animation_players.push_back(player)
	
func _physics_process(delta):
	last_delta = delta
	var target_position: Vector2 = NAVIGATION.get_next_location()
	
	# Get Inputs
	if Input.is_action_just_pressed("move"):
		NAVIGATION.set_target_location(get_global_mouse_position())
		target_position = get_global_mouse_position()
	
	# Decide whether the player should try and walk or just be idle
	if !NAVIGATION.is_navigation_finished():
		NAVIGATION.set_velocity(position.direction_to(target_position) * move_speed)
	else:
		look_direction = position.direction_to(get_global_mouse_position())
		play_animation("idleUNARMED/" + get_look_angle(look_direction))

	#print(look_direction)
	#print(get_look_angle(look_direction))

func play_animation(animation_name: String):
	for player in animation_players:
		player.play(animation_name)

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
	var shortest_angle = 99.0
	var closest_angle = ""

	for i in range(0, LOOK_ANGELS.size()):
		if look_direction.distance_to(LOOK_ANGELS[i]) < shortest_angle:
			shortest_angle = look_direction.distance_to(LOOK_ANGELS[i])
			closest_angle = LOOK_NAMES[i]

	return closest_angle
