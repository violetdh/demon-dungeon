extends Node

func _ready():
	SignalBus.connect("dialog_closed", _on_dialog_closed)
	SignalBus.connect("display_dialog", _on_dialog_opened)
	pass

func _process(delta):
	health()
	mana()
	
func health():
	$VBoxContainer/HealthBar.value = GameVariables.party_members[0].current_health
	$VBoxContainer/HealthBar.max_value = GameVariables.party_members[0].get_max_health()
	$VBoxContainer/HealthBar/HealthValue.text = str(GameVariables.party_members[0].current_health) + " / " + str(GameVariables.party_members[0].get_max_health())
	
func mana():
	$VBoxContainer/ManaBar.value = GameVariables.party_members[0].current_mana
	$VBoxContainer/ManaBar.max_value = GameVariables.party_members[0].get_max_mana()
	$VBoxContainer/ManaBar/ManaValue.text = str(GameVariables.party_members[0].current_mana) + " / " + str(GameVariables.party_members[0].get_max_mana())

func _on_dialog_closed():
	$VBoxContainer.show()
func _on_dialog_opened(text_key):
	$VBoxContainer.hide()
