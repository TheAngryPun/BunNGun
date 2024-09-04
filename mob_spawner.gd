class_name MobSpawner extends Area2D


@export var mob_scene : PackedScene
@export var spawn_rate : float

signal mob_spawned(mob)


func spawn_mob() -> void:
	var mob = mob_scene.instantiate()
	mob.position = $SpawnPoint.position
	add_child(mob)

	mob_spawned.emit(mob)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SpawnTimer.wait_time = spawn_rate
	if $VisibleOnScreenNotifier2D.is_on_screen():
		$SpawnTimer.start()


func _on_spawn_timer_timeout() -> void:
	spawn_mob()


func _on_body_entered(body: Node2D) -> void:
	if is_instance_of(body, Player):
		$SpawnTimer.stop()


func _on_body_exited(body: Node2D) -> void:
	if is_instance_of(body, Player):
		$SpawnTimer.start()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	$SpawnTimer.stop()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	spawn_mob()
	$SpawnTimer.start()
