extends Node2D

onready var main = find_parent("Main")

var placed_objects := []

func _ready():
	place_node(main.find_node("Reactor"))

#Überprüft ob eine position (Vector2) schon besetzt ist
func can_place_at(pos):
	for node in placed_objects:
		if node.position == pos:
			return false
	return true

#Listet die Node
func place_node(node):
	if can_place_at(node.position):
		placed_objects.append(node)

#Entfernt die Node von der Liste
func remove_node(node):
	placed_objects.remove(placed_objects.bsearch(node))
