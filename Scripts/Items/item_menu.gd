extends Panel

@onready var item_scene     = preload("res://Scenes/menu/item_scene.tscn")
@onready var item_container = get_node("MarginContainer/ScrollContainer/VBoxContainer")

func _ready():
	SignalBus.connect("pause", _on_menu_open)
	SignalBus.connect("refresh_menu", _on_refresh_menu)
	display_items()

func _on_menu_open():
	update()

func _on_refresh_menu():
	update()

func update():
	clear_items()
	display_items()

func clear_items():
	for i in $MarginContainer/ScrollContainer/VBoxContainer.get_children():
		i.queue_free()

func display_items():
	if PlayerInventory.items:
		for item in PlayerInventory.items:
#			print("hi")
			var i = item_scene.instantiate()
			i.item = item
			i.menu = self
			i.get_node("MarginContainer/HBoxContainer/VBoxContainer/ItemName").text 		= item.item_name
			i.get_node("MarginContainer/HBoxContainer/VBoxContainer/ItemDescription").text  = item.item_description
			i.get_node("MarginContainer/HBoxContainer/VBoxContainer2/ItemType").text 		= str(item.CATEGORY.keys()[item.Category])
			
			$MarginContainer/ScrollContainer/VBoxContainer.add_child(i)
	else:
		print("no items")
