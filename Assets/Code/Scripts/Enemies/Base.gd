extends PathFollow2D  # Necaissary since every path has it's own offset
class_name Enemy

export var path_completion_time = 10 # How many seconds does it take to comppleate the path

# To make the movement more interesting
export var oscillation_frequency = 10  # Hz
export var oscillation_magnitude = 0  # Pixels
onready var oscillation_phase = rand_range(0, TAU)  # seconds; to break up the uniformity

var time = 0

func _ready():
	unit_offset = rand_range(0, 1)
	rotate = false
	loop = false
	
func _process(delta):
	time += delta  # I don't use universal time to handle pausation properly
	unit_offset += delta  / path_completion_time
	if unit_offset == 1:
		die()
	
	v_offset = oscillation_magnitude * sin(oscillation_phase + TAU * time * oscillation_frequency)
	#var orth_offset = orthogonal * 
	#path_instance.h_offset = orth_offset.x
	#path_instance.v_offset = oscillation_magnitude * sin(oscillation_phase + TAU * time * oscillation_frequency)
	#position = Vector2.LEFT * oscillation_magnitude * sin(oscillation_phase + TAU * time * oscillation_frequency)

func die():
	queue_free()

func _on_Hitbox_area_entered(area):
	die()
