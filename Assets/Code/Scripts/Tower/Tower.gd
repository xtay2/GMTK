extends Node2D
class_name Tower

export(String) var t_name = ""
export(Texture) var texture = preload("res://Assets/Graphics/PlaceholderTextures/placeholder_16x16.png")
export(PackedScene) var bullet_szene
export(int) var energie_consumption = 10
export(int) var detection_radius = 500
export(int) var _pallets: int
export(float,0, 2) var _rad: float = 1
export(PackedScene)  var _sound: PackedScene
export (float) var wait_time

var enemy: Node2D
var current_energie = 10000

onready var timer = Timer.new()

var sound: AudioStreamPlayer2D

func _ready():
	$Sprite.texture = texture
	$DetectionArea/CollisionShape2D.shape.set("radius", detection_radius)
	setup_shoot()


func _on_DetectionArea_area_entered(area):
	if area.is_in_group("enemy") and enemy == null:
		enemy = area


func _on_DetectionArea_area_exited(area):
	if area.is_in_group("enemy"):
		enemy = null
		
func _process(delta):
	if enemy != null and energie_consumption <= current_energie:
		shoot()
		
func shoot():
	if timer.is_stopped():
		var pallets = max(1, _pallets)
		var max_radiant = (_pallets/2/(PI/_rad))
		for i in range(pallets):
			randomize()
			var bullet_instace : Node2D = bullet_szene.instance()
			bullet_instace.global_position = global_position
			# calculate rotation for eacht bullet 
			var bullet_rotation = (i/(PI/_rad))
			#  calculate max rad
			var rot = get_angle_to(enemy.global_position) + bullet_rotation - max_radiant
			if global_position.x <= enemy.global_position.x:
				rot = get_angle_to(enemy.global_position) + max_radiant - bullet_rotation 
			get_tree().root.add_child(bullet_instace)
			print(rot)
			bullet_instace.motion = bullet_instace.motion.rotated(rot)
			if not sound == null:
				sound.play()
		timer.start()

func setup_shoot():
	if not _sound == null:
		sound = _sound.instance()
		add_child(sound)
	timer.wait_time = wait_time
	timer.one_shot = true
	add_child(timer)
