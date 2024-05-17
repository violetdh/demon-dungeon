extends Node3D

@export var item_name : String
@export var item : Item

func interact():
	print("interacted!")
	SignalBus.emit_signal("display_dialog", item_name)
	PlayerInventory.add(item)
	queue_free()
