extends Node2D

var next_towers = []

var is_selected = false

var cable_class = preload("res://Assets/Code/Scenes/Electricity/Cable.tscn")

#Mainscene
onready var main = find_parent("Main")

#Map
onready var map = main.find_node("Map")

#Visual Management for Towers 
onready var ui = main.find_node("TowerUI")

var cables = []

var total_energy = 100

var max_connections = 5

#Punkte die Tower abdeckt
var spots := []
#Width and height of tower in tiles
var box := Vector2(3, 4)

func _ready():
	$Connections.text = String(next_towers.size()) + "|" + String(max_connections)
	map.place_node(self)

func add_next(tower):
	next_towers.append(tower)
	var line = cable_class.instance()
	var pos = Vector2(tower.global_position.x - global_position.x, tower.global_position.y - global_position.y + 6)
	line.initialise(Vector2(16, 27), pos, tower)
	add_child(line)
	cables.append(line)
	$Connections.text = String(next_towers.size()) + "|" + String(max_connections)
	
func remove_next(tower):
	for child in cables:
		if child and child.end_tower == tower:
			next_towers.remove(next_towers.find(tower))
			child.queue_free()
			break
	if cables.has(null):
		cables.remove(cables.find(null))
	$Connections.text = String(next_towers.size()) + "|" + String(max_connections)


func has_energy():
	return next_towers.size() < max_connections 

func update_selected():
	if is_selected: 
		$Texture.modulate = ui.SELECTED_COLOR
	else:
		$Texture.modulate = Color.white

#Sagt den nächsten Türmen wie viel Energy sie haben
func get_passed_on_energy():
	return total_energy / next_towers.size()


func _on_Hitbox_mouse_entered():
	ui.hovering_tower = self


func _on_Hitbox_mouse_exited():
	ui.hovering_tower = null


	
