@tool
extends Node2D

signal finished

const RADIUS = 30
# TODO: password
const GAMES = ["dots", "pattern", "password"]

@export var phone_position: Vector2 = Vector2(50, 50):
	set(v): phone_position = v; queue_redraw()
@export var phone_size: Vector2 = Vector2(400, 500):
	set(v): phone_size = v; queue_redraw()

func _draw() -> void:
	draw_rect(Rect2(phone_position, phone_size), Color.PINK, false)

func _ready() -> void:
	# Randomly load mini game
	# var game_name = GAMES[randi() % GAMES.size()]
	# uncomment above for randomization. comment or delete below afterwards
	var game_name = GAMES[0]
	var script = load("res://%s.gd" % game_name)
	var game = Node2D.new()
	game.set_script(script)
	add_child(game)
	game.setup(phone_position, phone_size)
	game.finished.connect(_on_finished)

func _on_finished() -> void:
	finished.emit()
	print("finished")
