extends Resource

class_name PartyMember

var enemy = false

var dead = false

@export var name : String = "Party Member"
@export var level : int = 1
@export var strength : int = 5
@export var technique : int = 5
@export var magic : int = 5
@export var agility : int = 5
@export var vitality : int = 5
@export var luck : int = 5
@export var current_health : int = 1000
@export var current_mana : int = 1000
@export var player : bool = false

@export var skills : Array[Resource] = []


func get_current_health():
	print(current_health) 

func get_max_health():
	var max_health = vitality * 6 + level * 3
	if current_health > max_health:
		current_health = max_health
	return max_health
	
func get_max_mana():
	var max_mana = magic * 6 + level * 4
	if current_mana > max_mana:
		current_mana = max_mana
	return max_mana

func heal(hp):
	current_health += hp 
	get_max_health()

func restore(mana):
	current_mana += mana
	get_max_mana()

func die():
	dead = true
