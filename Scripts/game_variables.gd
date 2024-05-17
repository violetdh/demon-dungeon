extends Node

var peaceful = false

var player
@onready var player_resource = load("res://Resources/Party Members/Player.tres")

var world
@onready var world_scene = load("res://Scenes/world/world.tscn")

var inventory

@onready var party_members : Array[Resource] = [player_resource]

var paused = false
var turn_play = false
var mouse_look = false

func game_end():
	print("game end")
	get_tree().quit()
