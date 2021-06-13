extends Node2D

var timer = 0
var spawn_interval = 1

onready var main = find_parent("Main")

var follower = preload("res://Assets/Code/Scenes/Enemies/CharacterFollower.tscn")

var wave_composition := {"Dino" : 0,"Emp": 0, "Heavy": 0, "Rectangle" : 0, "Rush" : 0}

var enemyCount

func _ready():
	init_wave()

func _process(delta):
	timer += delta
	if timer > spawn_interval and !wave_composition.empty():
		var type = generate_type()
		var new_follower = follower.instance()
		new_follower.init_enemy(type)
		add_child(new_follower)
		timer = 0
	elif wave_composition.empty() and enemyCount == 0:
		main.wave += 1
		init_wave()

func init_wave():
	var w = main.wave
	wave_composition.Dino = round(20 + w * 5)
	wave_composition.Rush = round(-2 + w * 3)
	wave_composition.Emp = round(-10 + w * 2)
	wave_composition.Heavy = round(-100 + w * 3)
	wave_composition.Rectangle = round(-100 + w * 5)

func generate_type():
	var everything = 0
	for entry in wave_composition:
		everything += wave_composition.get(entry)
	enemyCount = everything
	while true:
		for entry in wave_composition:
			if wave_composition.get(entry) > 0 and randi() % int(everything) < wave_composition.get(entry):
				wave_composition[entry] -= 1 
				return entry

func enemy_has_died():
	enemyCount -= 1
	print("Enemies Left: " + String(enemyCount))

func _on_reactor_entered(area):
	if "EnemyHitbox" in area.name:
		print("Loosecondition")
	
