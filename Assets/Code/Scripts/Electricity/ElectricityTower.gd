extends Node2D

#The Tower the energy is coming from
var previous_tower

#The Tower the energy is going to
var next_tower

var is_selected = false

#Visiual Management for Towers 
onready var ui = find_parent("TowerUI")

var cable_class = preload("res://Assets/Code/Scenes/Electricity/Cable.tscn")

var cable

func _ready():
	cable = cable_class.instance()
	add_child(cable)
	cable.initialise(Vector2(16, 16), Vector2(16, 16), null)

func connect_to_next(next):
	next_tower = next
	var pos = Vector2(next.global_position.x - global_position.x + 16, next.global_position.y - global_position.y + 16)
	cable.connect_to_tower(pos, next_tower)
	
func connect_to_previous(previous):
	previous_tower = previous

func _process(_delta):
	if ui and ui.place_mode and ui.last_tower == self:
		position = get_global_mouse_position()
	if !previous_tower:
		next_tower = null 

func place_this():
	$Graphic.texture = load("res://Assets/Graphics/PlaceholderTextures/placeholder_32x32.png")

func update_selected():
	if is_selected: 
		$Graphic.texture = load("res://Assets/Graphics/PlaceholderTextures/placeholder_active_32x32.png")
	else:
		$Graphic.texture = load("res://Assets/Graphics/PlaceholderTextures/placeholder_32x32.png")

func remove_cable():
	cable.set_point_position(1, Vector2(16, 16))

func has_energy():
	return previous_tower != null

func _on_Graphic_mouse_entered():
	ui.hovering_tower = self

func _on_Graphic_mouse_exited():
	ui.hovering_tower = null

func power_breakdown():
	if next_tower:
		next_tower.power_breakdown()
		next_tower = null
	previous_tower = null
	cable.shrink()

func removeTower():
	if previous_tower:
		if previous_tower.name == "Reactor":
			previous_tower.remove_next(self)
		else:
			previous_tower.next = null
			previous_tower.cable.shrink()
			power_breakdown()
	ui.placed_towers -= 1
	queue_free()
