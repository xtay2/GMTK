extends Node2D

onready var main = find_parent("Main")

var placed_objects := []

const GRID_DIM = 16

func _ready():
	place_node(main.find_node("Reactor"))

#Überprüft ob eine position (Vector2) schon besetzt ist
func can_place(node):
	for new_spot in node.spots:
		for old_spot in placed_objects:
			if new_spot == old_spot:
				return false
	return true

#Listet die Node
func place_node(node):
	update_spot(node, node.position)
	if can_place(node):
		for spot in node.spots:
			placed_objects.append(spot)

#Entfernt die Node von der Liste
func remove_node(node):
	for spot in node.spots:
		while placed_objects.has(spot):
			placed_objects.remove(placed_objects.find(spot))

func update_spot(node, pos):
	node.spots.clear()
	for i in range(0, node.box.x):
		for j in range(0, node.box.y):
			node.spots.append(Vector2((i * GRID_DIM) + (round(pos.x / GRID_DIM) * GRID_DIM), (j * GRID_DIM) + (round(pos.y / GRID_DIM) * GRID_DIM)))
	if can_place(node):
		node.position = node.spots[0]

