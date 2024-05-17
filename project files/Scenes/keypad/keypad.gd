extends Node3D

@export var correct_password = "1234"

@export var door : Node3D

@onready var keys = $Keys
@onready var password_label = $SubViewport/PasswordLabel

var password = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in keys.get_children():
		if child is StaticBody3D:
			child.connect("on_interact", on_button_interact)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_button_interact(value):
	print("interacted with " + value)

	# enter key is pressed
	if value == ".":
		# check if the number is the correct number
		if password == correct_password:
			print("correct!")
			door.locked = !door.locked
			door.open()
			
		else:
			print("false!")
		password = ""

	# clear key is pressed
	elif value == "C":
		# clear the current number
		password = ""

	# digit key is pressed
	else:
		# got a number value
		if password.length() == correct_password.length():
			return
		password += value

	password_label.text = password
