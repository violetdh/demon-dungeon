extends Resource

class_name Skill

enum ELEMENT {MELEE, ICE, FIRE, ROCK, WIND, ALMIGHTY}

@export var name : String = "Attack"
@export var cost_type : String = "MP"
@export var mp_cost : int = 0
@export var hp_cost : float = 0
@export var element : ELEMENT
@export var power : int = 15
@export var accuracy_mod : float = 1.0
@export var target_all : bool = false
@export var status_effect : Resource = null 

func get_damage(character):
	match ELEMENT:
		ELEMENT.MELEE:
			return (character.level + character.strength) * power / 15
		_:
			return (character.level + character.magic) * power / 10

func get_cost():
	match cost_type:
		"MP":
			return(str(mp_cost) + " MP")
		"HP":
			return(str(hp_cost) + " HP")
		"":
			return("")
