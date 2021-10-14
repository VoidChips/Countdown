extends Node

var _state := {
	"money" : 0,
	"temp_money" : 0,
	"inventory" : {
		"potions" : [],
	},
	"temp_inventory" : {
		"potions" : [],
	},
	"hit" : -1,  # indicates type of projectile the player got hit with
}


func get_states() -> Dictionary:
	return _state.duplicate(true)


func get_state(key : String):
	return _state[key]


func set_states(d : Dictionary) -> void:
	_state = d


func set_state(key : String, val) -> void:
	_state[key] = val


# add to total amount of holding money
func add_money(x : int) -> void:
	_state["money"] += x
	
	
func add_temp_money(x : int) -> void:
	_state["temp_money"] += x


# get the copy of the inventory
func get_items() -> Dictionary:
	return _state["inventory"].duplicate(true)


# set inventory
func set_items(d : Dictionary) -> void:
	_state["inventory"] = d


func get_temp_items() -> Dictionary:
	return _state["temp_inventory"].duplicate(true)


func set_temp_items(d : Dictionary) -> void:
	_state["temp_inventory"] = d


# reset player state
func reset(b : bool) -> void:
	if b:
		_state["money"] = 0
		_state["temp_money"] = 0
		_state["inventory"]["potions"] = []
		_state["temp_inventory"]["potions"] = []
	_state["hit"] = -1
