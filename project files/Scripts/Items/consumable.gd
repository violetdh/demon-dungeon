extends Item

class_name Consumable

@export var stat_affected	 : STAT
@export var strength		 : STRENGTH
@export var strength_values  = [20,30,60]
@export var behaviour_script : GDScript
@export var summon = false

var consumable = true
var behaviour 

enum STAT { Health, Mana, None}
enum STRENGTH { Lesser, Middling, Greater, None }

var value = 0

func use(caller):
	behaviour = behaviour_script.new()
	match strength:
		STRENGTH.Lesser:
			value = strength_values[0]
			behaviour.strength = 1
		STRENGTH.Middling:
			value = strength_values[1]
			behaviour.strength = 2
		STRENGTH.Greater:
			value = strength_values[2]
			behaviour.strength = 3
		STRENGTH.None:
			print("no strength value")
	match stat_affected:
		STAT.Health:
			caller.heal(value)
			print(caller.current_health)
		STAT.Mana:
			caller.current_mana += value
		STAT.None:
			if !summon:
				pass
			else:
				behaviour.use()
				pass

func get_item(): return self
func get_consumable(): return self
func get_key(): return null
func get_equipment(): return null
