extends "res://singletons/item_service.gd"

const LUFFY_CONTENT = preload("res://mods-unpacked/StrawHat-Luffy/content/luffy_content.gd")
const GEARS = preload("res://mods-unpacked/StrawHat-Luffy/content/gears.gd")
const LUFFY_CHARACTER = preload("res://mods-unpacked/StrawHat-Luffy/content/luffy.tres")
const LUFFY_ITEMS = [
	preload("res://mods-unpacked/StrawHat-Luffy/content/straw_hat.tres"),
	preload("res://mods-unpacked/StrawHat-Luffy/content/bone_meat.tres")
]
const LUFFY_CRATE_WEAPON_CHANCE = 0.15

var _luffy_exclusives := []
var _luffy_unlocked_loot := []


func init_dlc_content() -> void:
	# ProgressData calls this before it loads a run or unlocks default content.
	if _luffy_exclusives.empty():
		_register_luffy_content()
	.init_dlc_content()


func _register_luffy_content() -> void:
	var rubber_pistol_tiers := LUFFY_CONTENT.create_weapons()
	LUFFY_CHARACTER.starting_weapons = [rubber_pistol_tiers[0]]
	base_game_item_set.characters.append(LUFFY_CHARACTER)
	base_game_item_set.weapons.append_array(rubber_pistol_tiers)
	base_game_item_set.items.append_array(LUFFY_ITEMS)
	_luffy_exclusives = rubber_pistol_tiers + LUFFY_ITEMS
	invalidate_characters_cache()
	invalidate_weapons_cache()
	invalidate_items_cache()


func init_unlocked_pool() -> void:
	.init_unlocked_pool()
	_luffy_unlocked_loot.clear()
	for item in _luffy_exclusives:
		var entry_type: int = TierData.WEAPONS if item is WeaponData else TierData.ITEMS
		var tier: Array = _tiers_data[item.tier]
		if tier[entry_type].has(item):
			_luffy_unlocked_loot.append(item)
			tier[entry_type].erase(item)
			# The vanilla last-resort draw reads _tiers_data directly.
			tier[TierData.ALL_ITEMS].erase(item)


func update_pools(pool: Array, backup_pool: Array, player_index: int, item_tier: int, type: int) -> void:
	.update_pools(pool, backup_pool, player_index, item_tier, type)
	if not GEARS.is_luffy_player(player_index):
		return
	for item in _luffy_unlocked_loot:
		var entry_type: int = TierData.WEAPONS if item is WeaponData else TierData.ITEMS
		if item.tier == item_tier and (type == entry_type or type == TierData.ALL_ITEMS):
			pool.append(item)
			backup_pool.append(item)


func process_item_box(consumable_data: ConsumableData, wave: int, player_index: int) -> ItemParentData:
	var loot: ItemParentData = .process_item_box(consumable_data, wave, player_index)
	if loot is ItemData and GEARS.is_luffy_player(player_index) and Utils.get_chance_success(LUFFY_CRATE_WEAPON_CHANCE):
		for gear in _luffy_unlocked_loot:
			if gear is WeaponData and gear.tier == loot.tier and RunData.can_take_weapon(gear, player_index):
				return apply_item_effect_modifications(gear, player_index)
	return loot
