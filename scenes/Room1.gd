extends Node2D

onready var player = $Player
onready var camera = $Camera2D

const spawn_point = Vector2(338, 419)

# Called when the node enters the scene tree for the first time.
func _ready():
	player.position = spawn_point
	camera.position = spawn_point

func _process(delta):
	if (is_instance_valid(player)):
		# make camera follow player horizontally
		camera.position.x = player.position.x
		
		# respawn player if it fell off map
		if (player.position.y >= 700):
			player.position = spawn_point
			
