extends Node

var screen_size
var game_started: bool


func new_game() -> void:
	get_tree().call_group("mobs", "queue_free")
	$Player.start($PlayerStartPos.position)
	$Player.hit_points = 10
	$AudioStreamPlayer.play()


func game_over() -> void:
	$Player.hide()
	$HUD.reset()
	$AudioStreamPlayer.stop()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_started = false
	$Player.position = $PlayerStartPos.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	AutoloadVars.player_position = $Player.position
	if $Player.hit_points <= 0:
		game_over()


func _on_player_shoot(bullet: PackedScene, direction: Vector2) -> void:
	var spawned_bullet = bullet.instantiate()
	spawned_bullet.position = $Player/BulletSpawnPosition.global_position
	spawned_bullet.direction = direction
	add_child(spawned_bullet)
	spawned_bullet.connect("hit_body", self._on_bullet_hit_body)


func _on_bullet_hit_body(body: Variant, damage: int):
	if is_instance_of(body, Mob):
		body.take_damage(damage)


func _on_mob_destroyed(_mob: Mob):
	$HUD.set_score(int($HUD.score) + 1)
	

func _on_player_damaged(_old_hp, hp) -> void:
	$HUD.set_health(hp)


func _on_mob_spawned(mob: Variant) -> void:
	mob.connect("destroyed", _on_mob_destroyed)
