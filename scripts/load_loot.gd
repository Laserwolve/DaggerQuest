extends Node

const LOOT_PATH: String = "res://assets/sprite_sheets/loot/sprites.loot/"

# Called when the node enters the scene tree for the first time.
func _ready():
	# Loads all the files in the designated path (should be the frames)
	var files: Array[String] = []
	var dir: DirAccess = DirAccess.open(LOOT_PATH)
	if dir:
		dir.list_dir_begin()
		var file_name: String = dir.get_next()
		
		while file_name != "":
			files.push_back(dir.get_current_dir() + file_name.replace(".remap", ""))
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	
	# Sorts the files so there's a reliable order.
	files.sort()
	
	var loot_names: Array[String] = []
	
	for file_name in files:
		var loot_name = file_name.split("_")[1].split("/")[3]
		if !loot_names.has(loot_name):
			loot_names.push_back(loot_name)
	
	# Setup the SpriteFrames
	var sprite_frame: SpriteFrames = SpriteFrames.new()
	for loot_name in loot_names:
		sprite_frame.add_animation(loot_name)
		sprite_frame.set_animation_speed(loot_name, 0)
	
	# Reverse the list for performance
	files.reverse()
	
	# Add all the frames
	for loot_name in loot_names:
		for i in range(0, 16):
			sprite_frame.add_frame(
			loot_name,
			ResourceLoader.load(
				files.pop_back(),
				"Texture2D",
				ResourceLoader.CACHE_MODE_IGNORE
				)
			)
	
	var animated_sprite = AnimatedSprite2D.new()
	animated_sprite.frames = sprite_frame
	add_child(animated_sprite)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass