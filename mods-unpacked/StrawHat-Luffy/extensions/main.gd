extends "res://main.gd"

const STRAWHAT_GEARS = preload("res://mods-unpacked/StrawHat-Luffy/content/gears.gd")
const STRAWHAT_GEAR_HUD = preload("res://mods-unpacked/StrawHat-Luffy/ui/gear_hud.gd")


func _ready() -> void:
	if STRAWHAT_GEARS.can_use_gears(0) and RunData.current_wave > STRAWHAT_GEARS.UNLOCK_AFTER[STRAWHAT_GEARS.Form.SECOND]:
		call_deferred("_add_strawhat_gear_hud")


func _add_strawhat_gear_hud() -> void:
	var hud = STRAWHAT_GEAR_HUD.new()
	hud.name = "StrawHatGearHUD"
	$UI.add_child(hud)
	connect("end_of_the_wave", hud, "hide")
