extends Position2D
class_name Gun
signal has_shoot

export(PackedScene) var bullet_szene
export(int) var bullet_count: int
export(float,0, 2) var bullet_spread: float = 1
export(PackedScene)  var _sound: PackedScene
export (float) var gun_cooldown
export(float) var bullet_lifetime
export(int) var bullet_speed
export(int) var bullet_damage
onready var timer = Timer.new()

var sound: AudioStreamPlayer2D

func _ready():
	if not _sound == null:
		sound = _sound.instance()
		add_child(sound)
	timer.wait_time = gun_cooldown
	timer.one_shot = true
	add_child(timer)

func shoot(target_pos: Vector2 = get_global_mouse_position()):
	if timer.is_stopped():
		var pallets = max(1, bullet_count)
		var max_radiant = (bullet_count/2.0/(PI/bullet_spread))
		for i in range(pallets):
			randomize()
			var bullet_instace : Bullet = bullet_szene.instance()
			bullet_instace.global_position = global_position
			# calculate rotation for eacht bullet 
			var bullet_rotation = (i/(PI/bullet_spread))
			#  calculate max rad
			#get_global_mouse_position() = enemy.global_position
			var rot = get_parent().rotation + bullet_rotation - max_radiant
			if global_position.x <= target_pos.x:
				rot = get_parent().rotation + max_radiant - bullet_rotation 
			bullet_instace.motion = bullet_instace.motion.rotated(rot)
			bullet_instace.rotation = rot
			bullet_instace.initialise(bullet_damage, bullet_speed, bullet_lifetime)
			get_tree().root.add_child(bullet_instace)
			$Player.play()
		
		if not sound == null:
				sound.play()
		emit_signal("has_shoot")
		timer.start()
