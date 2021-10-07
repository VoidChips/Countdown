extends Node

var _inventory := {
	"potions" : [],
}


# get the copy of the inventory
func get_items() -> Dictionary:
	return _inventory.duplicate(true)


# set inventory
func set_items(d : Dictionary) -> void:
	_inventory = d

