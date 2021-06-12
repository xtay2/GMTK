extends Control

signal on_upgrade()
signal select_tower_type(name)

func update_enemy_info(wave, enemy_count):
	pass

func _on_Upgrade_pressed():
	emit_signal("on_upgrade")

func _on_tower_selected(name):
	emit_signal("select_tower_type", name)
