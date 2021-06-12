extends PathFollow2D  # Necaissary since every path has it's own offset
class_name Enemy

export var path_completion_time = 10 # How many seconds does it take to comppleate the path
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
	add_to_group("enemy")
	health = start_health
	
func _process(delta):
	time += delta  # I don't use universal time to handle pausation properly
	unit_offset += delta  / path_completion_time
	if unit_offset == 1:
		die()
	
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
	
	v_offset = oscillation_magnitude * sin(oscillation_phase + TAU * time * oscillation_frequency)
	
func die():
	emit_signal("on_die")
	queue_free()
	# Maybe something else too, idk

func loose_health(h: float):
	health -= h
	if health <= 0:
		die()

func _on_Hitbox_area_entered(area):
	$AudioPlayer.play()
