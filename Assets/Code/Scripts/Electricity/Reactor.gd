extends Node2D

var next_towers = []

var is_selected = false

var cable_class = preload("res://Assets/Code/Scenes/Electricity/Cable.tscn")

onready var ui = find_parent("TowerUI")

var cables = []

var total_energy = 100

var max_connections = 5

func _ready():
	$Connections.text = String(next_towers.size()) + "|" + String(max_connections)

func add_next(tower):
	next_towers.append(tower)
	var line = cable_class.instance()
	var pos = Vector2(tower.global_position.x - global_position.x + 10, tower.global_position.y - global_position.y + 6)
	line.initialise(Vector2(16, 16), pos, tower)
	add_child(line)
	cables.append(line)
	$Connections.text = String(next_towers.size()) + "|" + String(max_connections)
	
func remove_next(tower):
	next_towers.remove(next_towers.bsearch(tower))
	$Connections.text = String(next_towers.size()) + "|" + String(max_connections)
	for child in cables:
		if child.end_tower == tower:
			child.queue_free()
			cables.remove(next_towers.bsearch(child))
			return

func has_energy():
	return next_towers.size() < max_connections 

func update_selected():
	if is_selected: 
		$Texture.texture = load("res://Assets/Graphics/PlaceholderTextures/placeholder_active_32x32.png")
	else:
		$Texture.texture = load("res://Assets/Graphics/PlaceholderTextures/placeholder_static_32x32.png")


func _on_Texture_mouse_entered():
	ui.hovering_tower = self


func _on_Texture_mouse_exited():
	ui.hovering_tower = null

#Sagt den nächsten Türmen wie viel Energy sie haben
func get_passed_on_energy():
	return total_energy / next_towers.size()
