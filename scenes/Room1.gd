extends Node2D

onready var player := $Player
onready var camera := $Camera2D
onready var pause_menu := $PauseMenu
onready var main_timer := $MainTimer
onready var read_timer := $ReadTimer
onready var time_lbl := $TimeLbl
onready var music_player := $MusicPlayer
onready var gui := $GUI

var remaining_time := 10.0
var reading_time := 1
var room_info := {}

const spawn_point = Vector2(222, 177)


func _ready():
	var room_info = {
		"player": player,
		"camera": camera,
		"pause_menu": pause_menu,
		"spawn_point": spawn_point,
		"main_timer": main_timer,
		"time_lbl": time_lbl,
		"remaining_time": remaining_time,
		"music_player": music_player,
		"curr_scene": "room1",
	}

	Game.set_status("is_new_game", false)
	Game.setup_room(room_info)

	
func _process(delta):
	# make camera follow player horizontally
	camera.position.x = player.position.x
	pause_menu.set_position(player.position)
	time_lbl.set_position(Vector2(player.position.x, player.position.y - 50))
		
	Game.pause_input_check(pause_menu)
	Game.check_player_status(player, main_timer, read_timer, time_lbl, remaining_time, reading_time, "room2")


# define pause menu actions
func _on_PauseMenu_id_pressed(id):
	Game.handle_pause_menu_selection(id, pause_menu)


func _on_MainTimer_timeout():
	remaining_time = Game.handle_timeout(player, time_lbl, main_timer, remaining_time)


func _on_ReadTimer_timeout():
	reading_time -= 1.0


# respawn player if it fell off map
func _on_RespawnTrigger_body_entered(body):
	if (body.get_name() == "Player"):
		Game.respawn(player, spawn_point)


func _on_CurePotion_body_entered(body):
	Game.handle_potion_collision(body, player, get_node("CurePotion"))

