extends Button

const GEARS = preload("res://mods-unpacked/StrawHat-Luffy/content/gears.gd")
const DESCRIPTION_FONT = preload("res://resources/fonts/actual/base/font_26.tres")
const DESCRIPTION_WIDTH = 650.0

var _popup: PopupPanel
var _options := {}
var _close: Button


func _ready() -> void:
	connect("pressed", self, "_open")
	rect_min_size = Vector2(190.0, 0.0)
	_refresh_text()


func _open() -> void:
	if _popup == null:
		_build_popup()
	_popup.popup_centered()
	_options.get(RunData.strawhat_form, _close).grab_focus()


func _build_popup() -> void:
	_popup = PopupPanel.new()
	_popup.name = "StrawHatGearMenu"
	_popup.pause_mode = Node.PAUSE_MODE_PROCESS
	var style := StyleBoxFlat.new()
	style.bg_color = Color("24201e")
	style.border_color = Color("ab784b")
	style.set_border_width_all(2)
	style.set_corner_radius_all(12)
	for side in [MARGIN_LEFT, MARGIN_TOP, MARGIN_RIGHT, MARGIN_BOTTOM]:
		style.set_default_margin(side, 24)
	_popup.add_stylebox_override("panel", style)
	add_child(_popup)
	_popup.connect("popup_hide", self, "grab_focus")

	var list := VBoxContainer.new()
	list.add_constant_override("separation", 14)
	_popup.add_child(list)
	var title := Label.new()
	title.text = tr("STRAWHAT_GEAR_MENU_TITLE")
	title.modulate = Color("ffd58e")
	list.add_child(title)

	for form in GEARS.SHOP_FORMS:
		if GEARS.is_fourth_form(form) and RunData.strawhat_fourth_form != GEARS.Form.BASE and RunData.strawhat_fourth_form != form:
			continue
		_add_option(list, form)

	var awakening := Label.new()
	awakening.add_font_override("font", DESCRIPTION_FONT)
	awakening.autowrap = true
	awakening.rect_size.x = DESCRIPTION_WIDTH + 270.0
	awakening.text = (tr("STRAWHAT_GEAR_FIFTH_DESC") if RunData.get_next_wave() > GEARS.UNLOCK_AFTER[GEARS.Form.FIFTH]
		else tr("STRAWHAT_GEAR_FIFTH_LOCKED") % GEARS.UNLOCK_AFTER[GEARS.Form.FIFTH])
	awakening.modulate = Color("e9c69e")
	list.add_child(awakening)

	_close = Button.new()
	_close.text = tr("STRAWHAT_GEAR_CLOSE")
	_close.size_flags_horizontal = Control.SIZE_SHRINK_END
	_close.connect("pressed", _popup, "hide")
	list.add_child(_close)
	_popup.rect_min_size = list.get_combined_minimum_size() + Vector2(48.0, 48.0)


func _add_option(list: VBoxContainer, form: int) -> void:
	var row := HBoxContainer.new()
	row.add_constant_override("separation", 18)
	list.add_child(row)
	var button := Button.new()
	button.name = "Form%d" % form
	button.text = tr(GEARS.LABELS[form])
	button.rect_min_size = Vector2(255.0, 45.0)
	button.disabled = not GEARS.can_select(form, RunData.current_wave, RunData.strawhat_fourth_form)
	button.connect("pressed", self, "_choose_form", [form])
	_options[form] = button
	row.add_child(button)
	var description := Label.new()
	description.add_font_override("font", DESCRIPTION_FONT)
	description.autowrap = true
	description.rect_min_size.x = DESCRIPTION_WIDTH
	description.rect_size.x = DESCRIPTION_WIDTH
	description.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	description.text = (tr("STRAWHAT_GEAR_LOCKED") % GEARS.UNLOCK_AFTER[form] if button.disabled
		else tr(GEARS.LABELS[form] + "_DESC"))
	row.add_child(description)


func _choose_form(form: int) -> void:
	RunData.strawhat_select_form(form)
	_refresh_text()
	_popup.hide()


func _refresh_text() -> void:
	text = tr("STRAWHAT_GEAR_NEXT") % tr(GEARS.LABELS[RunData.strawhat_form])
