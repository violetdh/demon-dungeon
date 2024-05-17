extends Control

var party_member
var enemy

var _name

var health = 0
var mana = 0



var dead

var i = 0
var x = 0
var flip = false
var animation_stagger = 0

signal selected

func _ready():
	self.texture = enemy.textures[i]
	$Label.text = enemy.name
	randomize()
	animation_stagger = (randi_range(1, 5) * 10)
	if(animation_stagger % 2 == 0):
		flip = true 

func _process(delta):
	x += 1
	if(enemy.current_health <= 0):
		die()
	if(x % (100 + animation_stagger) == 0):
		if !flip:
			i += 1
			print(enemy.name)
			self.texture = enemy.textures[i]
			if(i >= enemy.textures.size() - 1):
				i = 0
		else:
			if(i == 0):
				i = enemy.textures.size()
			i -= 1
			self.texture = enemy.textures[i]

func die():
	dead = true
	queue_free()

func _on_focus_entered():
	$Label.show()
	print("focus  entered")

func _on_focus_exited():
	$Label.hide()

func _on_gui_input(event):
	if event.is_action_pressed("select"):
		emit_signal("selected", self)
