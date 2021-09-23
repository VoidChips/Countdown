extends Node2D

onready var player = $Player
onready var camera = $Camera2D

const spawn_point = Vector2(222, 177)

# Called when the node enters the scene tree for the first time.
func _ready():
	OS.window_size = Config.window_size
	OS.window_fullscreen = Config.window_fullscreen
	
	player.position = spawn_point
	camera.position = spawn_point

func _process(delta):
	if (is_instance_valid(player)):
		# make camera follow player horizontally
		camera.position.x = player.position.x
		
		# respawn player if it fell off map
		if (player.position.y >= 350):
			player.position = spawn_point
			
