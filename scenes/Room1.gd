extends Node2D

onready var player := $Player
onready var camera := $Camera2D
onready var pause_menu := $PauseMenu
onready var timer := $Timer
onready var time_lbl := $TimeLbl
onready var cure_potion := $CurePotion
onready var respawn_area := $RespawnArea

var remaining_time := 10.0

const spawn_point = Vector2(222, 177)


func _ready():
	var nodes = {
		"player": player,
		"camera": camera,
		"pause_menu": pause_menu,
		"spawn_point": spawn_point,
		"time_lbl": time_lbl,
		"timer": timer,
		"remaining_time": remaining_time,
	}
	
	Game.setup_scene(nodes)
	print(remaining_time)
	
	
func _process(delta):
	# make camera follow player horizontally
	camera.position.x = player.position.x
	pause_menu.set_position(player.position)
	time_lbl.set_position(Vector2(player.position.x, player.position.y - 50))
		
	Game.pause_input_check(pause_menu)
	Game.check_player_status(player, timer, time_lbl)


# define pause menu actions
func _on_PauseMenu_id_pressed(id):
	Game.handle_pause_menu_selection(id, pause_menu)


func _on_Timer_timeout():
	remaining_time = Game.handle_timeout(player, time_lbl, timer, remaining_time)


func _on_CurePotion_body_entered(body):
	Game.handle_potion_collision(body, player, cure_potion, "Cure Potion")


# respawn player if it fell off map
func _on_RespawnArea_body_entered(body):
	if (body.get_name() == "Player"):
		Game.respawn(player, spawn_point)
