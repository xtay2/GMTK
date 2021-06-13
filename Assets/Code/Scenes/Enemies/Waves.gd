extends PathFollow2D

const heavy = preload("res://Assets/Code/Scenes/Enemies/Heavy.tscn")
const rush = preload("res://Assets/Code/Scenes/Enemies/Rush.tscn")
const emp = preload("res://Assets/Code/Scenes/Enemies/Emp.tscn")
const dino = preload("res://Assets/Code/Scenes/Enemies/Dino.tscn")
const rectangle = preload("res://Assets/Code/Scenes/Enemies/Rectangle.tscn")

var speed = 10

func _process(delta):
	offset += speed * delta

func init_enemy(type):
	print(type)
	var node
	match(type):
		"Heavy":
			node = heavy.instance()
		"Rush":
			node = rush.instance()
		"Emp":
			node = emp.instance()
		"Dino":
			node = dino.instance()
		"Rectangle":
			node = rectangle.instance()
	add_child(node)
