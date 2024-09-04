class_name Player extends CharacterBody2D

@export var speed = 100
@export var friction = 15
@export var jump_velocity = -300
@export var hit_points = 10
@export var gravity = 10
var screen_size
var facing
var tween: Tween

var PlayerBullet = preload("res://bullet.tscn")

signal damaged(old_hp, hp)
signal shoot(bullet, direction)


func take_damage(damage_source, bump_direction) -> void:
	set_collision_mask_value(3, false)
	$DamageSFX.play()
	$HitInvulTimer.start()
	$HitDisableTimer.start()
	$PlayerSprite/DamageFlashTimer.start()
	$PlayerSprite.visible = false

	var damage = damage_source.attack_damage
	var old_hit_points = hit_points
	hit_points -= damage

	velocity = bump_direction.normalized() * 300

	damaged.emit(old_hit_points, hit_points)


func start(pos):
	position = pos
	show()
	$PlayerCollisionShape.disabled = false


func _ready() -> void:
	screen_size = get_viewport_rect().size
	facing = Vector2.RIGHT
	$PlayerSprite.animation = "idle"
	$PlayerSprite.play()
	$MuzzleFlashSprite.hide()
	hide()


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if $HitDisableTimer.is_stopped():
		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = jump_velocity
			$JumpSFX.pitch_scale = randf_range(0.90, 1.10)
			$JumpSFX.play()
		if Input.is_action_just_released("jump") and velocity.y < 0:
			velocity.y = 0

		# Get the input direction and handle the movement/deceleration.
		var direction := Input.get_axis("move_left", "move_right")
		if direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, friction)
	else:
		velocity.x = move_toward(velocity.x, 0, friction)

	# Execute movement and check for damaging collisions
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		var normal = collision.get_normal()
		if is_instance_of(collider, Mob):
			take_damage(collider, normal)
			break

	# Sprite animation selection
	if velocity.x > 0:
		$PlayerSprite.animation = "run"
		$PlayerSprite.flip_h = false
		facing = Vector2.RIGHT
	elif velocity.x < 0:
		$PlayerSprite.animation = "run"
		$PlayerSprite.flip_h = true
		facing = Vector2.LEFT
	else:
		$PlayerSprite.animation = "idle"
	if velocity.y != 0 and not is_on_floor():
		$PlayerSprite.animation = "jump"

	# Handle shooting
	if Input.is_action_just_pressed("shoot"):
		var active_bullets = get_tree().get_nodes_in_group("player_bullets")
		if active_bullets.size() <= 3:
			$PlayerSprite.animation = "shoot"
			if facing == Vector2.RIGHT:
				$BulletSpawnPosition.position = Vector2(15, 3)
				$MuzzleFlashSprite.position = $BulletSpawnPosition.position
				$MuzzleFlashSprite.flip_h = false
			elif facing == Vector2.LEFT:
				$BulletSpawnPosition.position = Vector2(-15, 3)
				$MuzzleFlashSprite.position = $BulletSpawnPosition.position
				$MuzzleFlashSprite.flip_h = true
			$MuzzleFlashSprite/MuzzleFlashDuration.start()
			$MuzzleFlashSprite.show()
			$ShootSFX.play()
			shoot.emit(PlayerBullet, facing)


func _on_damage_flash_timer_timeout() -> void:
	$PlayerSprite.visible = !$PlayerSprite.visible


func _on_hit_invul_timer_timeout() -> void:
	set_collision_mask_value(3, true)
	$PlayerSprite/DamageFlashTimer.stop()
	$PlayerSprite.visible = true


func _on_muzzle_flash_duration_timeout() -> void:
	$MuzzleFlashSprite.hide()
