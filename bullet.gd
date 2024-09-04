class_name Bullet extends Area2D

@export var speed = 400
@export var bullet_damage = 1
var direction

signal hit_body(body, damage)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("player_bullets")
	if direction == Vector2.RIGHT:
		$BulletSprite.flip_h = false
	elif direction == Vector2.LEFT:
		$BulletSprite.flip_h = true


func _physics_process(delta: float) -> void:
	position += direction * speed * delta

	# Check to see if it's safe to free the bullet node
	if $BulletShape.disabled and !$ImpactSFX.playing:
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	remove_from_group("player_bullets")
	$BulletShape.set_deferred("disabled", true)
	hide()


func _on_body_entered(body: Node2D) -> void:
	if is_instance_of(body, Mob):
		hit_body.emit(body, bullet_damage)
		$ImpactSFX.play()
		remove_from_group("player_bullets")
		$BulletShape.set_deferred("disabled", true)
		hide()
