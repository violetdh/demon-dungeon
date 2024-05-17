extends Panel

var party_member
var enemy

var _name

var health = 0
var max_health = 0
var max_mana = 0
var mana = 0

var dead

func die():
	dead = true
	if party_member.player:
		GameVariables.game_end()
	queue_free()
