extends PathFollow2D

const heavy = preload("res://Assets/Code/Scenes/Enemies/Heavy.tscn")
const rush = preload("res://Assets/Code/Scenes/Enemies/Rush.tscn")
const emp = preload("res://Assets/Code/Scenes/Enemies/Emp.tscn")
const dino = preload("res://Assets/Code/Scenes/Enemies/Dino.tscn")
const rectangle = preload("res://Assets/Code/Scenes/Enemies/Rectangle.tscn")

const DEATH_SOUNDS = [
	preload("res://Assets/Sound/Soundeffects/Enemy_Defeat_1.mp3"),
	preload("res://Assets/Sound/Soundeffects/Enemy_Defeat_2.mp3"),
	preload("res://Assets/Sound/Soundeffects/Enemy_Defeat_3.mp3")
]

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
			node.initialise(100, 10)
		"Rush":
			node = rush.instance()
			node.initialise(20, 60)
		"Emp":
			node = emp.instance()
			node.initialise(40, 20)
		"Dino":
			node = dino.instance()
			node.initialise(40, 20)
		"Rectangle":
			node = rectangle.instance()
			node.initialise(40, 20)
	add_child(node)
	speed = node.speed
	enemy = node
	node.connect("on_die", self, "node_died")


func node_died():
	var sound = DEATH_SOUNDS[randi() % DEATH_SOUNDS.size()]
	$DeathAudioPlayer.stream = sound
	$DeathAudioPlayer.play()
	get_tree().create_timer(2).connect("finished", self,	"queue_free")
	enemy.queue_free()
