extends MarginContainer

func _ready():
	GameVariables.world = GameVariables.world_scene.instantiate()

func _on_start_pressed():
	get_tree().get_root().add_child(GameVariables.world)
	self.queue_free()
