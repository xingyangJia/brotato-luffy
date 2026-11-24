extends "res://ui/menus/shop/shop.gd"

const GEARS = preload("res://mods-unpacked/StrawHat-Luffy/content/gears.gd")
const GEAR_SELECTOR = preload("res://mods-unpacked/StrawHat-Luffy/ui/gear_selector.gd")


func _ready() -> void:
	if GEARS.can_use_gears(0):
		call_deferred("_add_strawhat_gear_selector")


func _add_strawhat_gear_selector() -> void:
	var header = get_node("Content/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer")
	var reroll: Button = header.get_node("RerollButton")
	var selector = GEAR_SELECTOR.new()
	selector.name = "StrawHatGearButton"
	selector.theme = reroll.theme
	header.add_child(selector)
	header.move_child(selector, reroll.get_index())
	selector.focus_neighbour_right = selector.get_path_to(reroll)
	var previous_left = reroll.get_node_or_null(reroll.focus_neighbour_left)
	if previous_left != null and previous_left != selector:
		selector.focus_neighbour_left = selector.get_path_to(previous_left)
	reroll.focus_neighbour_left = reroll.get_path_to(selector)
