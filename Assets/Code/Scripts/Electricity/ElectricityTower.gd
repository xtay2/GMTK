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

var energy_level = 0

var energy_loss = 10

const SELECTED_COLOR = Color(0.129412, 0.878431, 0.862745)

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
	update_energy()
	if ui and ui.place_mode and ui.last_tower == self:
		position = get_global_mouse_position()
	if !previous_tower:
		next_tower = null 

func place_this():
	$Socket.texture = load("res://Assets/Graphics/Towers/ElectricityTower/Node_Tower_Off.png")
	$Texture.play("off")

func update_selected():
	if is_selected: 
		$Socket.modulate = SELECTED_COLOR
		$Texture.modulate = SELECTED_COLOR
	else:
		$Socket.modulate = Color(0,0,0,0)
		$Texture.modulate = Color(0,0,0,0)

func remove_cable():
	cable.set_point_position(1, Vector2(16, 16))

func has_energy():
	return energy_level > 0


func power_breakdown():
	if next_tower:
		next_tower.power_breakdown()
		next_tower = null
	previous_tower = null
	energy_level = 0
	cable.shrink()
	$Socket.texture = load("res://Assets/Graphics/Towers/ElectricityTower/Node_Tower_Off.png")
	$Texture.play("off")

func removeTower():
	if previous_tower:
		if previous_tower.name == "Reactor":
			previous_tower.remove_next(self)
		else:
			previous_tower.next_tower = null
			previous_tower.cable.shrink()
	power_breakdown()
	ui.placed_towers -= 1
	queue_free()

func get_all_previous_nodes():
	var list = []
	var prev = self
	while prev != "Reactor":
		list.append(prev)
		prev = prev.previous_tower
	return list

func update_energy():
	if previous_tower:
		energy_level = previous_tower.get_passed_on_energy()
		if energy_level > 0:
			$Socket.texture = load("res://Assets/Graphics/Towers/ElectricityTower/Node_Tower_On.png")
			$Texture.play("on")
	else:
		energy_level = 0
	if $EnergyHUD.visible:
		$EnergyHUD.text = String(energy_level) + "V"

#Sagt den nächsten Türmen wie viel Energy sie haben
func get_passed_on_energy():
	return energy_level - energy_loss


func _on_Hitbox_mouse_entered():
	ui.hovering_tower = self
	$EnergyHUD.visible = true


func _on_Hitbox_mouse_exited():
	ui.hovering_tower = null
	$EnergyHUD.visible = false
