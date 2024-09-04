class_name Mob extends CharacterBody2D

static var screen_size
@export var speed = 400
@export var friction = 10
@export var hit_points = 2
@export var attack_damage = 1
var tween: Tween

signal damaged(old_hp, hp)
signal destroyed(mob)


func take_damage(damage: int) -> void:
	var old_hit_points = hit_points
	hit_points -= damage
	if hit_points <= 0:
		destroy()
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate", Color.RED, 0)
	tween.tween_property($AnimatedSprite2D, "modulate", Color.WHITE, 0.25)

	damaged.emit(old_hit_points, hit_points)


func destroy() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate", Color.TRANSPARENT, 0.1)
	$DestroyedSFX.play()
	destroyed.emit(self)
	$CollisionShape2D.set_deferred("disabled", true)
	hide()


func _ready() -> void:
	add_to_group("mobs")
	screen_size = get_viewport_rect().size
	$AnimatedSprite2D.play()
	show()


func _physics_process(_delta: float) -> void:
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	elif velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	
	if hit_points <= 0 and !$DestroyedSFX.playing:
		remove_from_group("mobs")
		queue_free()
