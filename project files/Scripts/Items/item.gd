extends Resource

class_name Item

@export var item_name 		 = "new item"
@export var item_description : String
@export var long_description : String
@export var item_object 	 : PackedScene
@export var item_icon		 : ImageTexture
@export var Category		 : CATEGORY

enum CATEGORY { MISC, KEY, CONSUMABLE, EQUIPMENT }

func use(caller):
	print("Used: " + item_name)
	pass

func get_item(): return self
func get_consumable(): return null
func get_equipment(): return null
func get_key(): return null
