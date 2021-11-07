extends Control


func _ready():
	Game.set_status("curr_scene", "game_over_screen")
	Game.play_music($MusicPlayer)
	$Menu/HBoxContainer/Buttons/RetryBtn.grab_focus()


func _on_RetryBtn_pressed():
	Game.set_status("music_pos", $MusicPlayer.get_playback_position())
	Game.set_status("prev_scene", "game_over_screen")
	get_tree().change_scene(Game.getCurrRoomPath())


func _on_MainMenuBtn_pressed():
	Game.set_status("prev_scene", "game_over_screen")
	get_tree().change_scene("res://scenes/MainMenu.tscn")
