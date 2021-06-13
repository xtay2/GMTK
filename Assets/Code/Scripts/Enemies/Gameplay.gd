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
	wave_composition.Dino = round(20 + w * 5)
	wave_composition.Rush = round(-2 + w * 3)
	wave_composition.Emp = round(-10 + w * 2)
	wave_composition.Heavy = round(-100 + w * 3)
	wave_composition.Rectangle = round(-100 + w * 5)
	var everything = 0
	for entry in wave_composition:
		if wave_composition.get(entry) > 0:
			everything += wave_composition.get(entry)
	enemy_count = everything
	max_enemy_count = everything

func generate_type():
	while max_enemy_count > 0 :
		for entry in wave_composition:
			if enemy_count > 0 and randi() % int(enemy_count) < wave_composition.get(entry):
				wave_composition[entry] -= 1 
				return entry

func _on_reactor_entered(area):
	if "EnemyHitbox" in area.name:
		print("Loosecondition")
	

func update_enemy_count():
	enemy_count = get_tree().get_nodes_in_group("enemy").size()
