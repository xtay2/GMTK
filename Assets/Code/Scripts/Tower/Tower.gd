extends Node2D
class_name Tower

signal enemy_changed(enemy)

export(String) var t_name = ""
export(int) var energie_consumption = 10
export(int) var detection_radius = 500

var enemy_que: Array
var current_energie := 10000

var detectionArea := Area2D.new()
var detectionCollision := CollisionShape2D.new()

func _ready():
	var shape := CircleShape2D.new()
	shape.radius = detection_radius
	detectionCollision.shape = shape
	add_child(detectionArea)
	detectionArea.add_child(detectionCollision)


func _on_DetectionArea_area_entered(area):
	if area.is_in_group("enemy"):
		enemy_que.push_back(area)

func _on_DetectionArea_area_exited(area):
	if area.is_in_group("enemy"):
		enemy_que.pop_front()
