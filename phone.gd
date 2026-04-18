extends Node2D

signal finished

const RADIUS = 30
# TODO: dots, pattern, password
const GAMES = ["dots"]

@export var phone_position: Vector2 = Vector2(50, 50)
@export var phone_size: Vector2 = Vector2(400, 500)

func _ready() -> void:
	# Randomly load mini game
	var game_name = GAMES[randi() % GAMES.size()]
	var script = load("res://%s.gd" % game_name)
	var game = Node2D.new()
	game.set_script(script)
	add_child(game)
	game.setup(phone_position, phone_size)
	game.finished.connect(_on_finished)

func _on_finished() -> void:
	finished.emit()
	print("finished")
