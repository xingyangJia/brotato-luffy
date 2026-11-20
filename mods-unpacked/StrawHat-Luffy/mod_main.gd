extends Node

const MOD_DIR = "res://mods-unpacked/StrawHat-Luffy/"

const NAMES = {
	"en": {
		"STRAWHAT_CHARACTER_LUFFY": "Straw Hat Luffy",
		"STRAWHAT_WEAPON_RUBBER_PISTOL": "Gum-Gum Pistol",
		"STRAWHAT_ITEM_HAT": "Straw Hat",
		"STRAWHAT_ITEM_BONE_MEAT": "Meat on the Bone"
	},
	"zh": {
		"STRAWHAT_CHARACTER_LUFFY": "草帽路飞",
		"STRAWHAT_WEAPON_RUBBER_PISTOL": "橡胶手枪",
		"STRAWHAT_ITEM_HAT": "草帽",
		"STRAWHAT_ITEM_BONE_MEAT": "带骨肉"
	}
}

var _translations := []


func _init() -> void:
	ModLoaderMod.install_script_extension(MOD_DIR + "extensions/item_service.gd")


func _ready() -> void:
	for locale in NAMES:
		var translation := Translation.new()
		translation.locale = locale
		for key in NAMES[locale]:
			translation.add_message(key, NAMES[locale][key])
		TranslationServer.add_translation(translation)
		_translations.append(translation)


func _exit_tree() -> void:
	for translation in _translations:
		TranslationServer.remove_translation(translation)
