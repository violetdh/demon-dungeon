extends Node

func _ready():
	SignalBus.connect("pause", _on_player_paused)
	SignalBus.connect("unpause", _on_player_unpaused)

func _on_player_paused():
#	get_tree().paused = true
	
	print(get_tree().paused)
	$MarginContainer/HUD.hide()
	$MarginContainer/PauseMenu.show()

func _on_player_unpaused():
	print(get_tree().paused)
#	get_tree().paused = false
	$MarginContainer/HUD.show()
	$MarginContainer/PauseMenu.hide()

func _on_resume_pressed():
	print(get_tree().paused)
	get_tree().paused = false
	$MarginContainer/PauseMenu.hide()
	$MarginContainer/HUD.show()
