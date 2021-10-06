extends Node

var _inventory := {
	"cure potion": 0,
}


# get all items
func get_items() -> Dictionary:
	return _inventory


# set all items
func set_items(d : Dictionary) -> void:
	_inventory = d

