extends Node2D

const GEARS = preload("res://mods-unpacked/StrawHat-Luffy/content/gears.gd")
const DURATION = 0.24

var _form: int
var _end: Vector2
var _radius: float
var _elapsed := 0.0


func setup(form: int, origin: Vector2, end: Vector2, radius: float) -> void:
	_form = form
	_end = end - origin
	_radius = radius
	position = origin
	z_index = 2


func _process(delta: float) -> void:
	_elapsed += delta
	if _elapsed >= DURATION:
		queue_free()
	else:
		update()


func _draw() -> void:
	var progress := _elapsed / DURATION
	var opacity := 1.0 - progress
	match _form:
		GEARS.Form.SECOND:
			var steam := Color(1.0, 0.91, 0.86, opacity * 0.48)
			draw_circle(Vector2(-10.0, -12.0 - progress * 15.0), 4.0 + progress * 5.0, steam)
			draw_circle(Vector2(9.0, -19.0 - progress * 12.0), 3.0 + progress * 4.0, steam)
		GEARS.Form.THIRD, GEARS.Form.FIFTH:
			var color := Color(1.0, 0.83, 0.53, opacity)
			if _form == GEARS.Form.FIFTH:
				color = Color(1.0, 0.99, 0.91, opacity)
			var radius: float = lerp(_radius * 0.55, _radius, progress)
			draw_arc(Vector2.ZERO, radius, 0.0, TAU, 32, color, 3.0, true)
		GEARS.Form.BOUNDMAN, GEARS.Form.SNAKEMAN:
			var color := Color(1.0, 0.62, 0.43, opacity)
			var bend := _end * 0.45
			if _form == GEARS.Form.SNAKEMAN:
				bend += _end.tangent().normalized() * 15.0
			draw_polyline(PoolVector2Array([Vector2.ZERO, bend, _end]), color, 3.0, true)
