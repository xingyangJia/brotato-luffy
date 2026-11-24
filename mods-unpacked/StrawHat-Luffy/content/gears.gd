extends Reference

enum Form { BASE, SECOND, THIRD, BOUNDMAN, SNAKEMAN, FIFTH }

const CHARACTER_ID = "character_strawhat_luffy"
const SHOP_FORMS = [Form.BASE, Form.SECOND, Form.THIRD, Form.BOUNDMAN, Form.SNAKEMAN]
const UNLOCK_AFTER = [0, 3, 6, 10, 10, 15]
const LABELS = [
	"STRAWHAT_GEAR_BASE",
	"STRAWHAT_GEAR_SECOND",
	"STRAWHAT_GEAR_THIRD",
	"STRAWHAT_GEAR_BOUNDMAN",
	"STRAWHAT_GEAR_SNAKEMAN",
	"STRAWHAT_GEAR_FIFTH"
]
const AWAKENING_HITS = 10
const AWAKENING_HIT_INTERVAL = 0.35
const AWAKENING_SECONDS = 6.0


static func is_luffy_player(player_index: int) -> bool:
	if player_index < 0 or player_index >= RunData.get_player_count():
		return false
	var character = RunData.get_player_character(player_index)
	return character != null and character.my_id == CHARACTER_ID


static func can_use_gears(player_index: int) -> bool:
	return player_index == 0 and not RunData.is_coop_run and is_luffy_player(player_index)


static func is_fourth_form(form: int) -> bool:
	return form == Form.BOUNDMAN or form == Form.SNAKEMAN


static func can_select(form: int, cleared_wave: int, fourth_form: int) -> bool:
	return (form in SHOP_FORMS and cleared_wave >= UNLOCK_AFTER[form]
		and (not is_fourth_form(form) or fourth_form == Form.BASE or fourth_form == form))
