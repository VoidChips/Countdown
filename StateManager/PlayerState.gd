extends Node

var _state := {
	"money" : 0,
	"inventory" : {
		"potions" : [],
	},
}


func get_money() -> int:
	return _state["money"]


func set_money(x : int) -> void:
	_state["money"] = x
	

# add to total amount of holding money
func add_money(x : int) -> void:
	_state["money"] += x


# get the copy of the inventory
func get_items() -> Dictionary:
	return _state["inventory"].duplicate(true)


# set inventory
func set_items(d : Dictionary) -> void:
	_state["inventory"] = d

