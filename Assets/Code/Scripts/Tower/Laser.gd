extends RayCast2D

onready var vfx_line := $Line2D
var shoot_bool : bool = true
#Vars that are not important to the video 
export var speed := 420

func _ready():
	reset_line()

func _physics_process(delta: float) -> void:
	raycast_bullet_stuff()


func raycast_bullet_stuff() -> void:
	var mouse_pos := get_global_mouse_position()
	var angle_from_mouse_to_player := mouse_pos.angle_to_point(global_position)
	rotation = (angle_from_mouse_to_player - (PI/2))
	
	if is_colliding() and shoot_bool == true:
		make_line()
		check_if_we_can_kill_enemy()


func reset_line() -> void:
	vfx_line.points[1] = Vector2.ZERO


func make_line() -> void:
	vfx_line.points[1] = transform.xform_inv(get_collision_point())


func check_if_we_can_kill_enemy() -> void:
	print(get_collider_shape())

	if get_collider_shape() == 0:
		pass
