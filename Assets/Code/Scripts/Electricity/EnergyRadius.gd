extends Area2D

var base

var close_circles = []


func initialise(node, strength):
	base = node
	$EnergyCollision.scale *= strength
	$Sprite.scale *= strength

#Gibt alle Nodes zurück, deren Circles im Radius sind
func possible_connections():
	var nodes = []
	for area in close_circles:
		nodes.append(area.base)
	return nodes


func _on_EnergyRadius_area_entered(area):
	if "EnergyRadius" in area.name:
		close_circles.append(area)


func _on_EnergyRadius_area_exited(area):
	if close_circles.has(area):
		close_circles.remove(close_circles.find(area))
