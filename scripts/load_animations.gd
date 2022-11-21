extends AnimatedSprite2D


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
	"-22.5", # 0-9
	"-45", # 10-18
	"-67.5", # 20-20
	"-90", # 30-39
	"-112.5", # 40-49
	"-135", # 50-59
	"-157.5", # 60-69
	"0", # 70-79
	"22.5", # 80-89
	"45", # 90-99
	"67.5", # 100-109
	"90", # 110-119
	"112.5", # 120-129
	"135", # 130-139
	"157.5", # 140-149
	"180" # 150-159
]

# Changing the order of stuff in the arrays will break everything so dont pls.
# Unless you write a custom sorter that is.

@export var folder_name: String = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	if folder_name == "":
		return

	# Loads all the files in the designated path (should be the frames)
	var files: Array[String] = []
	var dir: DirAccess = DirAccess.open(folder_name)
	if dir:
		dir.list_dir_begin()
		var file_name: String = dir.get_next()
		
		while file_name != "":
			files.push_back(dir.get_current_dir() + "/" + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	
	# Sorts the files so there's a reliable order.
	files.sort()
	
	# Setup the SpriteFrames
	var spriteFrame: SpriteFrames = SpriteFrames.new()
	for animName in ANIMATONS:
		spriteFrame.add_animation(animName)
		spriteFrame.set_animation_speed(animName, 12)
	
	# Reverse the list for performance
	files.reverse()
	
	# Add all the frames
	for animName in ANIMATONS:
		for i in range(0, 160):
			spriteFrame.add_frame(
				animName,
				ResourceLoader.load(
					files.pop_back(),
					"Texture2D",
					ResourceLoader.CACHE_MODE_IGNORE
				)
			)
	
	frames = spriteFrame
	
	var animationPlayer = AnimationPlayer.new()
	
	# Create the animation libraries.
	for animName in ANIMATONS:
		var frame_offset = 0
		var animationLibrary: AnimationLibrary = AnimationLibrary.new()

		for direction in DIRECTIONS:
			var ani: Animation = Animation.new()
			var track_index: int = ani.add_track(Animation.TYPE_VALUE)
			ani.track_set_path(track_index, "Character:frame")
			
			var ani_track: int = ani.add_track(Animation.TYPE_VALUE)
			ani.track_set_path(ani_track, "Character:animation")
			ani.track_insert_key(ani_track, 0, animName)
			
			for i in range(0, 10):
				ani.track_insert_key(track_index, 0.08*i, i + (10 * frame_offset))
			
			ani.length = 0.72
			if animName.contains("walk") || animName.contains("idle"):
				ani.loop_mode = Animation.LOOP_LINEAR
			
			frame_offset += 1
			animationLibrary.add_animation(direction, ani)
	
		animationPlayer.add_animation_library(animName, animationLibrary)
		
	# Set just a default animation
	animationPlayer.play("idle/0")
	
	# Add the animation player to the Player
	get_parent().call_deferred("add_child", animationPlayer)
	get_parent().set_animation_player(animationPlayer)