extends Node2D

onready var player := $Player
onready var camera := $Camera2D
onready var pause_menu := $PauseMenu
onready var timer := $Timer
onready var time_lbl := $TimeLbl

var remaining_time := 10.0

const spawn_point = Vector2(222, 177)

func _ready():
	player.position = spawn_point
	camera.position = spawn_point
	pause_menu.set_position(spawn_point)
	time_lbl.set_position(Vector2(player.position.x, player.position.y - 50))
	time_lbl.text = str(remaining_time)
	timer.start()
	
	
func _process(delta):
	# make camera follow player horizontally
	camera.position.x = player.position.x
	pause_menu.set_position(player.position)
	time_lbl.set_position(Vector2(player.position.x, player.position.y - 50))
		
	# respawn player if it fell off map
	if (player.position.y >= 350):
		player.position = spawn_point
		
	var pause := Input.is_action_just_pressed("pause")
	
	if pause:
		get_tree().paused = true
		pause_menu.show()
		
	if not player.is_poisoned:
		timer.stop()
		time_lbl.text = ""
		
	if player.is_dead:
		game_over()
		
func game_over():
	time_lbl.text = "You didn't make it..."

# define pause menu actions
func _on_PauseMenu_id_pressed(id):
	get_tree().paused = false
	if id == 0:
		pause_menu.hide()
	else:
		get_tree().change_scene("res://scenes/MainMenu.tscn")

func _on_Timer_timeout():
	remaining_time = remaining_time - 1.0
	time_lbl.text = str(remaining_time)
	
	if remaining_time == 0.0:
		timer.stop()
		if player.is_poisoned:
			player.is_dead = true
			
