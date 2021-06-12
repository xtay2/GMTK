extends Node2D

var next_towers = []

var is_selected = false

var cable_class = preload("res://Assets/Code/Scenes/Electricity/Cable.tscn")

onready var ui = find_parent("TowerUI")

var cables = []

func add_next(tower):
	next_towers.append(tower)
	var line = cable_class.instance()
	var pos = Vector2(tower.global_position.x - global_position.x + 16, tower.global_position.y - global_position.y + 16)
	line.initialise(Vector2(16, 16), pos, tower)
	add_child(line)
	cables.append(line)
	
func remove_next(tower):
	next_towers.remove(next_towers.bsearch(tower))
	for child in cables:
		if child.end_tower == tower:
			child.queue_free()
			cables.remove(next_towers.bsearch(child))
			return

func has_energy():
	return true

func update_selected():
	if is_selected: 
		$Texture.texture = load("res://Assets/Graphics/PlaceholderTextures/placeholder_active_32x32.png")
	else:
		$Texture.texture = load("res://Assets/Graphics/PlaceholderTextures/placeholder_static_32x32.png")


func _on_Texture_mouse_entered():
	ui.hovering_tower = self


func _on_Texture_mouse_exited():
	ui.hovering_tower = null
