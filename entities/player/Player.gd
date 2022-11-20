extends CharacterBody2D
class_name Player

# Exported Variables
@export var MOVE_SPEED: float = 200;

# OnReady Variables
@onready var NAVIGATION: NavigationAgent2D = $NavigationAgent2D;

# Other Variables
var last_delta: float = 0;

func _ready():
	NAVIGATION.set_target_location(position);
	
func _physics_process(_delta):
	last_delta = _delta;
	var target_position: Vector2 = NAVIGATION.get_next_location();
	# Get Inputs
	if Input.is_action_just_pressed("move"):
		NAVIGATION.set_target_location(get_global_mouse_position());
		target_position = get_global_mouse_position()
	
	var moving = !NAVIGATION.is_navigation_finished();
	
	if moving:
		NAVIGATION.set_velocity(position.direction_to(target_position) * MOVE_SPEED)

func _safe_velocity_computed(safe_velocity):
	velocity = safe_velocity;
	if position.distance_to(NAVIGATION.get_next_location()) < MOVE_SPEED * last_delta:
		position = NAVIGATION.get_next_location()
	else:
		move_and_slide()
