extends Behaviour

var element

var skills = []

# clear player skills array except for the default attack
# add random elemental skill

func get_skills():
	var folder =  "res://Resources/Skills/"
	var dir = DirAccess.get_files_at(folder)
	for s in dir:
		if !s == "Attack.tres" and !s == "Earthquake.tres":
			skills.append(load(folder + s))

func use():
	randomize()
	get_skills()
	var skill = skills[randi_range(0, skills.size() -1)]
	print(skill.name)
	if GameVariables.player_resource.skills.size() > 1:
		GameVariables.player_resource.skills.remove_at(1)
	GameVariables.player_resource.skills.append(skill)
