extends Node3D

func roll(minimum, maximum):
	return randi() % (maximum-minimum+1) + minimum

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

func encounter_check():
	if !GameVariables.peaceful:
		if roll(1, 1) == 1:
			EncounterBuilder.generate_encounter(null, null)
			get_tree().get_root().remove_child(self)

func _on_player_moved():
	encounter_check()
