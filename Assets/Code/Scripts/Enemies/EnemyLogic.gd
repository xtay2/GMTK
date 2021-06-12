extends Path2D
class_name enemy_logic

const heavy = preload("res://Assets/Code/Scenes/Enemies/Heavy.tscn")
const rush = preload("res://Assets/Code/Scenes/Enemies/Rush.tscn")

# Job is it to spawn enemies and be responsable for waves

signal update_enemy_info
signal wave_compleated

var enemy_count = 0
var wave_number = 0  # First wave is 1

func coroutine_spawn_enemies(type_list: Array):
	for t in type_list:
		var node = null
		match(t):
			"heavy":
				node = heavy.instance()
			"rush":
				node = rush.instance()
		add_child(node)
		node.connect("on_die", self, "_died", [node], CONNECT_ONESHOT)
		$Timer.start(1)
		yield($Timer, "timeout")

func new_wave():
	var enemies = ["heavy", "heavy", "rush"]  # To be set somewhere else (JSON ?)
	
	enemy_count = enemies.size()
	wave_number += 1
	emit_signal("update_enemy_info", wave_number, enemy_count)
	coroutine_spawn_enemies(enemies)

func _died(character: Enemy):
	enemy_count -= 1
	emit_signal("update_enemy_info", wave_number, enemy_count)
	if enemy_count == 0:
		emit_signal("wave_compleated")
