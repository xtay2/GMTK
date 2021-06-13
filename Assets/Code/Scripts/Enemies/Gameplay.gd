extends Node2D

var timer = 0
var spawn_interval = 1

onready var main = find_parent("Main")

var follower = preload("res://Assets/Code/Scenes/Enemies/CharacterFollower.tscn")

var wave_composition := {"Dino" : 0,"Emp": 0, "Heavy": 0, "Rectangle" : 0, "Rush" : 0}

var enemy_count = 0
var max_enemy_count = INF 

func _ready():
	init_wave()

func _process(delta):
	timer += delta
	if timer > spawn_interval and max_enemy_count > 0:
		var type = generate_type()
		var new_follower = follower.instance()
		new_follower.init_enemy(type)
		add_child(new_follower)
		timer = 0
		max_enemy_count -= 1
	if wave_composition.empty() and enemy_count <= 0:
		main.wave += 1
		init_wave()
	update_enemy_count()

func init_wave():
	var w = main.wave
	if w % 3 == 0:
		wave_composition.Dino = round(7 * (1 + w * 0.1))
	if w % 5 == 0:
		wave_composition.Rush = round(12 * (1 + w * 0.1))
	if w % 7 == 0:
		wave_composition.Emp = round(5 * (1 + w * 0.1))
	if w % 10 == 0:
		wave_composition.Heavy = round(3 * (1 + w * 0.1))
	var everything = 0
	for ct in wave_composition.values():
		if ct > 0:
			everything += ct
	if everything == 0:
		print(everything)
		wave_composition.Rectangle = round(10 * (1 + w * 0.1))
		everything = wave_composition.Rectangle
	max_enemy_count = everything
	print("Starting Wave " + String(main.wave) + " with " + String(max_enemy_count) + " enemies")

func generate_type():
	var check = true
	while check:
		check = false
		for entry in wave_composition:
			if max_enemy_count > 0 and randi() % int(max_enemy_count) < wave_composition.get(entry):
				wave_composition[entry] -= 1 
				return entry
			if wave_composition[entry] > 0:
				check = true
	print("Couldnt generate enemy")
	max_enemy_count = 0

func _on_reactor_entered(area):
	if "EnemyHitbox" in area.name:
		print("Loosecondition")
	

func update_enemy_count():
	enemy_count = get_tree().get_nodes_in_group("enemy").size()
