extends "res://singletons/run_data.gd"

const GEARS = preload("res://mods-unpacked/StrawHat-Luffy/content/gears.gd")
const STRAWHAT_GEARS_KEY = "strawhat_luffy_gears"

var strawhat_form: int = GEARS.Form.BASE
var strawhat_fourth_form: int = GEARS.Form.BASE
var strawhat_awakening_hits := 0

var _strawhat_awakening_end := -1.0
var _strawhat_last_charge := INF


func reset(keep_play_mode: bool = false) -> void:
	strawhat_form = GEARS.Form.BASE
	strawhat_fourth_form = GEARS.Form.BASE
	_clear_strawhat_awakening()
	.reset(keep_play_mode)


func get_state() -> Dictionary:
	var state := .get_state()
	if strawhat_form != GEARS.Form.BASE or strawhat_fourth_form != GEARS.Form.BASE:
		state[STRAWHAT_GEARS_KEY] = [strawhat_form, strawhat_fourth_form]
	return state


func resume_from_state(state: Dictionary) -> void:
	.resume_from_state(state)
	_clear_strawhat_awakening()
	strawhat_form = GEARS.Form.BASE
	strawhat_fourth_form = GEARS.Form.BASE
	var forms = state.get(STRAWHAT_GEARS_KEY, [])
	if forms is Array and forms.size() == 2:
		if _strawhat_is_saved_form(forms[1]) and GEARS.is_fourth_form(int(forms[1])):
			strawhat_fourth_form = int(forms[1])
		if _strawhat_is_saved_form(forms[0]) and GEARS.can_select(int(forms[0]), current_wave, strawhat_fourth_form):
			strawhat_form = int(forms[0])


func on_wave_start(timer: Timer) -> void:
	_clear_strawhat_awakening()
	if GEARS.is_fourth_form(strawhat_form):
		strawhat_fourth_form = strawhat_form
	.on_wave_start(timer)


func strawhat_select_form(form: int) -> void:
	if not wave_in_progress and GEARS.can_use_gears(0) and GEARS.can_select(form, current_wave, strawhat_fourth_form):
		strawhat_form = form


func strawhat_fifth_unlocked() -> bool:
	return current_wave > GEARS.UNLOCK_AFTER[GEARS.Form.FIFTH]


func strawhat_awakening_time_left() -> float:
	if _strawhat_awakening_end < 0.0 or not is_instance_valid(wave_timer) or not wave_in_progress:
		return 0.0
	return max(0.0, wave_timer.time_left - _strawhat_awakening_end)


func strawhat_charge_awakening() -> bool:
	if (not strawhat_fifth_unlocked() or not wave_in_progress or not is_instance_valid(wave_timer)
			or strawhat_awakening_hits >= GEARS.AWAKENING_HITS):
		return false
	var time_left: float = wave_timer.time_left
	if _strawhat_last_charge - time_left < GEARS.AWAKENING_HIT_INTERVAL:
		return false
	_strawhat_last_charge = time_left
	strawhat_awakening_hits += 1
	if strawhat_awakening_hits < GEARS.AWAKENING_HITS:
		return false
	_strawhat_awakening_end = max(0.0, time_left - GEARS.AWAKENING_SECONDS)
	return true


func _clear_strawhat_awakening() -> void:
	strawhat_awakening_hits = 0
	_strawhat_awakening_end = -1.0
	_strawhat_last_charge = INF


func _strawhat_is_saved_form(value) -> bool:
	return typeof(value) == TYPE_INT or typeof(value) == TYPE_REAL
