extends Node

const SAVE_PATH = "res://config.cfg"

var _config_file = ConfigFile.new()
var _settings = {
	"screen": {
		"window_size" : Vector2(1280, 720),
		"is_fullscreen" : false,
	},
}


func _ready():
	load_settings()
	save_settings()


func get_settings() -> Dictionary:
	return _settings


func set_settings(d : Dictionary) -> void:
	_settings = d


# load settings from the config file
func load_settings() -> void:
	var err = _config_file.load(SAVE_PATH)
	if err != OK:
		print("Unable to open config.cfg. Error code: %s" % err)
		return
	
	for section in _settings.keys():
		for key in _settings[section]:
			# use the existing dictionary for the default value
			_settings[section][key] = _config_file.get_value(section, key, _settings[section][key])


# save settings into the config file
func save_settings() -> void:
	for section in _settings.keys():
		for key in _settings[section]:
			_config_file.set_value(section, key, _settings[section][key])
			
	_config_file.save(SAVE_PATH)

