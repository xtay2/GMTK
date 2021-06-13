extends PathFollow2D

const heavy = preload("res://Assets/Code/Scenes/Enemies/Heavy.tscn")
const rush = preload("res://Assets/Code/Scenes/Enemies/Rush.tscn")
const emp = preload("res://Assets/Code/Scenes/Enemies/Emp.tscn")
const dino = preload("res://Assets/Code/Scenes/Enemies/Dino.tscn")
const rectangle = preload("res://Assets/Code/Scenes/Enemies/Rectangle.tscn")

var speed = 0

var enemy

func _process(delta):
	offset += speed * delta


func init_enemy(type):
	print(type)
	var node
	match(type):
		"Heavy":
			node = heavy.instance()
			node.initialise(10, 10)
		"Rush":
			node = rush.instance()
			node.initialise(10, 30)
		"Emp":
			node = emp.instance()
			node.initialise(10, 10)
		"Dino":
			node = dino.instance()
			node.initialise(10, 10)
		"Rectangle":
			node = rectangle.instance()
			node.initialise(10, 10)
	add_child(node)
	speed = node.speed
	enemy = node
	node.connect("on_die", self, "node_died")


func node_died():
	queue_free()
