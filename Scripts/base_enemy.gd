extends Resource

class_name Enemy

var enemy = true
var dead = false

@export var name : String = "Enemy"
@export var texture : Texture = null

@export var textures : Array[Texture] = []

@export var weakness : String

@export var level : int = 1
@export var strength : int = 5
@export var technique : int = 5
@export var magic : int = 5
@export var agility : int = 5
@export var vitality : int = 5
@export var luck : int = 5
@export var current_health : int = 100000
@export var current_mana : int = 100000

@export var skills : Array[Resource] = []

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

func die():
	var dead = true
