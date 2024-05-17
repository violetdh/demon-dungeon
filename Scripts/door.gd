extends Node3D

@export var locked = false

var is_open = false

@onready var top = $top
@onready var door = $door
@onready var doorcol = $doorcol

func open():
	if locked:
		pass
	else:
		if is_open:
			print("closing...")
			var tween = create_tween()
			tween.set_parallel(true)
			tween.tween_property(door, "position", Vector3.ZERO, 1)
			tween.tween_property(doorcol, "position", Vector3.ZERO, 1)
			pass
		else:
			print("opening...")
			$AudioStreamPlayer.play()
			var tween = create_tween()
			tween.set_parallel(true)
			tween.tween_property(door, "position", Vector3(0,4,0), 1)
			tween.tween_property(doorcol, "position", Vector3(0,4,0), 1)
		is_open = !is_open

func interact():
	open()
