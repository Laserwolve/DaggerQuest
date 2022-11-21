extends CharacterBody2D
class_name Player

# Exported Variables
@export var move_speed: float = 200

# OnReady Variables
@onready var NAVIGATION: NavigationAgent2D = $NavigationAgent2D # ALL_CAPS because it's technically constant.

# Other Variables
var last_delta: float = 0
var look_direction: Vector2 = Vector2(0, 0)
var animation_player: AnimationPlayer = null

# Constants
const LOOK_ANGELS: Array[Vector2] = [
	Vector2(-1, 0),
	Vector2(0, 1),
	Vector2(1, 0),
	Vector2(-1, 0)
] # Four directions for now.

const LOOK_NAMES: Array[String] = [
	"-90",
	"0",
	"90",
	"180"
]

func _ready():
	NAVIGATION.set_target_location(position)

func set_animation_player(player: AnimationPlayer):
	animation_player = player
	
func _physics_process(delta):
	last_delta = delta
	var target_position: Vector2 = NAVIGATION.get_next_location()
	# Get Inputs
	if Input.is_action_just_pressed("move"):
		NAVIGATION.set_target_location(get_global_mouse_position())
		target_position = get_global_mouse_position()
	
	if !NAVIGATION.is_navigation_finished():
		NAVIGATION.set_velocity(position.direction_to(target_position) * move_speed)
	else:
		look_direction = position.direction_to(get_global_mouse_position())
	
func _safe_velocity_computed(safe_velocity):
	velocity = safe_velocity;
	look_direction = position.direction_to(NAVIGATION.get_next_location())
	if position.distance_to(NAVIGATION.get_next_location()) < move_speed * last_delta:
		position = NAVIGATION.get_next_location()
	else:
		move_and_slide()

func getLookAngel(look_direction: Vector2) -> String:
	var shortest_angle = 99.0
	var closest_angle = ""

	for i in range(0, LOOK_ANGELS.size()):
		if look_direction.distance_to(LOOK_ANGELS[i]) < shortest_angle:
			shortest_angle = look_direction.distance_to(LOOK_ANGELS[i])
			closest_angle = LOOK_NAMES[i]

	return closest_angle
