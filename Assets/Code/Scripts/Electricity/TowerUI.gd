extends Node2D

#Colors for placing and moving
const PLACEMENT_COLOR = Color(0.129412, 0.878431, 0.862745)
const SELECTED_COLOR = Color(0.517647, 0.8, 0.301961)


#Tower Counter
var max_towers = 10
var placed_towers = 0

#Class imports
var tower_class = preload("res://Assets/Code/Scenes/Electricity/ElectricityTower.tscn")
var reactor_class = preload("res://Assets/Code/Scenes/Electricity/Reactor.tscn")

#Modes
var place_mode = false
var connect_mode = false

#Tower that was placed last
var last_tower = null

#Tower that were selected last
var selected_towers = {"Tower1" : null, "Tower2" : null}

#The Tower or Reactor the Mouse is hovering over
var hovering_tower

func _ready():
	$TowerCount.text = String(placed_towers) + "|" + String(max_towers)

func _input(event):
	if event is InputEventKey:
		#Init Placemode 
		if event.is_action_pressed("space") and !place_mode and !connect_mode and placed_towers < max_towers:
			place_tower()
		#Init Connectmode
		elif event.is_action_pressed("shift") and !place_mode:
			start_connect_mode()
			return
		#End Connectmode
		elif event.is_action_released("shift") and connect_mode:
			end_connection_mode()
			return

	if event is InputEventMouseButton:
		#Confirm Placement
		if event.is_action_pressed("left_click") and place_mode:
			last_tower.place_this()
			place_mode = false
			$TowerCount.text = String(placed_towers) + "|" + String(max_towers)
			return
		#Select Tower
		elif connect_mode and event.is_action_pressed("left_click") and hovering_tower != null:
			select()
		#Remove Tower
		if event.is_action_pressed("right_click") and !place_mode and !connect_mode and hovering_tower and "ElectricityTower" in hovering_tower.name:
			hovering_tower.removeTower()
			hovering_tower = null
			$TowerCount.text = String(placed_towers) + "|" + String(max_towers)
			return
		#Remove connections and select
		elif event.is_action_pressed("right_click") and !place_mode and connect_mode and hovering_tower and hovering_tower.name != "Reactor" and hovering_tower.next_tower:
			hovering_tower.next_tower.power_breakdown()
			hovering_tower.remove_cable()
			end_connection_mode()
			start_connect_mode()
			select()
			return
		#Connect wenn in Connectmode
		if connect_mode and event.is_action_pressed("left_click") and selected_towers.Tower1 != null and selected_towers.Tower2 != null:
			if selected_towers.Tower1.name == "Reactor":
				selected_towers.Tower1.add_next(selected_towers.Tower2)
			else:
				#Rekursives zerstören der Energie
				if selected_towers.Tower1.next_tower:
					selected_towers.Tower1.next_tower.power_breakdown()
				#Connecten der hinteren
				selected_towers.Tower1.connect_to_next(selected_towers.Tower2)
			selected_towers.Tower2.connect_to_previous(selected_towers.Tower1)
			step_connection_mode()
			if selected_towers.Tower1:
				selected_towers.Tower1.update_energy()
				if !selected_towers.Tower1.has_energy():
					end_connection_mode()

#Füge Tower am Anfang im place mode hinzu
func place_tower():
	last_tower = tower_class.instance()
	add_child(last_tower)
	place_mode = true
	placed_towers += 1

#Wähle Tower aus
func select():
	if selected_towers.Tower1 == null:
		if hovering_tower.has_energy():
			selected_towers.Tower1 = hovering_tower
			selected_towers.Tower1.is_selected = true
			selected_towers.Tower1.update_selected()
			
	elif selected_towers.Tower2 == null and hovering_tower.name != "Reactor" and !hovering_tower.previous_tower and selected_towers.Tower1.has_energy():
		selected_towers.Tower2 = hovering_tower
		selected_towers.Tower2.is_selected = true
		selected_towers.Tower2.update_selected()

#Beende Connectmode für beide Tower
func end_connection_mode():
	if selected_towers.Tower1 != null:
		selected_towers.Tower1.is_selected = false
		selected_towers.Tower1.update_selected()

	if selected_towers.Tower2 != null:
		selected_towers.Tower2.is_selected = false
		selected_towers.Tower2.update_selected()
	selected_towers = {"Tower1" : null, "Tower2" : null}
	connect_mode = false
	$EditModeOverlay.visible = false

#Setze den alten Tower 2 auf den neuen Tower 1
func step_connection_mode():
	if selected_towers.Tower1 != null:
		selected_towers.Tower1.is_selected = false
		selected_towers.Tower1.update_selected()
		if selected_towers.Tower2 != null:
			selected_towers.Tower1 = selected_towers.Tower2
			selected_towers.Tower2.is_selected = false
			selected_towers.Tower2.update_selected()
			selected_towers.Tower2 = null
			selected_towers.Tower1.is_selected = true
			selected_towers.Tower1.update_selected()

func start_connect_mode():
	$EditModeOverlay.visible = true
	connect_mode = true
