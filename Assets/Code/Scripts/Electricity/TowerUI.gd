extends Node2D

var max_towers = 10
var placed_towers = 0

var tower_class = preload("res://Assets/Code/Scenes/Electricity/ElectricityTower.tscn")

var place_mode = false

var connect_mode = false

#Tower that was placed last
var last_tower = null

#Tower that was selected last
var selected_tower

#The Tower the Mouse is hovering over
var hovering_tower

func _input(event):
	if event is InputEventKey:
		#Init Placemode 
		if event.is_action_pressed("place_tower") and !place_mode and placed_towers < max_towers:
			place_tower()
	if event is InputEventMouseButton:
		#Confim Placement
		if event.is_action_pressed("right_click") and place_mode and last_tower.can_place():
			last_tower.place_this()
			place_mode = false
		#En
		if connect_mode and !place_mode and event.is_action_released("right_click") and selected_tower:
			connect_mode = false
			if hovering_tower:
				selected_tower.connect_to_next(hovering_tower)
				hovering_tower.connect_to_previous(selected_tower)
				
		#End Connect Mode ab
		if connect_mode and event.is_action_released("right_click"):
			connect_mode = false
	
func place_tower():
	placed_towers += 1
	print("Placed " + String(placed_towers) + " Tower.")
	var new_tower = tower_class.instance()
	add_child(new_tower)
	last_tower = new_tower
	place_mode = true

func select_tower(tower):
	#Disconnect old Tower
	if selected_tower:
		selected_tower.is_selected = false
		selected_tower.update_selected()
	#Connect new Tower
	selected_tower = tower
	selected_tower.is_selected = true
	selected_tower.update_selected()
