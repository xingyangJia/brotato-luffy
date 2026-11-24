extends Node

const MOD_DIR = "res://mods-unpacked/StrawHat-Luffy/"

const NAMES = {
	"en": {
		"STRAWHAT_CHARACTER_LUFFY": "Straw Hat Luffy",
		"STRAWHAT_WEAPON_RUBBER_PISTOL": "Gum-Gum Pistol",
		"STRAWHAT_ITEM_HAT": "Straw Hat",
		"STRAWHAT_ITEM_BONE_MEAT": "Meat on the Bone",
		"STRAWHAT_GEAR_BASE": "Base form",
		"STRAWHAT_GEAR_SECOND": "Gear Two",
		"STRAWHAT_GEAR_THIRD": "Gear Three",
		"STRAWHAT_GEAR_BOUNDMAN": "Four · Boundman",
		"STRAWHAT_GEAR_SNAKEMAN": "Four · Snakeman",
		"STRAWHAT_GEAR_FIFTH": "Gear Five",
		"STRAWHAT_GEAR_BASE_DESC": "Long-range punches with steady knockback.",
		"STRAWHAT_GEAR_SECOND_DESC": "Faster punches and recovery. Shorter reach.",
		"STRAWHAT_GEAR_THIRD_DESC": "Slower giant punches splash damage around the target.",
		"STRAWHAT_GEAR_BOUNDMAN_DESC": "Hard knockback hits the enemy directly behind. Pick one Gear Four form for this run.",
		"STRAWHAT_GEAR_SNAKEMAN_DESC": "Punches bend toward a second target. Pick one Gear Four form for this run.",
		"STRAWHAT_GEAR_FIFTH_DESC": "Gear Five is ready to charge in combat. Rubber hits fill it once per wave.",
		"STRAWHAT_GEAR_FIFTH_LOCKED": "Gear Five unlocks after wave %d.",
		"STRAWHAT_GEAR_MENU_TITLE": "Choose a form for the next wave",
		"STRAWHAT_GEAR_LOCKED": "Unlocks after wave %d.",
		"STRAWHAT_GEAR_CLOSE": "Back to shop",
		"STRAWHAT_GEAR_NEXT": "Next: %s",
		"STRAWHAT_GEAR_TIME_LEFT": "%d s left",
		"STRAWHAT_GEAR_CHARGE": "Awakening %d / %d",
		"STRAWHAT_GEAR_SPENT": "Awakening used"
	},
	"zh": {
		"STRAWHAT_CHARACTER_LUFFY": "草帽路飞",
		"STRAWHAT_WEAPON_RUBBER_PISTOL": "橡胶手枪",
		"STRAWHAT_ITEM_HAT": "草帽",
		"STRAWHAT_ITEM_BONE_MEAT": "带骨肉",
		"STRAWHAT_GEAR_BASE": "常态",
		"STRAWHAT_GEAR_SECOND": "二档",
		"STRAWHAT_GEAR_THIRD": "三档",
		"STRAWHAT_GEAR_BOUNDMAN": "四档 · 弹跳人",
		"STRAWHAT_GEAR_SNAKEMAN": "四档 · 蛇人",
		"STRAWHAT_GEAR_FIFTH": "五档",
		"STRAWHAT_GEAR_BASE_DESC": "长距离直拳，稳定击退靠近的敌人。",
		"STRAWHAT_GEAR_SECOND_DESC": "出拳和收拳更快，射程缩短。",
		"STRAWHAT_GEAR_THIRD_DESC": "巨人拳出手较慢，命中时伤及目标周围。",
		"STRAWHAT_GEAR_BOUNDMAN_DESC": "重拳击退，波及正后方的一名敌人。每局可选一种四档形态。",
		"STRAWHAT_GEAR_SNAKEMAN_DESC": "拳头拐向第二个目标。每局可选一种四档形态。",
		"STRAWHAT_GEAR_FIFTH_DESC": "五档已解锁。橡胶拳命中可充能，每波自动觉醒一次。",
		"STRAWHAT_GEAR_FIFTH_LOCKED": "五档在打完第 %d 波后解锁。",
		"STRAWHAT_GEAR_MENU_TITLE": "选择下一波的档位",
		"STRAWHAT_GEAR_LOCKED": "打完第 %d 波后解锁。",
		"STRAWHAT_GEAR_CLOSE": "返回商店",
		"STRAWHAT_GEAR_NEXT": "下一波 %s",
		"STRAWHAT_GEAR_TIME_LEFT": "剩余 %d 秒",
		"STRAWHAT_GEAR_CHARGE": "五档充能 %d / %d",
		"STRAWHAT_GEAR_SPENT": "本波已觉醒"
	}
}

var _translations := []


func _init() -> void:
	ModLoaderMod.install_script_extension(MOD_DIR + "extensions/item_service.gd")
	ModLoaderMod.install_script_extension(MOD_DIR + "extensions/run_data.gd")
	ModLoaderMod.install_script_extension(MOD_DIR + "extensions/shop.gd")
	ModLoaderMod.install_script_extension(MOD_DIR + "extensions/main.gd")


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
