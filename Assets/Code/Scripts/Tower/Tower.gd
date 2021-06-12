extends Node2D
class_name Tower

#signal enemy_changed(enemy)

export(String) var t_name = ""
export(int) var energie_consumption = 10
export(int) var detection_radius = 500

var enemy_que: Array
var target: Vector2
var current_energie := 10000


var detectionArea := Area2D.new()
var detectionCollision := CollisionShape2D.new()

func _ready():
	add_to_group("towers")
	var shape := CapsuleShape2D.new()
	shape.radius = detection_radius
	shape.height = 0
	detectionCollision.shape = shape
	detectionArea.connect("area_entered", self, "_on_DetectionArea_area_entered")
	detectionArea.connect("area_exited", self, "_on_DetectionArea_area_exited")
	add_child(detectionArea)
	detectionArea.add_child(detectionCollision)

func _on_DetectionArea_area_entered(area):
	if area.is_in_group("enemy"):
		enemy_que.push_front(area)

func _on_DetectionArea_area_exited(area):
	if area.get_parent().is_in_group("enemy"):
		enemy_que.pop_back()
		
func _physics_process(delta):
	if enemy_que.size() != 0:
		target = enemy_que.back().global_position
