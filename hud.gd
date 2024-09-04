class_name HUD extends CanvasLayer

var player_health
var score
var game_in_progress

signal start_game


func set_health(health: int) -> void:
	player_health = health


func set_score(new_score: int) -> void:
	score = new_score


func reset() -> void:
	$PressStart.show()
	player_health = 10
	score = 0
	game_in_progress = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$Health.text = str(player_health)
	$Score.text = str(score)
	if Input.is_action_just_pressed("start_game") and !game_in_progress:
		$PressStart.hide()
		game_in_progress = true
		start_game.emit()
