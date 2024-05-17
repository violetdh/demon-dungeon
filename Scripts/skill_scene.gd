extends Button

signal skill_pressed

var skill

func _on_pressed():
	emit_signal("skill_pressed", skill)
