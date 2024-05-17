extends StaticBody3D

@export var number = "0"

signal on_interact(number)
"text"
func _ready():
	$SubViewport/Label.text = number
	
func set_number(value):
	number = value
	if value:
		$SubViewport/Label.text = str(value)

func interact():
	print(number)
	on_interact.emit(number)
	pass
