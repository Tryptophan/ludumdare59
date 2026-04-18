extends Node2D

signal finished

const RADIUS = 30

var phone_position: Vector2
var phone_size: Vector2
var circles: Array[Vector2] = []


func setup(pos: Vector2, size: Vector2) -> void:
	phone_position = pos
	phone_size = size
	for i in 10:
		circles.append(Vector2(
			randf_range(phone_position.x + RADIUS, phone_position.x + phone_size.x - RADIUS),
			randf_range(phone_position.y + RADIUS, phone_position.y + phone_size.y - RADIUS)
		))

func _draw() -> void:
	draw_rect(Rect2(phone_position, phone_size), Color.BLUE, false)
	for pos in circles:
		draw_circle(pos, RADIUS, Color.RED)


# Press all dots on the screen
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		for i in range(circles.size() - 1, -1, -1):
			if event.position.distance_to(circles[i]) <= RADIUS:
				circles.remove_at(i)
				queue_redraw()
				if circles.is_empty():
					finished.emit()
				break
