extends CanvasLayer

signal textbox_opened
signal textbox_closed
signal textbox_hidden
signal player_turn_end
signal target_selected
signal ally_turn_started
signal enemy_turn_started
signal selection_changed

@export var enemies:    Array[Enemy]    = []
@export var battle_scene: Node3D

@onready var enemy_scene = load("res://Scenes/battle_enemy.tscn")
@onready var party_member_scene = load("res://Scenes/battle_party_member.tscn")
@onready var skill_scene = load("res://Scenes/skill_scene.tscn")
@onready var run_scene = load("res://Scenes/run.tscn")
@onready var attack_scene = load("res://Scenes/attack.tscn")

var enemy_sprites = []
var party_panels = []
var messages = []

var player_current_health
var current_party_member_index = 0
var target
var target_index
var allytarget
var allies = GameVariables.party_members.duplicate()
var clickable = false
var textbox = false
var target_selection = false
var ended = false
var enemies_valid = true
var enemy_turn_count = 0
var selection = 0
var player_time = false

@onready var ui_container = $MarginContainer/HBoxContainer
@onready var actions_menu = $MarginContainer/HBoxContainer/ActionsPanel/MarginContainer/VBoxContainer/ScrollContainer/ActionContainer
@onready var party_menu = $MarginContainer/HBoxContainer/PartyPanel/MarginContainer/VBoxContainer/ScrollContainer/PartyContainer
@onready var skills_menu = $MarginContainer/HBoxContainer/SkillsPanel/MarginContainer/VBoxContainer/ScrollContainer/SkillContainer
@onready var skills_panel = $MarginContainer/HBoxContainer/SkillsPanel

var encounter_phrases = ["You are accosted by a group of dangerous creatures!!!", "Be on your guard, foes abound!", "They're gonna eat you!"]

#this script is very poorly structured and overly long but it does what i need it to do

func _ready():
	#remove player from allies array
	allies.remove_at(0)
	# fills the party panel with the current party members

	self.player_turn_end.connect(_on_player_turn_end)
	self.selection_changed.connect(_on_selection_changed)
	self.textbox_hidden.connect(_on_textbox_hidden)
	self.textbox_opened.connect(_on_textbox_opened)

	#populate party member window
	for p in GameVariables.party_members:
		var party_member = party_member_scene.instantiate()
		party_member.get_node("MarginContainer/VBoxContainer/Name").text = p.name
		party_member._name = p.name
		party_member.max_health = p.get_max_health()
		party_member.health = p.current_health
		party_member.max_mana = p.get_max_mana()
		party_member.party_member = p
		set_health(party_member.get_node("MarginContainer/VBoxContainer/HBoxContainer/HP"), p.get_max_health(), p.current_health)
		set_mana(party_member.get_node("MarginContainer/VBoxContainer/HBoxContainer/MP"), p.get_max_mana(), p.current_mana)
		
		party_panels.append(party_member)
		party_menu.add_child(party_member)

	# displays the enemies
	for e in enemies:
		var enemy = enemy_scene.instantiate()
		enemy.enemy = e
		enemy._name = e.name
		enemy.health = e.get_max_health()
		enemy.mana = e.get_max_mana()
		enemy_sprites.append(enemy)
		
		enemy.selected.connect(_on_enemy_selected)
		
		$EnemyContainer.add_child(enemy)
#	Textbox.hide()
#	skills_panel.hide()
	
	randomize()
	display_text(encounter_phrases[randi_range(0, encounter_phrases.size() - 1)])
	await self.textbox_closed
	player_turn()

func _on_enemy_selected(enemy):
	target = enemy
	emit_signal("target_selected")

func _process(delta):
	if(party_panels[0].health <= 0):
		GameVariables.game_end()
	if(target_selection):
#		enemy_sprites[0].grab_focus()
		if(enemy_sprites[selection]):
			if(is_instance_valid(enemy_sprites[selection])):
				enemy_sprites[selection].get_node("Label").show()
				if Input.is_action_just_pressed("ui_right"):
					if(selection < enemy_sprites.size() - 1):
						selection += 1
					else:
						selection = 0
					emit_signal("selection_changed")
				if Input.is_action_just_pressed("ui_left"):
					if(selection > 0):
						selection -= 1
					else:
						selection = enemy_sprites.size() -1
					emit_signal("selection_changed")
				if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
					target = enemy_sprites[selection]
					emit_signal("target_selected")

