extends Node

var _status := {
	"is_new_game" : true,
	"curr_scene" : "main_menu",
	"prev_scene" : null,
	"curr_room" : "room1",
	"room_completed" : false,
	"room_failed" : false,
	"selected_potion" : 0,
	"music_pos" : 0.0,
}

var music_player : AudioStreamPlayer

enum PotionTypes {
	CURE,
	POISON,
	SPEED_DOWN,
	SPEED_UP,
	JUMP_BOOST,
}

const SAVE_DIR = "user://saves/"
const SAVE_PATH = SAVE_DIR + "save.dat"

const SCENE_PATHS := {
	"main_menu": "res://scenes/MainMenu.tscn",
	"options_menu": "res://scenes/OptionsMenu.tscn",
	"room1": "res://scenes/Room1.tscn",
	"room2": "res://scenes/Room2.tscn",
	"room3" : "res://scenes/Room3.tscn",
	"game_over_screen": "res://scenes/GameOverScreen.tscn",
}

# music for each scene
const MUSIC_FILES := {
	"main_menu": "res://assets/music/destiny-day-by-kevin-macleod-from-filmmusic-io.mp3",
	"options_menu": "res://assets/music/destiny-day-by-kevin-macleod-from-filmmusic-io.mp3",
	"room1": "res://assets/music/bensound-straight.mp3",
	"room2": "res://assets/music/bensound-straight.mp3",
	"room3" : "res://assets/music/level-up-by-kevin-macleod-from-filmmusic-io.mp3",
	"game_over_screen": "res://assets/music/bensound-straight.mp3",
}


func _ready():
	load_game()


# return all status information
func get_status() -> Dictionary:
	return _status.duplicate(true)
	

# set a status
func set_status(key : String, value):
	_status[key] = value


# load game data from the save file
func load_game() -> void:
	var file = File.new()
	if file.file_exists(SAVE_PATH):
		var error = file.open_encrypted_with_pass(SAVE_PATH, File.READ, Secret.password)
		if error != OK:
			print("Unable to open config.cfg. Error code: %s" % error)
			return
		_status = file.get_var()
		PlayerState.set_states(file.get_var())
	
	file.close()


# save game data to the save file
func save_game() -> void:
	var dir = Directory.new()
	if not dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
	
	
	var file = File.new()
	var error = file.open_encrypted_with_pass(SAVE_PATH, File.WRITE, Secret.password)
	if error != OK:
		print("Unable to open config.cfg. Error code: %s" % error)
		return
	file.store_var(_status)
	file.store_var(PlayerState.get_states())
	file.close()


# reset _status
# resetAll flag resets everything
func reset(resetAll : bool) -> void:
	if resetAll:
		_status["is_new_game"] = true
		_status["curr_scene_path"] = "res://scenes/Room1.tscn"
		_status["selected_potion"] = 0
	
	_status["prev_scene"] = null
	_status["room_completed"] = false
	_status["room_failed"] = false
	_status["music_pos"] = 0.0


# get the path of current room
func getCurrRoomPath() -> String:
	return SCENE_PATHS[_status["curr_room"]]


# Play music using a's stream.
# Music from previous scene will be played if there is no stream in a
# or default to one if there is no previous scene
func play_music(a : AudioStreamPlayer) -> void:
	if a.get_stream() == null:
		if _status["prev_scene"] != null:
			a.set_stream(load(MUSIC_FILES[_status["prev_scene"]]))
		else:
			a.set_stream(load(MUSIC_FILES["room1"]))

	music_player = a
	music_player.play()
	music_player.seek(_status["music_pos"])
	

# play the next music from the beginning	
func set_music_beginning(b : bool) -> void:
	if b:
		_status["music_pos"] = 0.0


# setup scene at the beginning
func setup_room(room_info : Dictionary) -> void:
	var player = room_info["player"]
	var camera = room_info["camera"]
	var pause_menu = room_info["pause_menu"]
	var spawn_point = room_info["spawn_point"]
	var time_lbl = room_info["time_lbl"]
	var main_timer = room_info["main_timer"]
	var remaining_time = room_info["remaining_time"]
	var curr_music_player = room_info["music_player"]
	
	play_music(curr_music_player)
	
	_status["curr_scene"] = room_info["curr_scene"]
	_status["curr_room"] = _status["curr_scene"]
	_status["room_completed"] = false
	_status["room_failed"] = false
	
	# save game after updating the current room
	save_game()
	
	player.position = spawn_point
	camera.position = spawn_point
	pause_menu.set_position(spawn_point)
	time_lbl.set_position(Vector2(player.position.x, player.position.y - 50))
	time_lbl.text = str(remaining_time)
	PlayerState.set_state("temp_money", PlayerState.get_state("money"))
	PlayerState.set_temp_items(PlayerState.get_items())
	main_timer.start()
	

# check if the player was cured or died
func check_player_status(player, 
						main_timer : Timer, 
						read_timer : Timer, 
						time_lbl : Label, 
						remaining_time : int, 
						reading_time : int, 
						scene : String) -> void:	
	if _status["room_completed"]:
		if reading_time <= 0:
			change_room(player, scene)
	elif _status["room_failed"]:
		if reading_time <= 0:
			game_over(time_lbl)
	elif not player.is_poisoned:
		var money := round(remaining_time)
		
		_status["room_completed"] = true
		main_timer.stop()
		player.can_move = false
		time_lbl.text = "You got %s coins" % money
		
		# prevent player from getting infinite money
		if scene != "game_over_screen":
			PlayerState.add_money(money)
		read_timer.start()
	elif player.is_dead:
		_status["room_failed"] = true
		time_lbl.text = "You didn't make it..."
		read_timer.start()


# change scene after saving player's inventory
func change_room(player, room : String) -> void:
	# don't save inventory for game over so that player can't get infinite potions
	if room != "game_over_screen":
		PlayerState.set_items(player.inventory)	

	_status["prev_scene"] = _status["curr_scene"]
	_status["music_pos"] = music_player.get_playback_position()
	get_tree().change_scene(SCENE_PATHS[room])
	

# handle game over actions
func game_over(time_lbl : Label) -> void:
	_status["prev_scene"] = _status["curr_scene"]
	_status["music_pos"] = music_player.get_playback_position()
	get_tree().change_scene(SCENE_PATHS["game_over_screen"])


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
		get_tree().change_scene(SCENE_PATHS["main_menu"])


func handle_timeout(player, time_lbl : Label, timer : Timer, remaining_time : float) -> float:
	remaining_time = remaining_time - 1.0
	time_lbl.text = str(remaining_time)
	
	if remaining_time == 0.0:
		timer.stop()
		if player.is_poisoned:
			player.is_dead = true
			
	return remaining_time


func handle_potion_collision(body : Node, player, potion) -> void:
	if (body.get_name() == "Player"):
		match potion.type:
			PotionTypes.CURE:
				player.inventory["cure_potion"] += 1
			PotionTypes.POISON:
				player.inventory["poison_potion"] += 1
			PotionTypes.SPEED_DOWN:
				player.inventory["speed_down_potion"] += 1
			PotionTypes.SPEED_UP:
				player.inventory["speed_up_potion"] += 1
			PotionTypes.JUMP_BOOST:
				player.inventory["jump_boost_potion"] += 1
		
		PlayerState.set_temp_items(player.inventory)
		potion.queue_free()
