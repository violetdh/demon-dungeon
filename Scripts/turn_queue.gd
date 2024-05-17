extends Node

class_name TurnQueue

var active_character

func initialise():
	var combatants = get_combatants()
	combatants.sort_custom(self, 'sort_combatants')
	for combatant in combatants:
		combatant.raise()
	active_character = get_child(0)

func sort_combatants(a, b):
	return a.stats.agility > b.stats.agility

func play_turn():
	await active_character.play_turn().completed
	var new_index : int = (active_character.get_index() + 1) % get_child_count()
	active_character = get_child(new_index)

func get_combatants():
	pass
