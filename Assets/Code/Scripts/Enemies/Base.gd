extends Node2D  # Necaissary since every path has it's own offset
class_name Enemy

<<<<<<< HEAD
=======
export var speed = 20 # How many pixels per second
>>>>>>> a4b771583774093c129bc5acde5bdb1a4a494ffb
export var start_health = 10

# To make the movement more interesting
export var oscillation_frequency = 10  # Hz
export var oscillation_magnitude = 0  # Pixels
onready var oscillation_phase = rand_range(0, TAU)  # seconds; to break up the uniformity

var time = 0
var previous_pos = Vector2.ZERO

var health = 0

signal on_die

func _ready():
	$Hitbox.add_to_group("enemy")
	health = start_health
	
func _process(delta):
<<<<<<< HEAD
=======
	time += delta  # I don't use universal time to handle pausation properly
	offset += delta  * speed
	
>>>>>>> a4b771583774093c129bc5acde5bdb1a4a494ffb
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
		if tower.enemy_que.has($Hitbox):
			tower.enemy_que.erase($Hitbox)
			queue_free()
			emit_signal("on_die")
	# Maybe something else too, idk

func loose_health(h: float):
	health -= h
	if health <= 0:
		die()

func _on_Hitbox_area_entered(area):
	if area is Bullet:
		$AudioPlayer.play()
