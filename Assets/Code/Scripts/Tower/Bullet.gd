extends Node2D
class_name Bullet

var motion = Vector2(1,0)
export var damage := 0
var speed := 100
var lifetime := 2

onready var expolsion := load("res://Assets/Code/Scenes/BulletExplosion/Explode.tscn")

func _ready():
	$Timer.wait_time = lifetime
	$Timer.start()

func _physics_process(delta):
	
	position += motion * delta * speed


func _on_Area2D_area_entered(area):
	if area.is_in_group("enemy"):
		print("hit")
		area.get_parent().loose_health(damage)
		destroy()

func destroy():
	#ADD PARTICEL
	var ex = expolsion.instance()
	ex.global_position = global_position
	get_tree().root.add_child(ex)
	queue_free()


func _on_Timer_timeout():
	destroy()
