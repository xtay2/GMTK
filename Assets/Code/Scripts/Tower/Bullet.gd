extends Node2D
class_name Bullet

var motion = Vector2(1,0)
var damage := 0
var speed := 100
var lifetime := 2

func _ready():
	$Timer.wait_time = lifetime
	$Timer.start()

func _physics_process(delta):
	
	position += motion * delta * speed


func _on_Area2D_area_entered(area):
	if area.is_in_group("enemy"):
		area.hp -= damage
		destroy()


func destroy():
	#ADD PARTICEL
	queue_free()


func _on_Timer_timeout():
	destroy()
