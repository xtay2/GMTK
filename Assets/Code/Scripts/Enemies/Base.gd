extends Node2D  # Necaissary since every path has it's own offset
class_name Enemy

# To make the movement more interesting
export var oscillation_frequency = 10  # Hz
export var oscillation_magnitude = 0  # Pixels
onready var oscillation_phase = rand_range(0, TAU)  # seconds; to break up the uniformity

const HIT_SOUND = preload("res://Assets/Sound/Soundeffects/Enemy_Hit.mp3")

var time = 0
var previous_pos = Vector2.ZERO

var health = 0
var speed = 0

signal on_die

func _ready():
	$EnemyHitbox.add_to_group("enemy")

	
func initialise(start_health, start_speed):
	health = start_health
	speed = start_speed
	
func _process(_delta):
	var velocity = $Animation.global_position - previous_pos
	previous_pos = $Animation.global_position
	
	var velocity_angle = velocity.angle()
	$Animation.flip_h = false
	if -PI/4 < velocity_angle and velocity_angle < PI/4:
		$Animation.animation = "walk_straight"
	elif PI/4 < velocity_angle and velocity_angle < PI*3/4:
		$Animation.animation = "walk_south"
	elif -PI/4 > velocity_angle and velocity_angle > -PI*3/4:
		$Animation.animation = "walk_north"
	else:
		$Animation.animation = "walk_straight"
		$Animation.flip_h = true
	
func die():
	for tower in get_tree().get_nodes_in_group("towers"):
		if tower.enemy_que.has($EnemyHitbox):
			tower.enemy_que.erase($EnemyHitbox)
			emit_signal("on_die")
			Global.enemies_killed += 1			

func loose_health(h: float):
	health -= h
	if health <= 0:
		die()

func _on_Hitbox_area_entered(area):
	if area.get_parent() is Bullet:
		$AudioPlayer.pitch_scale = rand_range(0.9, 1.1)
		$AudioPlayer.stream = HIT_SOUND
		$AudioPlayer.play()
