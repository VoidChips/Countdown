extends Node

const SAVE_PATH = "res://config.cfg"

var _settings := {
	"screen": {
		"window_size" : Vector2(1280, 720),
		"is_fullscreen" : false,
	},
}


func _ready():
	load_settings()
	save_settings()


# get all settings
func get_settings() -> Dictionary:
	return _settings


# set all settings
func set_settings(d : Dictionary) -> void:
	_settings = d
	

# set a setting
func set_setting(section : String, key : String, value) -> void:
	_settings[section][key] = value


# load settings from the config file
func load_settings() -> void:
	var file = ConfigFile.new()
	var error = file.load(SAVE_PATH)
	
	if error != OK:
		print("Unable to open config.cfg. Error code: %s" % error)
		return
	
	for section in _settings.keys():
		for key in _settings[section]:
			# use the existing dictionary for the default value
			_settings[section][key] = file.get_value(section, key, _settings[section][key])


# save settings into the config file
func save_settings() -> void:
	var file = ConfigFile.new()
	
	for section in _settings.keys():
		for key in _settings[section]:
			file.set_value(section, key, _settings[section][key])
			
	file.save(SAVE_PATH)

