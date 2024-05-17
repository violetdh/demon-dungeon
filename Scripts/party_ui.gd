extends Panel

@onready var member_scene     = preload("res://Scenes/battle_party_member.tscn")
@onready var member_container = get_node("MarginContainer/ScrollContainer/VBoxContainer")

func _ready():
	SignalBus.connect("pause", _on_menu_open)
	SignalBus.connect("refresh_menu", _on_refresh_menu)
	display_members()

func _on_menu_open():
	update()
	
func _on_refresh_menu():
	update()
	
func update():
	clear_members()
	display_members()
	
func clear_members():
	for i in $MarginContainer/ScrollContainer/VBoxContainer.get_children():
		i.queue_free()

func display_members():
	if GameVariables.party_members:
		for p in GameVariables.party_members:
#			print("hi")
			var i = member_scene.instantiate()
			i.get_node("MarginContainer/VBoxContainer/Name").text 		= p.name
			#i.get_node("ItemType").text 		= item.Category.keys()
			i.get_node("MarginContainer/VBoxContainer/HBoxContainer/HP").value = p.current_health
			i.get_node("MarginContainer/VBoxContainer/HBoxContainer/HP").set_max(p.get_max_health())
			i.get_node("MarginContainer/VBoxContainer/HBoxContainer/HP").get_node("Label").text = str(p.current_health)
			i.get_node("MarginContainer/VBoxContainer/HBoxContainer/MP").value = p.current_mana
			i.get_node("MarginContainer/VBoxContainer/HBoxContainer/MP").set_max(p.get_max_mana())
			i.get_node("MarginContainer/VBoxContainer/HBoxContainer/MP").get_node("Label").text = str(p.current_mana)
			
			$MarginContainer/ScrollContainer/VBoxContainer.add_child(i)
	else:
		print("no items")
