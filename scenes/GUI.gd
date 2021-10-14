extends CanvasLayer

onready var cure_potion = $HBoxContainer/Potions/CurePotion
onready var poison_potion = $HBoxContainer/Potions/PoisonPotion
onready var speed_down_potion = $HBoxContainer/Potions/SpeedDownPotion
onready var speed_up_potion = $HBoxContainer/Potions/SpeedUpPotion
onready var jump_boost_potion = $HBoxContainer/Potions/JumpBoostPotion
onready var coins = $HBoxContainer/Coins


func _process(delta):
	var potions = PlayerState.get_temp_items()["potions"]
	var types = Game.PotionTypes
	var cure_count = count_potions(types.CURE, potions)	
	var poison_count = count_potions(types.POISON, potions)
	var speed_down_count = count_potions(types.SPEED_DOWN, potions)
	var speed_up_count = count_potions(types.SPEED_UP, potions)
	var jump_boost_count = count_potions(types.JUMP_BOOST, potions)
	var coin_count = PlayerState.get_state("temp_money")
	
	# update the number of potions and money in the gui
	cure_potion.get_node("Background/Count").text = str(cure_count)
	poison_potion.get_node("Background/Count").text = str(poison_count)
	speed_down_potion.get_node("Background/Count").text = str(speed_down_count)
	speed_up_potion.get_node("Background/Count").text = str(speed_up_count)
	jump_boost_potion.get_node("Background/Count").text = str(jump_boost_count)
	coins.get_node("Count").text = str(coin_count)


# count the number of a potion type in list of potions
func count_potions(type : int, potions : Array) -> int:
	var count := 0
	
	for potion in potions:
		if potion == type:
			count += 1
			
	return count