func _on_selection_changed():
	print("hi")
	print("selection changed to: " + str(selection) + enemy_sprites[selection]._name)
	for child in $EnemyContainer.get_children():
		child.get_node("Label").hide()

func display_actions():
	clear_menu(actions_menu)
	actions_menu.show()
	var attack = attack_scene.instantiate()
	var run = run_scene.instantiate()
	
	attack.button_up.connect(_on_attack_pressed)
	run.pressed.connect(_on_run_pressed)
	
	actions_menu.add_child(attack)
	actions_menu.add_child(run)

func _on_attack_pressed():
	display_skills(0)

	#displays the skills of the currently selected party member
func display_skills(party_member):
	clear_menu(skills_menu)
#	print("hi")
	skills_panel.show()
	for s in GameVariables.party_members[party_member].skills:
		var skill = skill_scene.instantiate()
		skill.skill = s
		skill.get_node("Name").text = s.name
		skill.get_node("Cost").text = s.get_cost()
		skill.skill_pressed.connect(_on_skill_pressed)
		skills_menu.add_child(skill)

	#displays text
func display_text(text):
	print("displaying: " + str(messages))
	if(messages.is_empty() and !textbox):
		messages.append(text)
		read_message()
	else:
		messages.append(text)

func read_message():
	emit_signal("textbox_opened")
#	print(messages)
	print("reading message")
	if(!messages.is_empty()):
		textbox = true
		print(messages)
		clickable = false
		$Textbox.show()
		var message = messages.pop_front()
		print("message: " + message)
		$Textbox/Text.text = message
		
		await get_tree().create_timer(0.5).timeout
		clickable = true

	#player turn
func player_turn():
	display_actions()

func _on_player_turn_end():
	enemy_check()
	print("player turn")
	ally_turn()
	
	#ally turn
func ally_turn():
	enemy_check()
	for a in allies:
		#pick a random target
		if(enemy_sprites.size() > 0):
			target_index = randi_range(0, enemy_sprites.size() -1)
			target = enemy_sprites[target_index]
			#pick a random skill + calculate the damage
			damage(a, null)
		enemy_check()
	print("ally turn end")
	enemy_turn()

	#enemy turn
func enemy_turn():
	enemy_check()
	await get_tree().create_timer(0.5).timeout
	print("enemy turn")
	var party_member_panels = party_menu.get_children()
	
	print("enemy count" + str(enemies.size())) 
	
	if enemies_valid:
		for e in enemies:
			if(!enemy_turn_count > 3):
				enemy_turn_count += 1
				print("enemy turn count: "+ str(enemy_turn_count))
				#pick a random target
				target_index = randi_range(0, GameVariables.party_members.size() -1)
				target = party_panels[target_index]
				#pick a random skill + calculate the damage
				var target_panel = party_member_panels[target_index]
				print("party member panels " + str(party_member_panels))
				damage(e, target_panel)
	print(enemy_sprites)
	player_turn()

func damage(combatant, panel):
	print("attack by " + combatant.name + " damage registered")
	if(is_instance_valid(target)):
		print(target._name + "'s current health: " + str(target.health))
		var skill_index = randi_range(0, combatant.skills.size() -1)
		var dmg = combatant.skills[skill_index].get_damage(combatant)
		#damage the target
		target.health = max(0, target.health - dmg)
		
		if(panel):
			print("enemy damaged"+ panel._name)
			set_health(panel.get_node("MarginContainer/VBoxContainer/HBoxContainer/HP"), panel.max_health, target.health)
		if(!target.dead):
			var message = str(combatant.name) + " used " + str(combatant.skills[skill_index].name) + " on " + target._name + " for " + str(dmg) + " damage!"
			print(message)
			display_text(message)
		kill_combatant()
		await self.textbox_closed

