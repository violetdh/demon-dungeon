extends Node

class_name PartyBuilder

const MemberStats = preload("res://Scripts/party_member.gd")

var names = ["Flame Djinn", "Yuki-Onna", "Sessho-seki", "Wind Tamer"]

var skills = []

func _init():
	#load all skills from directory before build() is called on PartyBuilder object
	var path = "res://Resources/Skills"
	var dir = DirAccess.open(path)
	dir.list_dir_begin()
	while true:
		var filename = dir.get_next()
		if filename == "":
			break
		elif !filename.begins_with(".") and !filename.ends_with(".import"):
			skills.append(load(path + "/" + filename))
	print(skills)

func build(level):
	randomize()
	var member = MemberStats.new()
	var name = names[randi_range(0,2)]
	member.name = name
	member.strength = 5 +  (3 * level)
	member.magic = 5 + (4 * level)
	member.agility = 5 * (level)
	member.luck = 5 + (2 * level)
	member.current_health = member.get_max_health()
	member.current_mana = member.get_max_mana()
	match name:
		"Flame Djinn":
#			print("Fire Guy")
			member.skills.append(skills[2])
		"Yuki-Onna":
			member.skills.append(skills[3])
#			print("Ice Guy")
		"Sessho-seki":
			member.skills.append(skills[1])
#			print("Rock Guy")
		"Wind Tamer":
			member.skills.append(skills[4])
#			print("Wind Guy")
	
	GameVariables.party_members.append(member)
