extends Control

onready var main = find_parent("Main")

func _process(_delta):
	set_power(main.find_node("Reactor").power_used, main.find_node("Reactor").damage_done)

func set_power(power, overload):
	$Power.value = power
	$Overload.value = power + overload
