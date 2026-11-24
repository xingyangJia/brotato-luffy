extends "res://weapons/melee/melee_weapon.gd"

const GEARS = preload("res://mods-unpacked/StrawHat-Luffy/content/gears.gd")
const IMPACT = preload("res://mods-unpacked/StrawHat-Luffy/content/gear_impact.gd")
const DAMAGE_ARGS = preload("res://entities/units/unit/take_damage_args.gd")
const THIRD_RADIUS = 70.0
const FIFTH_RADIUS = 82.0
const BOUNDMAN_REACH = 105.0
const SNAKEMAN_REACH = 140.0

onready var _punch_sprite: Sprite = $Sprite

var _strawhat_form: int = GEARS.Form.BASE
var _last_gear_attack := -1


func _ready() -> void:
	if not GEARS.can_use_gears(player_index):
		return
	_hitbox.connect("hit_something", self, "_on_rubber_hit")
	if GEARS.is_fourth_form(_strawhat_form):
		_punch_sprite.self_modulate = Color("b48c98")


func init_stats(reset_cooldown: bool = true) -> void:
	if GEARS.can_use_gears(player_index):
		_strawhat_form = RunData.strawhat_form
	if _strawhat_form == GEARS.Form.BASE:
		.init_stats(reset_cooldown)
		return
	var original_stats: WeaponStats = stats
	var gear_stats: MeleeWeaponStats = original_stats.duplicate()
	match _strawhat_form:
		GEARS.Form.SECOND:
			gear_stats.cooldown *= 0.74
			gear_stats.animation_speed *= 1.35
			gear_stats.max_range = int(round(gear_stats.max_range * 0.80))
		GEARS.Form.THIRD:
			gear_stats.cooldown *= 1.48
			gear_stats.animation_speed *= 0.86
		GEARS.Form.BOUNDMAN:
			gear_stats.cooldown *= 1.16
			gear_stats.knockback *= 1.7
		GEARS.Form.SNAKEMAN:
			gear_stats.knockback *= 0.7
	stats = gear_stats
	.init_stats(reset_cooldown)
	stats = original_stats


func _process(_delta: float) -> void:
	if _strawhat_form == GEARS.Form.THIRD and is_instance_valid(_punch_sprite):
		var extension: float = clamp(_punch_sprite.position.x / 85.0, 0.0, 1.0)
		_punch_sprite.scale = Vector2.ONE * lerp(1.0, 1.42, extension)


func _on_rubber_hit(target: Node, damage_dealt: int) -> void:
	if not is_instance_valid(target) or not target is Enemy or damage_dealt <= 0 or not RunData.wave_in_progress:
		return
	if _last_gear_attack == _hitbox.player_attack_id:
		return
	_last_gear_attack = _hitbox.player_attack_id
	var form := _strawhat_form
	RunData.strawhat_charge_awakening()
	if RunData.strawhat_awakening_time_left() > 0.0:
		form = GEARS.Form.FIFTH
	if form != GEARS.Form.BASE:
		call_deferred("_apply_gear_impact", form, target.get_instance_id(), target.global_position, _hitbox.damage)


func _apply_gear_impact(form: int, target_id: int, origin: Vector2, damage: int) -> void:
	var scene = get_tree().current_scene
	if not RunData.wave_in_progress or not is_instance_valid(scene):
		return
	if form == GEARS.Form.SECOND:
		_show_gear_impact(form, global_position, global_position, 0.0)
		return
	var spawner = scene.get_node_or_null("EntitySpawner")
	if not is_instance_valid(spawner):
		return
	match form:
		GEARS.Form.THIRD:
			_damage_nearby(spawner.get_all_enemies(false), target_id, origin, THIRD_RADIUS, damage * 0.60, false)
			_show_gear_impact(form, origin, origin, THIRD_RADIUS)
		GEARS.Form.FIFTH:
			_damage_nearby(spawner.get_all_enemies(false), target_id, origin, FIFTH_RADIUS, damage * 0.55, true)
			_show_gear_impact(form, origin, origin, FIFTH_RADIUS)
		GEARS.Form.BOUNDMAN, GEARS.Form.SNAKEMAN:
			_follow_up(spawner.get_all_enemies(false), form, target_id, origin, damage)


func _damage_nearby(enemies: Array, target_id: int, origin: Vector2, radius: float, damage: float, bounce: bool) -> void:
	for enemy in enemies.duplicate():
		if not _can_follow_up(enemy, target_id) or enemy.global_position.distance_squared_to(origin) > radius * radius:
			continue
		_damage_extra(enemy, damage)
		if bounce and is_instance_valid(enemy) and enemy.current_stats.health > 0:
			var away: Vector2 = origin.direction_to(enemy.global_position)
			var resistance: float = clamp(enemy.current_stats.knockback_resistance, 0.0, 1.0)
			enemy.knockback_vector += away * 180.0 * (1.0 - resistance)


func _follow_up(enemies: Array, form: int, target_id: int, origin: Vector2, damage: int) -> void:
	var behind_target: bool = form == GEARS.Form.BOUNDMAN
	var direction: Vector2 = global_position.direction_to(origin)
	var reach: float = BOUNDMAN_REACH if behind_target else SNAKEMAN_REACH
	var nearest = null
	var nearest_distance: float = reach * reach
	for enemy in enemies:
		if not _can_follow_up(enemy, target_id):
			continue
		var offset: Vector2 = enemy.global_position - origin
		var distance := offset.length_squared()
		if distance >= nearest_distance:
			continue
		if behind_target and (offset.dot(direction) <= 0.0 or abs(offset.cross(direction)) > 30.0):
			continue
		nearest = enemy
		nearest_distance = distance
	if is_instance_valid(nearest):
		_show_gear_impact(form, origin, nearest.global_position, 0.0)
		_damage_extra(nearest, damage * (0.70 if behind_target else 0.50))


func _can_follow_up(enemy, target_id: int) -> bool:
	return (is_instance_valid(enemy) and enemy.is_inside_tree() and enemy.visible
		and enemy.current_stats.health > 0 and enemy.get_instance_id() != target_id)


func _damage_extra(enemy: Node, damage: float) -> void:
	var args = DAMAGE_ARGS.new(player_index)
	args.from = self
	args.hide_feedback = true
	enemy.take_damage(max(1, int(round(damage))), args)


func _show_gear_impact(form: int, origin: Vector2, end: Vector2, radius: float) -> void:
	var impact = IMPACT.new()
	var effects = get_tree().current_scene.get_node("Effects")
	impact.setup(form, effects.to_local(origin), effects.to_local(end), radius)
	effects.add_child(impact)
