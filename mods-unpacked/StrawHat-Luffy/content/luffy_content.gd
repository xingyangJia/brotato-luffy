extends Reference

const WEAPON_ID = "weapon_strawhat_rubber_pistol"
const RUBBER_PISTOL_SCENE = preload("res://mods-unpacked/StrawHat-Luffy/content/rubber_pistol.tscn")
const RUBBER_PISTOL_ICON = preload("res://mods-unpacked/StrawHat-Luffy/art/strawhat_fist_icon.png")

const FIST_TIERS = [
	"res://weapons/melee/fist/1/fist_data.tres",
	"res://weapons/melee/fist/2/fist_2_data.tres",
	"res://weapons/melee/fist/3/fist_3_data.tres",
	"res://weapons/melee/fist/4/fist_4_data.tres"
]
const DAMAGE = [8, 15, 28, 52]
const REACH = [175, 185, 195, 205]


static func create_weapons() -> Array:
	var weapons := []
	var next_tier: WeaponData = null
	for tier in range(FIST_TIERS.size() - 1, -1, -1):
		var template: WeaponData = load(FIST_TIERS[tier])
		var weapon: WeaponData = template.duplicate()
		var stats: MeleeWeaponStats = template.stats.duplicate()
		stats.damage = DAMAGE[tier]
		stats.max_range = REACH[tier]
		weapon.my_id = WEAPON_ID + "_" + str(tier + 1)
		weapon.weapon_id = WEAPON_ID
		weapon.name = "STRAWHAT_WEAPON_RUBBER_PISTOL"
		weapon.icon = RUBBER_PISTOL_ICON
		weapon.scene = RUBBER_PISTOL_SCENE
		weapon.stats = stats
		weapon.upgrades_into = next_tier
		weapon._generate_hashes()
		weapons.push_front(weapon)
		next_tier = weapon
	return weapons
