extends AnimatedSprite2D

@export var is_body: bool = false
@export var armed_only: bool = false
@export var default: bool = false
@export var extra_offset: Vector2 = Vector2(0.0, 0.0)

const ANIMATONS: Array[String] = [
	"attack",
	"block",
	"die",
	"hit",
	"idle",
	"idleUNARMED",
	"specialA",
	"specialB",
	"specialC",
	"specialD",
	"walk",
	"walkUNARMED"
]

const DIRECTIONS: Array[String] = [
	"-112.5", # 0-9 !
	"-135", # 10-18 !
	"-157.5", # 20-20 !
	"-22.5", # 30-39 !
	"-45", # 40-49 !
	"-67.5", # 50-59 !
	"-90", # 60-69 !
	"0", # 70-79 !
	"112.5", # 80-89 !
	"135", # 90-99 !
	"157.5", # 100-109 !
	"180", # 110-119 !
	"22.5", # 120-129 !
	"45", # 130-139 !
	"67.5", # 140-149 !
	"90" # 150-159 !
]

var animation_player = AnimationPlayer.new()

# Changing the order of stuff in the arrays will break everything so dont pls.
# Unless you write a custom sorter that is.

@export var folder_name: String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	offset = Vector2(0, -75)
	offset += extra_offset
	
	if folder_name == "":
		return

	# Loads all the files in the designated path (should be the frames)
	var files: Array[String] = []
	var dir: DirAccess = DirAccess.open(folder_name)
	if dir:
		dir.list_dir_begin()
		var file_name: String = dir.get_next()
		
		while file_name != "":
			files.push_back(dir.get_current_dir() + "/" + file_name.replace(".remap", ""))
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	
	# Sorts the files so there's a reliable order.
	files.sort()
	
	# Setup the SpriteFrames
	var sprite_frame: SpriteFrames = SpriteFrames.new()
	for animName in ANIMATONS:
		if armed_only && animName.contains("UNARMED"):
			continue
		sprite_frame.add_animation(animName)
		sprite_frame.set_animation_speed(animName, 12)
	
	# Reverse the list for performance
	files.reverse()
	
	# Add all the frames
	for animName in ANIMATONS:
		if armed_only && animName.contains("UNARMED"):
			continue
		for i in range(0, 160):
			sprite_frame.add_frame(
			animName,
			ResourceLoader.load(
				files.pop_back(),
				"Texture2D",
				ResourceLoader.CACHE_MODE_IGNORE
				)
			)
	
	frames = sprite_frame
	
	var animation_player = AnimationPlayer.new()
	
	var animation_speed = 12.0
	var frame_time = 1 / animation_speed
	
	# Create the animation libraries.
	for animName in ANIMATONS:
		if armed_only && animName.contains("UNARMED"):
			continue
		var frame_offset = 0
		var animation_library: AnimationLibrary = AnimationLibrary.new()

		for direction in DIRECTIONS:
			var ani: Animation = Animation.new()
			var track_index: int = ani.add_track(Animation.TYPE_VALUE)
			ani.track_set_path(track_index, String(name) + ":frame")
			
			var ani_track: int = ani.add_track(Animation.TYPE_VALUE)
			ani.track_set_path(ani_track, String(name) + ":animation")
			ani.track_insert_key(ani_track, 0, animName)
			
			for i in range(0, 10):
				ani.track_insert_key(track_index, frame_time * i, i + (10 * frame_offset))
			
			ani.length = frame_time * 9
			if animName.contains("walk") || animName.contains("idle"):
				ani.loop_mode = Animation.LOOP_LINEAR
			
			frame_offset += 1
			animation_library.add_animation(direction, ani)
	
		animation_player.add_animation_library(animName, animation_library)
	
	# Add the animation player to the Player
	get_parent().call_deferred("add_child", animation_player)
	get_parent().get_parent().get_parent().register_animation_player(animation_player)
	
	if is_body:
		animation_player.connect("animation_finished", get_parent().get_parent().get_parent().animation_finished)

func delete():
	get_parent().get_parent().get_parent().unregister_animation_player(animation_player)
	queue_free()
