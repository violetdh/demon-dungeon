extends Node

@export var items : Array[Resource]

func _ready():
	GameVariables.inventory = self

func add(item):
	items.append(item)
	for i in items:
		print(item.item_name)

func remove(item):
	items.pop_at(items.find(item))

func consume(item, member):
	if item.get_consumable().consumable == true:
		item.get_consumable().use(GameVariables.party_members[member])
		remove(item)
	else:
		print("you cant consume that!")

func equip():
	pass

func unequip():
	pass
