extends Panel

signal consume
var item : Resource
var menu

func _on_consume_pressed():
	PlayerInventory.consume(item, 0)
	GameVariables.party_members[0].get_current_health()
	queue_free()
	SignalBus.emit_signal("refresh_menu")