func kill_combatant():
	if(target.health <= 0 or target.dead):
		print("killing combatant...")
		
		if(!target.enemy):
			display_text("Your ally " + target._name + " has died!")
			await self.textbox_closed
			if(is_instance_valid(target)):
				if(target.party_member.player):
					GameVariables.game_end()
			allies.remove_at(allies.find(target))

			target.die()
		else:
			var a = enemy_sprites[enemy_sprites.find(target)]
			print("enemy " + a.enemy.name + " killed")
			if is_instance_valid(a):
				a.die()
				enemy_sprites.remove_at(enemy_sprites.find(a))
			enemies.remove_at(enemies.find(target))
			print(enemies)
			if(enemies == []):
				await get_tree().create_timer(0.5).timeout
				messages = []
				display_text("You won!")
				await self.textbox_hidden
				battle_end()
			if(enemy_sprites == []):
				await get_tree().create_timer(0.5).timeout
				messages = []
				display_text("You won!")
				await self.textbox_hidden
				battle_end()

func _input(event):
#	print("clickable: " + str(clickable))
	if (Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and $Textbox.visible and clickable):
		clickable = false
		if (messages.is_empty()):
			$Textbox.hide()
			emit_signal("textbox_hidden")
		textbox = false
		print("textbox closed")
		emit_signal("textbox_closed")
		if (!messages.is_empty()):
			read_message()

func set_health(progress_bar, max_health, health):
	progress_bar.value = health
	progress_bar.max_value = max_health
	progress_bar.get_node("Label").text = "HP:%d/%d" % [health, max_health]

func set_mana(progress_bar, max_mana, mana):
	progress_bar.value = mana
	progress_bar.max_value = max_mana
	progress_bar.get_node("Label").text = "MP:%d/%d" % [mana, max_mana]
 
func _on_run_pressed():
	display_text("Got away safely...")
	await self.textbox_closed
	battle_end()
	
func _on_skill_pressed(skill):
	skills_panel.hide()
	var current_party_member = GameVariables.party_members[current_party_member_index]
	if is_instance_valid(enemies[0]):
		print("hi2")
		target_selection = true

		await self.target_selected
		
		target_selection = false
		var dmg = skill.get_damage(current_party_member)
		var crit
		if target.enemy.weakness == str(skill.ELEMENT.keys()[skill.element]):
			dmg = ceil(dmg * 1.5) + 5
			crit = true

		var cost = skill.mp_cost
		target.health = max(0, target.health - dmg)
		
		print(target._name + "'s current health: " + str(target.health))
		
		kill_combatant()
		set_mana(party_panels[current_party_member_index].get_node("MarginContainer/VBoxContainer/HBoxContainer/MP"), current_party_member.get_max_mana(), current_party_member.current_mana - cost)
		if crit:
			display_text("WOW! That was effective! " + current_party_member.name + " critically hit " + target._name + " for " + str(dmg) + " damage!!!")
		else:
			display_text(current_party_member.name + " attacked " + target._name + " for " + str(dmg) + " damage!")
		await self.textbox_closed
		
		emit_signal("player_turn_end")

func battle_end():
	for p in party_panels:
		if is_instance_valid(p):
			GameVariables.party_members[party_panels.find(p)].current_health = p.health
			if p.mana:
				GameVariables.party_members[party_panels.find(p)].current_mana = p.mana
		
	print("battle end")
	get_tree().paused = false
	get_tree().get_root().add_child(GameVariables.world)
	battle_scene.queue_free()

func enemy_check():
	for i in enemy_sprites:
		if is_instance_valid(i):
			i.get_node("Label").visible = false
			enemies_valid = true
		else:
			enemies_valid = false
	
	var enemies_alive = 0
#	for e in enemies:
#		if(e.dead == true):
#			enemies_alive += 1
	if(ended == true):
		battle_end()
	if(enemies.size() <= 0 or enemies_valid == false):
		ended = true
		print("all enemies dead")
		await get_tree().create_timer(0.5).timeout
		messages = []
		display_text("You won!")
		await self.textbox_hidden
		battle_end()

# iterates through children of node and frees them. useful for resetting menus between turns
func clear_menu(a):
	print("clearing "+ a.name)
	for i in a.get_children():
		i.queue_free()

# these two functions use signals to show and hide the player's UI when the textbox opens and closes.
func _on_textbox_hidden():
	ui_container.show()
	if(player_time):
		player_time = false
		player_turn()

func _on_textbox_opened():
	ui_container.hide()
