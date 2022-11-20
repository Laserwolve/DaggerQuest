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
	"-22.5",
	"-45",
	"-67.5",
	"-90",
	"-112.5",
	"135",
	"157.5",
	"0",
	"22.5",
	"45",
	"67.5",
	"90",
	"112.5",
	"135",
	"157.5",
	"180"
]

# 0-9 = -22.5
# 10-18 = -45
# 20-20 = -67.5
# 30-39 = -90
# 40-49 = -112.5
# 50-59 = 135
# 60-69 = 157.5
# 70-79 = 0
# 80-89 = 22.5
# 90-99 = 45
# 100-109 = 67.5
# 110-119 = 90
# 120-129 = 112.5
# 130-139 = 135
# 140-149 = 157.5
# 150-159 = 180

@export var folder_name: String = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	if folder_name == "":
		return

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
	
	files.sort()
	
	var spriteFrame: SpriteFrames = SpriteFrames.new()

	for animName in ANIMATONS:
		spriteFrame.add_animation(animName)
		spriteFrame.set_animation_speed(animName, 12)
	
	files.reverse()
	for animName in ANIMATONS:
		for i in range(0, 160):
			spriteFrame.add_frame(animName, ResourceLoader.load(files.pop_back(), "Texture2D", ResourceLoader.CACHE_MODE_IGNORE))
	
	frames = spriteFrame
	
	var animationPlayer = AnimationPlayer.new()
	
	for animName in ANIMATONS:
		var frame_offset = 0
		var animationLibrary: AnimationLibrary = AnimationLibrary.new()
		var ani: Animation = Animation.new()
		var track_index: int = ani.add_track(Animation.TYPE_VALUE)
		ani.track_set_path(track_index, "Character:frame")
		
		var ani_track: int = ani.add_track(Animation.TYPE_VALUE)
		ani.track_set_path(ani_track, "Character:animation")
		ani.track_insert_key(ani_track, 0, animName)
	
		for direction in DIRECTIONS:
			for i in range(0, 10):
				ani.track_insert_key(track_index, 0.08*i, i + (10 * frame_offset))
				
			frame_offset += 1
			animationLibrary.add_animation(direction, ani)
	
		animationPlayer.add_animation_library(animName, animationLibrary)
	animationPlayer.play("idle/0")
	get_parent().call_deferred("add_child", animationPlayer)
