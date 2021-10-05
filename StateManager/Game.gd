extends Node


# setup scene at the beginning
func setup_scene(nodes : Dictionary) -> void:
	var player = nodes["player"]
	var camera = nodes["camera"]
	var pause_menu = nodes["pause_menu"]
	var spawn_point = nodes["spawn_point"]
	var time_lbl = nodes["time_lbl"]
	var timer = nodes["timer"]
	var remaining_time = nodes["remaining_time"]
	
	player.position = spawn_point
	camera.position = spawn_point
	pause_menu.set_position(spawn_point)
	time_lbl.set_position(Vector2(player.position.x, player.position.y - 50))
	time_lbl.text = str(remaining_time)
	timer.start()
	

func check_player_status(player, timer : Timer, time_lbl : Label) -> void:
	if not player.is_poisoned:
		timer.stop()
		time_lbl.text = ""
		get_tree().change_scene("res://scenes/Room2.tscn")
		
	if player.is_dead:
		game_over(time_lbl)


# handle game over actions
func game_over(time_lbl : Label) -> void:
	time_lbl.text = "You didn't make it..."


# respawn an object to a position
func respawn(obj, spawn_point : Vector2) -> void:
	obj.position = spawn_point
	

func pause_input_check(pause_menu : PopupMenu) -> void:
	var pause := Input.is_action_just_pressed("pause")
	
	if pause:
		get_tree().paused = true
		pause_menu.show()


func handle_pause_menu_selection(id : int, pause_menu : PopupMenu) -> void:
	get_tree().paused = false
	if id == 0:
		pause_menu.hide()
	else:
		get_tree().change_scene("res://scenes/MainMenu.tscn")


func handle_timeout(player, time_lbl : Label, timer : Timer, remaining_time : float) -> float:
	remaining_time = remaining_time - 1.0
	time_lbl.text = str(remaining_time)
	
	if remaining_time == 0.0:
		timer.stop()
		if player.is_poisoned:
			player.is_dead = true
			
	return remaining_time


func handle_potion_collision(body : Node, player, potion, potion_name : String) -> void:
	if (body.get_name() == "Player"):
		player.inventory["cure potion"] = 100
		potion.queue_free()
