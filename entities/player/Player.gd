extends CharacterBody2D
class_name Player

# Exported Variables
@export var move_speed: float = 200

# OnReady Variables
@onready var NAVIGATION: NavigationAgent2D = $NavigationAgent2D # ALL_CAPS because it's technically constant.

# Other Variables
var last_delta: float = 0

func _ready():
	NAVIGATION.set_target_location(position)
	
func _physics_process(_delta):
	last_delta = _delta
	var target_position: Vector2 = NAVIGATION.get_next_location()
	# Get Inputs
	if Input.is_action_just_pressed("move"):
		NAVIGATION.set_target_location(get_global_mouse_position())
		target_position = get_global_mouse_position()
	
	if !NAVIGATION.is_navigation_finished():
		NAVIGATION.set_velocity(position.direction_to(target_position) * move_speed)

func _safe_velocity_computed(safe_velocity):
	velocity = safe_velocity;
	if position.distance_to(NAVIGATION.get_next_location()) < move_speed * last_delta:
		position = NAVIGATION.get_next_location()
	else:
		move_and_slide()
