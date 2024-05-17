extends CharacterBody3D

@export var tile_size = 2
@export var rotate_speed = 2
@export var gridmap : GridMap
var mouse = Vector2(0,0)

var exit

#mouseover
var result
var last_result
var last_target
var target
var target_position

#movement, control
var last_rotation
var moving = false
var grid_pos = Vector2i(0,0)
var base_speed = 2
var sprint_mult = 1.5
const JUMP_VELOCITY = 4.5
var speed = base_speed
@export var front_blocked = false
@export var back_blocked = false

var camera_rotation = Vector2(0,0)
var mouse_sensitivity = 0.001
var interactee
var interact_range = 7

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var pivot = $Pivot
@onready var camera = $Pivot/PlayerCamera
@onready var front_collision = $Pivot/FrontCollision
@onready var back_collision = $Pivot/BackCollision

signal moved

func _ready():
	GameVariables.player = self
	exit = get_tree().get_first_node_in_group("exit")
	
func world_to_grid(pos):
	var v = pos / tile_size
	return Vector3(floor(v.x), floor(v.y), floor(v.z))

func grid_to_world(pos):
	var v = pos * tile_size
	# This second calculation is to center the position on the tile
	return v + Vector3i(tile_size/2.0,tile_size/2.0,tile_size/2.0) 

func _input(event):
	if event.is_action_pressed("menu"):
		if GameVariables.paused:
			GameVariables.paused = false
			SignalBus.emit_signal("unpause")
		else:
			GameVariables.paused = true
			SignalBus.emit_signal("pause")
	if !moving && !GameVariables.turn_play:
		if event.is_action_pressed("ui_up") and !front_blocked:
			move(-1)
		if event.is_action_pressed("ui_down") and !back_blocked:
			move(1)
		if event.is_action_pressed("ui_right"):
			turn(-1)
		if event.is_action_pressed("ui_left"):
			turn(1)

	if event is InputEventMouse:
		mouse = event.position
		if event is InputEventMouseButton and event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				if target:
					if target.global_position.distance_to(global_position) <= interact_range:
						if target.is_in_group("interactable"):
							target.interact()

func move(mult):
	moving = true
	var facing = transform.basis.z * speed
	
	var tween = create_tween()
	tween.tween_property(self, "velocity", (facing * mult) / .5, 1).set_ease(Tween.EASE_IN_OUT)
	GameVariables.turn_play = true

	tween.tween_callback(on_move_end)
	emit_signal("moved")

func turn(mult):
	moving = true
	var move_rotation = self.rotation.y + (PI/2 * mult)

	var tween = create_tween()
	tween.tween_property(self, "rotation", Vector3(0, move_rotation, 0), 1)
	tween.tween_callback(on_move_end)

	last_rotation = self.transform.basis

func get_selection():
	var worldspace = get_world_3d().direct_space_state
	var start = camera.project_ray_origin(mouse)
	var end = camera.project_position(mouse, 1000)
	result = worldspace.intersect_ray(PhysicsRayQueryParameters3D.create(start, end))
	
	if !result.is_empty():
		target = result["collider"]
		target_position = result["position"]
	
	if result != last_result:
		on_result_change()
	
	last_result = result
	last_target = target
	
func on_result_change():
		if last_target:
			if target != last_target || result.is_empty():
				if weakref(last_target).get_ref() != null:
					if last_target.is_in_group("interactable"):
						if last_target.get_node("MeshInstance3D/Outline"):
							last_target.get_node("MeshInstance3D/Outline").visible = false
		if target:
			if target != last_target:
				if weakref(target).get_ref() != null:
					print(target.name)
					if target.is_in_group("interactable") && target.global_position.distance_to(global_position) <= interact_range:
						target.get_node("MeshInstance3D/Outline").visible = true
		if result.is_empty():
			print("Sky")

func camera_look(movement: Vector2):
	camera_rotation += movement
	camera.rotation.y = clamp(camera.rotation.y, -1.5, -1.2)
	
	transform.basis = Basis()
	camera.transform.basis = Basis()
	
	rotate_object_local(Vector3(0,1,0), -camera_rotation.x) # first rotate around y
	camera.rotate_object_local(Vector3(1,0,0), -camera_rotation.y) # rotates around x

func on_move_end():
	velocity = Vector3.ZERO
	print(grid_pos)
	GameVariables.turn_play = false
	moving = false

func _process(delta):
	if get_tree().paused:
		print("yes")
	grid_pos = Vector2i(world_to_grid(global_position).x, world_to_grid(global_position).z)
	
func _physics_process(delta):
	get_selection()
	move_and_slide()
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if Input.is_action_just_pressed("sprint") and is_on_floor():
		speed = base_speed * sprint_mult
	if Input.is_action_just_released("sprint") and is_on_floor():
		speed = base_speed

func damage(dmg):
	GameVariables.player_health -= dmg

func _on_front_collision_area_entered(area):
	if(area.is_in_group("wall")):
		print("wall")
		front_blocked = true
	if(area.is_in_group("exit")):
		print("exit")
		GameVariables.game_end()

func _on_front_collision_area_exited(area):
	if(area.is_in_group("wall")):
		print("no more wall")
		front_blocked = false

func _on_back_collision_area_entered(area):
	if(area.is_in_group("wall")):
		print("wall")
		back_blocked = true

func _on_back_collision_area_exited(area):
	if(area.is_in_group("wall")):
		print("no more wall")
		back_blocked = false

func _on_back_collision_body_entered(body):
	if(body.is_in_group("wall")):
		print("wall")
		back_blocked = true

func _on_back_collision_body_exited(body):
	if(body.is_in_group("wall")):
		print("no more wall")
		back_blocked = false

func _on_front_collision_body_entered(body):
	if(body.is_in_group("wall")):
		print("wall")
		front_blocked = true
	if(body.is_in_group("exit")):
		print("exit")
		GameVariables.game_end()

func _on_front_collision_body_exited(body):
	if(body.is_in_group("wall")):
		print("no more wall")
		front_blocked = false
