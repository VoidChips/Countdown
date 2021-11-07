extends Control

onready var resolution_lbl := $Options/ResolutionOption/ResolutionLbl
onready var resolution_btn := $Options/ResolutionOption/ResolutionBtn
onready var fullscreen_checkbox := $Options/FullscreenOption/FullscreenCheckBox
onready var confirm_btn := $Options/ConfirmBtn
onready var options := $Options
onready var settings := Config.get_settings()
onready var resolution = settings["screen"]["window_size"]
onready var is_fullscreen = settings["screen"]["is_fullscreen"]


func _ready():
	Game.set_status("curr_scene", "options_menu")
	Game.play_music($MusicPlayer)
	options.alignment = BoxContainer.ALIGN_CENTER
	
	resolution_btn.add_item("640x360")
	resolution_btn.add_item("1280x720")
	resolution_btn.add_item("1920x1080")
	resolution_btn.add_item("2560x1440")
	resolution_btn.add_item("3840x2160")
	
	if is_fullscreen:
		disable_all_resolutions()
		resolution_btn.text = ""
		fullscreen_checkbox.pressed = true
	else:
		disable_invalid_resolutions()
		fullscreen_checkbox.pressed = false
		
	select_current_resolution()
	confirm_btn.disabled = true


# get the resolution from text
func get_resolution(var s : String) -> Vector2:
	var res : Vector2
	var delimiter_pos : int
	var left : int
	var right : int
		
	delimiter_pos = s.find("x")
	left = int(s.left(delimiter_pos))
	right = int(s.right(delimiter_pos))
	
	res.x = left
	res.y = right
	
	return res
	

# disable resolutions if they are less than the display resolution
func disable_invalid_resolutions():
	var screen_size := OS.get_screen_size()
	
	for i in resolution_btn.get_item_count():
		var res_text = resolution_btn.get_item_text(i)
		var res := get_resolution(res_text)
		
		if screen_size[0] < res[0] and screen_size[1] < res[1]:
			resolution_btn.set_item_disabled(i, true)


# enable resolutions if they are valid
func enable_valid_resolutions():
	var screen_size := OS.get_screen_size()
	
	for i in resolution_btn.get_item_count():
		var res_text = resolution_btn.get_item_text(i)
		var res := get_resolution(res_text)
		
		if screen_size.x >= res.x and screen_size.y >= res.y:
			resolution_btn.set_item_disabled(i, false)


# disable all resolutions in the list
func disable_all_resolutions():
	for i in resolution_btn.get_item_count():
		resolution_btn.set_item_disabled(i, true)
	
	
# select current resolution of the game	
func select_current_resolution():
	match resolution:
		Vector2(640, 360):
			resolution_btn.select(0)
		Vector2(1280, 720):
			resolution_btn.select(1)
		Vector2(1920, 1080):
			resolution_btn.select(2)
		Vector2(2560, 1440):
			resolution_btn.select(3)
		Vector2(3840, 2160):
			resolution_btn.select(4)


# change the resolution
func _on_ResolutionBtn_item_selected(index):
	var is_base_res := false
	
	match index:
		0:
			resolution = Vector2(640, 360)
			is_base_res = true
		1:
			resolution = Vector2(1280, 720)
		2:
			resolution = Vector2(1920, 1080)
		3:
			resolution = Vector2(2560, 1440)
		4:
			resolution = Vector2(3840, 2160)
	
	confirm_btn.disabled = false


# toggle fullscreen
func _on_FullscreenCheckBox_toggled(button_pressed):
	is_fullscreen = button_pressed
	confirm_btn.disabled = false
	
	if is_fullscreen:
		resolution_lbl.set("custom_colors/font_color", Color("A0A0A0"))
		resolution_btn.set("custom_colors/font_color", Color("A0A0A0"))
		disable_all_resolutions()
	else:
		resolution_lbl.set("custom_colors/font_color", Color("ffffff"))
		resolution_btn.set("custom_colors/font_color", Color("ffffff"))
		enable_valid_resolutions()


# apply changes
func _on_ConfirmBtn_pressed():
	select_current_resolution()
	OS.window_fullscreen = is_fullscreen
	OS.window_size = resolution
	
	Config.set_setting("screen", "window_size", resolution)
	Config.set_setting("screen", "is_fullscreen", is_fullscreen)
	Config.save_settings()
	
	confirm_btn.disabled = true


# return to main menu
func _on_BackBtn_pressed():
	Game.set_status("prev_scene", "options_menu")
	Game.set_status("music_pos", $MusicPlayer.get_playback_position())
	get_tree().change_scene("res://scenes/MainMenu.tscn")

