extends PanelContainer

const GEARS = preload("res://mods-unpacked/StrawHat-Luffy/content/gears.gd")
const STATUS_FONT = preload("res://resources/fonts/actual/base/font_26.tres")

var _form_label := Label.new()
var _charge_label: Label
var _was_awake := false


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_anchors_and_margins_preset(Control.PRESET_TOP_RIGHT)
	grow_horizontal = Control.GROW_DIRECTION_BEGIN
	margin_left = -280.0
	margin_right = -26.0
	margin_top = 24.0
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.12, 0.09, 0.08, 0.88)
	style.set_corner_radius_all(8)
	for side in [MARGIN_LEFT, MARGIN_TOP, MARGIN_RIGHT, MARGIN_BOTTOM]:
		style.set_default_margin(side, 10)
	add_stylebox_override("panel", style)
	var layout := VBoxContainer.new()
	layout.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(layout)
	_form_label.align = Label.ALIGN_CENTER
	_form_label.add_font_override("font", STATUS_FONT)
	_form_label.modulate = Color("ffd58e")
	_form_label.text = tr(GEARS.LABELS[RunData.strawhat_form])
	layout.add_child(_form_label)
	if RunData.strawhat_fifth_unlocked():
		_charge_label = Label.new()
		_charge_label.align = Label.ALIGN_CENTER
		_charge_label.add_font_override("font", STATUS_FONT)
		layout.add_child(_charge_label)
	else:
		set_process(false)


func _process(_delta: float) -> void:
	var time_left: float = RunData.strawhat_awakening_time_left()
	var awake := time_left > 0.0
	if awake and not _was_awake:
		SoundManager.play(_make_drum(), -11.0)
	_was_awake = awake
	var form: int = GEARS.Form.FIFTH if awake else RunData.strawhat_form
	_form_label.text = tr(GEARS.LABELS[form])
	if awake:
		_charge_label.text = tr("STRAWHAT_GEAR_TIME_LEFT") % int(ceil(time_left))
	elif RunData.strawhat_awakening_hits < GEARS.AWAKENING_HITS:
		_charge_label.text = tr("STRAWHAT_GEAR_CHARGE") % [RunData.strawhat_awakening_hits, GEARS.AWAKENING_HITS]
	else:
		_charge_label.text = tr("STRAWHAT_GEAR_SPENT")


func _make_drum() -> AudioStreamSample:
	var drum := AudioStreamSample.new()
	drum.format = AudioStreamSample.FORMAT_16_BITS
	drum.mix_rate = 16000
	var samples := PoolByteArray()
	samples.resize(2 * 3840)
	for i in range(3840):
		var t := float(i) / drum.mix_rate
		var phase := TAU * (70.0 * t + 3.0 * (1.0 - exp(-15.0 * t)))
		var envelope: float = min(1.0, t * 240.0) * exp(-20.0 * t)
		var value := int((sin(phase) + 0.18 * sin(phase * 2.7)) * envelope * 18000.0)
		samples[2 * i] = value & 255
		samples[2 * i + 1] = (value >> 8) & 255
	drum.data = samples
	return drum
