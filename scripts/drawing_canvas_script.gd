extends Node2D

var line_start: Vector2 = Vector2.ZERO
var line_stop: Vector2 = Vector2.ZERO
var reticle_pos: Vector2 = Vector2.ZERO

var draw_enabled: bool = true
var line_color: Color = Color.WHITE
var distance: float = 20.0

func _process(delta: float) -> void:
	queue_redraw()
	
func _draw() -> void:
	if draw_enabled:
		draw_line(line_start, line_stop, line_color)
		draw_reticle(reticle_pos)

func flash() -> void:
	line_color = Color.RED
	await Global.wait(0.1)
	line_color = Color.WHITE

func draw_reticle(pos: Vector2, size: float = 6.0) -> void:
	var dist: float
	if distance <= size:
		dist = size + 2.0
	else:
		dist = distance
	var corner1: Vector2 = pos + Vector2(-1, -1) * dist
	var corner2: Vector2 = pos + Vector2(1, -1) * dist
	var corner3: Vector2 = pos + Vector2(-1, 1) * dist
	var corner4: Vector2 = pos + Vector2(1,1) * dist
	
	var corner1_retA: Vector2 = corner1 + Vector2.DOWN * size
	var corner1_retB: Vector2 = corner1 + Vector2.RIGHT * size
	
	var corner2_retA: Vector2 = corner2 + Vector2.DOWN * size
	var corner2_retB: Vector2 = corner2 + Vector2.LEFT * size
	
	var corner3_retA: Vector2 = corner3 + Vector2.UP * size
	var corner3_retB: Vector2 = corner3 + Vector2.RIGHT * size
	
	var corner4_retA: Vector2 = corner4 + Vector2.UP * size
	var corner4_retB: Vector2 = corner4 + Vector2.LEFT * size
	
	draw_line(corner1, corner1_retA, line_color)
	draw_line(corner1, corner1_retB, line_color)
	
	draw_line(corner2, corner2_retA, line_color)
	draw_line(corner2, corner2_retB, line_color)
	
	draw_line(corner3, corner3_retA, line_color)
	draw_line(corner3, corner3_retB, line_color)
	
	draw_line(corner4, corner4_retA, line_color)
	draw_line(corner4, corner4_retB, line_color)
