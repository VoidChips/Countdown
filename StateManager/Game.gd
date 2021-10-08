extends Node

var _status := {
	"is_new_game": true,
	"current_room": "res://scenes/Room1.tscn",
}

var room_completed := false

enum PotionTypes {
	CURE,
	POISON,
	SPEED_UP,
	SPEED_DOWN,
	JUMP_BOOST,
}

const SAVE_DIR = "user://saves/"
const SAVE_PATH = SAVE_DIR + "save.dat"


func _ready():
	load_game()


# return all status information
func get_status() -> Dictionary:
	return _status
	

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
	file.close()


# setup scene at the beginning
func setup_room(room_info : Dictionary) -> void:
	var player = room_info["player"]
	var camera = room_info["camera"]
	var pause_menu = room_info["pause_menu"]
	var spawn_point = room_info["spawn_point"]
	var time_lbl = room_info["time_lbl"]
	var main_timer = room_info["main_timer"]
	var remaining_time = room_info["remaining_time"]
	
	save_game()
	room_completed = false
	
	player.position = spawn_point
	camera.position = spawn_point
	pause_menu.set_position(spawn_point)
	time_lbl.set_position(Vector2(player.position.x, player.position.y - 50))
	time_lbl.text = str(remaining_time)
	main_timer.start()
	

# check if the player was cured or died
func check_player_status(player, main_timer : Timer, read_timer : Timer, time_lbl : Label, remaining_time : int, reading_time : int, scene : String) -> void:	
	if room_completed:
		if reading_time <= 0:
			change_room(player, scene)
	elif not player.is_poisoned:
		var money := round(remaining_time)
		
		room_completed = true
		main_timer.stop()
		player.can_move = false
		time_lbl.text = "You got %s coins" % money
		PlayerState.add_money(money)
		read_timer.start()
	if player.is_dead:
		game_over(time_lbl)


# change scene after saving player's inventory
func change_room(player, scene : String) -> void:
	PlayerState.set_items(player.inventory)
	get_tree().change_scene(scene)
	

# handle game over actions
func game_over(time_lbl : Label) -> void:
	time_lbl.text = "You didn't make it..."
	
	# wait before changing scene
	yield(get_tree().create_timer(1.5), "timeout")
	get_tree().change_scene("res://scenes/GameOverScreen.tscn")


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


func handle_potion_collision(body : Node, player, potion) -> void:
	if (body.get_name() == "Player"):
		player.inventory["potions"].push_back(potion.type)
		potion.queue_free()
