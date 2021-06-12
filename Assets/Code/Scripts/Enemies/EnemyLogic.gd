extends Path2D
class_name enemy_logic

const heavy = preload("res://Assets/Code/Scenes/Enemies/Heavy.tscn")
const rush = preload("res://Assets/Code/Scenes/Enemies/Rush.tscn")
const emp = preload("res://Assets/Code/Scenes/Enemies/Emp.tscn")
const dino = preload("res://Assets/Code/Scenes/Enemies/Dino.tscn")
const rectangle = preload("res://Assets/Code/Scenes/Enemies/Rectangle.tscn")

# Job is it to spawn enemies and be responsable for waves

signal update_enemy_info
signal wave_compleated

var enemy_count = 0
var wave_number = 0  # First wave is 1

var wave_data

func _ready():
	var file = File.new()
	file.open("res://Assets/Data/waves.json", File.READ)
	var content = file.get_as_text()
	file.close()
	var result = JSON.parse(content)
	if result.error != OK:
		printerr("JSON loading result" + result.error_string)
	wave_data = result.result
	

func coroutine_spawn_enemies(type_list: Array):
	for t in type_list:
		var node = null
		match(t):
			"heavy":
				node = heavy.instance()
			"rush":
				node = rush.instance()
			"emp":
				node = emp.instance()
			"dino":
				node = dino.instance()
			"rectangle":
				node = rectangle.instance()
		if node == null:
			printerr("No such type: " + t)
			enemy_count -= 1
			continue
		add_child(node)
		node.connect("on_die", self, "_died", [node], CONNECT_ONESHOT)
		$Timer.start(1)
		yield($Timer, "timeout")

func new_wave():
	if wave_number == len(wave_data):
		print("You win")
		get_tree().reload_current_scene()
		return
	
	var enemies = wave_data[wave_number]
	
	enemy_count = enemies.size()
	wave_number += 1
	emit_signal("update_enemy_info", wave_number, enemy_count)
	coroutine_spawn_enemies(enemies)

func _died(character: Enemy):
	enemy_count -= 1
	emit_signal("update_enemy_info", wave_number, enemy_count)
	if enemy_count == 0:
		emit_signal("wave_compleated")
