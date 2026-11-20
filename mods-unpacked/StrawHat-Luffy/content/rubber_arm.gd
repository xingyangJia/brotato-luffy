extends Node2D

const ANCHOR = Vector2(2, 0)
const CUFF = Vector2(-17, 0)
const OUTLINE = Color("#191519")
const SKIN = Color("#f3ad68")

onready var _fist: Sprite = $"../Sprite"

var _wrist := Vector2.ZERO


func _process(_delta: float) -> void:
	var wrist: Vector2 = _fist.transform.xform(CUFF)
	if wrist != _wrist:
		_wrist = wrist
		update()


func _draw() -> void:
	if _wrist.x - ANCHOR.x < 4.0:
		return
	draw_circle(ANCHOR, 7.0, OUTLINE)
	draw_line(ANCHOR, _wrist, OUTLINE, 14.0, true)
	draw_circle(ANCHOR, 5.0, SKIN)
	draw_line(ANCHOR, _wrist, SKIN, 10.0, true)
