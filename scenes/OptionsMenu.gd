extends Control

onready var resolution_btn := $Options/ResolutionOption/ResolutionBtn
onready var fullscreen_checkbox := $Options/FullscreenOption/FullscreenCheckBox
onready var confirm_btn := $Options/ConfirmBtn
onready var options := $Options
onready var settings := Config.get_settings()
onready var resolution = settings["screen"]["window_size"]
onready var is_fullscreen = settings["screen"]["is_fullscreen"]


func _ready():
	options.alignment = BoxContainer.ALIGN_CENTER
	
	resolution_btn.add_item("640x360")
	resolution_btn.add_item("1280x720")
	resolution_btn.add_item("1920x1080")
	resolution_btn.add_item("2560x1440")
	resolution_btn.add_item("3840x2160")
	
	if is_fullscreen:
		disable_all_resolutions()
		resolution_btn.text = ""
	else:
		disable_invalid_resolutions()
		
	select_current_resolution()
	confirm_btn.disabled = true
	
	print("resolution: " + str(resolution))
	print("fullscreen: " + str(is_fullscreen))


# get the resolution from text
func get_resolution(var s : String) -> Array:
	var res : Array
	var delimiter_pos : int
	var left : int
	var right : int
		
	delimiter_pos = s.find("x")
	left = int(s.left(delimiter_pos))
	right = int(s.right(delimiter_pos))
	
	res.append(left)
	res.append(right)
		
	print(str(res[0]) + " " + str(res[1]))
	
	return res
	

# disable resolutions if they are less than the display resolution
func disable_invalid_resolutions():
	var screen_size := OS.get_screen_size()
	
	for i in resolution_btn.get_item_count():
		var res_text = resolution_btn.get_item_text(i)
		var res := get_resolution(res_text)
		
		if screen_size[0] < res[0] and screen_size[1] < res[1]:
			resolution_btn.set_item_disabled(i, false)


# enable resolutions if they are valid
func enable_valid_resolutions():
	var screen_size := OS.get_screen_size()
	
	for i in resolution_btn.get_item_count():
		var res_text = resolution_btn.get_item_text(i)
		var res := get_resolution(res_text)
		
		if screen_size[0] >= res[0] and screen_size[1] >= res[1]:
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
	match index:
		0:
			resolution = Vector2(640, 360)
		1:
			resolution = Vector2(1280, 720)
		2:
			resolution = Vector2(1920, 1080)
		3:
			resolution = Vector2(2560, 1440)
		4:
			resolution = Vector2(3840, 2160)
	
	confirm_btn.disabled = false
	print("resolution: " + str(resolution))


# toggle fullscreen
func _on_FullscreenCheckBox_toggled(button_pressed):
	is_fullscreen = !is_fullscreen
	confirm_btn.disabled = false
	print("fullscreen: " + str(is_fullscreen))
	
	if is_fullscreen:
		disable_all_resolutions()
	else:
		enable_valid_resolutions()


# apply changes
func _on_ConfirmBtn_pressed():
	select_current_resolution()
	OS.window_fullscreen = is_fullscreen
	OS.window_size = resolution
	
	settings["screen"]["window_size"] = resolution
	settings["screen"]["is_fullscreen"] = is_fullscreen
	Config.set_settings(settings)
	Config.save_settings()
	
	confirm_btn.disabled = true


# return to main menu
func _on_BackBtn_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")
