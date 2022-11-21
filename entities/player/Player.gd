extends CharacterBody2D
class_name Player

# Exported Variables
@export var move_speed: float = 200

# OnReady Variables
@onready var NAVIGATION: NavigationAgent2D = $NavigationAgent2D # ALL_CAPS because it's technically constant.
@onready var ANIMATION_TREE: AnimationTree = $AnimationTree

# Other Variables
var last_delta: float = 0
var look_direction: Vector2 = Vector2(0, 0)

func set_player(animationPlayer: AnimationPlayer):
	ANIMATION_TREE.anim_player = NodePath("../" + String(animationPlayer.name))
	ANIMATION_TREE.active = true

func _ready():
	NAVIGATION.set_target_location(position)
	
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
	
	update_blend_position()

func update_blend_position():
	var animation_mode = ANIMATION_TREE.get("parameters/playback")
	ANIMATION_TREE.set("parameters/Idle Unarmed/blend_position", look_direction)
	animation_mode.travel("Idle Unarmed")

func _safe_velocity_computed(safe_velocity):
	velocity = safe_velocity;
	look_direction = position.direction_to(NAVIGATION.get_next_location())
	update_blend_position()
	if position.distance_to(NAVIGATION.get_next_location()) < move_speed * last_delta:
		position = NAVIGATION.get_next_location()
	else:
		move_and_slide()
