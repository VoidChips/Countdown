extends CanvasLayer

onready var cure_potion = $HBoxContainer/Potions/CurePotion
onready var poison_potion = $HBoxContainer/Potions/PoisonPotion
onready var speed_down_potion = $HBoxContainer/Potions/SpeedDownPotion
onready var speed_up_potion = $HBoxContainer/Potions/SpeedUpPotion
onready var jump_boost_potion = $HBoxContainer/Potions/JumpBoostPotion
onready var coins = $HBoxContainer/Coins
onready var unselected_potion_texture := preload("res://assets/menu/GUI/potion_background1.png")
onready var selected_potion_texture := preload("res://assets/menu/GUI/potion_background2.png")


func _process(delta):
#	var potions = PlayerState.get_temp_items()["potions"]
	var inventory = PlayerState.get_temp_items()
	var types = Game.PotionTypes
	
	var cure_count = inventory["cure_potion"]
	var poison_count = inventory["poison_potion"]
	var speed_down_count = inventory["speed_down_potion"]
	var speed_up_count = inventory["speed_up_potion"]
	var jump_boost_count = inventory["jump_boost_potion"]
	var coin_count = PlayerState.get_state("temp_money")
	
	# update the number of potions and money in the gui
	cure_potion.get_node("Background/Count").text = str(cure_count)
	poison_potion.get_node("Background/Count").text = str(poison_count)
	speed_down_potion.get_node("Background/Count").text = str(speed_down_count)
	speed_up_potion.get_node("Background/Count").text = str(speed_up_count)
	jump_boost_potion.get_node("Background/Count").text = str(jump_boost_count)
	coins.get_node("Count").text = str(coin_count)
	
	# update the background texture of potions
	unselect_potions()
	match Game.get_status()["selected_potion"]:
		types.CURE:
			cure_potion.get_node("Background").texture = selected_potion_texture
		types.POISON:
			poison_potion.get_node("Background").texture = selected_potion_texture
		types.SPEED_DOWN:
			speed_down_potion.get_node("Background").texture = selected_potion_texture
		types.SPEED_UP:
			speed_up_potion.get_node("Background").texture = selected_potion_texture
		types.JUMP_BOOST:
			jump_boost_potion.get_node("Background").texture = selected_potion_texture


# count the number of a potion type in list of potions
func count_potions(type : int, potions : Array) -> int:
	var count := 0
	
	for potion in potions:
		if potion == type:
			count += 1
			
	return count


# unselect all potions
func unselect_potions() -> void:
	cure_potion.get_node("Background").texture = unselected_potion_texture
	poison_potion.get_node("Background").texture = unselected_potion_texture
	speed_down_potion.get_node("Background").texture = unselected_potion_texture
	speed_up_potion.get_node("Background").texture = unselected_potion_texture
	jump_boost_potion.get_node("Background").texture = unselected_potion_texture
