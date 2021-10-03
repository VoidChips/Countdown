extends Node2D

onready var player = $Player
onready var camera = $Camera2D
onready var pause_menu = $PauseMenu

const spawn_point = Vector2(222, 177)

# Called when the node enters the scene tree for the first time.
func _ready():
	player.position = spawn_point
	camera.position = spawn_point
	pause_menu.set_position(spawn_point)
	
func _process(delta):
	# make camera follow player horizontally
	camera.position.x = player.position.x
	pause_menu.set_position(player.position)
		
	# respawn player if it fell off map
	if (player.position.y >= 350):
		player.position = spawn_point
		
	var pause := Input.is_action_just_pressed("pause")
	
	if pause:
		get_tree().paused = true
		pause_menu.show()

# define pause menu actions
func _on_PauseMenu_id_pressed(id):
	get_tree().paused = false
	if id == 0:
		pause_menu.hide()
	else:
		get_tree().change_scene("res://scenes/MainMenu.tscn")
		
		
