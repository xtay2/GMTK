extends Node2D

#The Tower the energy is coming from
var previousTower

#The Tower the energy is going to
var nextTower

var is_selected = false

#Visiual Management for Towers 
onready var ui = find_parent("TowerUI")

func connect_to_next(next):
	$Cable.points.set(0, position)
	nextTower = next
	
func connect_to_previous(previous):
	previousTower = previous

func _process(_delta):
	if(ui.place_mode and ui.last_tower == self):
		position = get_global_mouse_position()
	if(nextTower):
		$Cable.points.set(1, nextTower.position)

func place_this():
	$Graphic.texture = load("res://Assets/Graphics/PlaceholderTextures/placeholder_32x32.png")
	ui.place_mode = false

#Returs true if not colliding with path
func can_place():
	return true

func _on_click(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("right_click") and !ui.place_mode:
			ui.select_tower(self)

func update_selected():
	if is_selected: 
		$Graphic.texture = load("res://Assets/Graphics/PlaceholderTextures/placeholder_active_32x32.png")
	else:
		$Graphic.texture = load("res://Assets/Graphics/PlaceholderTextures/placeholder_32x32.png")
