extends Node

@onready var battle_scene = load("res://Scenes/battle_scene.tscn")
var battle

var enemies  = []

func _ready(): 
	randomize()
	get_enemies()
#	print("enemies: "+ str(enemies))

func get_enemies():
	var folder =  "res://Resources/Enemies/"
	var dir = DirAccess.get_files_at(folder)
	for e in dir:
#		print("filename: " + e)
		enemies.append(load(folder + e))
#		print("loaded enemy")

func generate_encounter(num, enemy_set):
	battle = battle_scene.instantiate()
	var battle_script = battle.get_node("BattleUI")
	
	var enemies_total
	var encounter: Array[Enemy] = []
	
	if(!num):	
		randomize()
		enemies_total = randi_range(1,3)
#		print("total enemies: " + str(enemies_total))
	else:
		enemies_total = num
	
	if(!enemy_set):
		for i in enemies_total:
			randomize()
			var enemy = enemies[randi_range(0, enemies.size() - 1)]
#			print("appending" + str(enemy) + " to encounter..")
			encounter.append(enemy)
	else:
		encounter.append([enemy_set])
#	print("encounter: " + str(encounter))
	
	battle_script.enemies = encounter
	
	get_tree().get_root().add_child(battle)
