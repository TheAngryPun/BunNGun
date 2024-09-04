class_name MobBlueBee extends Mob


func move() -> void:
	var random_direction = Vector2.from_angle(randf() * 2 * PI)
	var random_impulse = randf()

	velocity = random_direction.normalized() * random_impulse * speed


func _ready() -> void:
	super()
	$MovementTimer.start()
	move()


func _physics_process(delta: float) -> void:
	super(delta)

	velocity = velocity.move_toward(Vector2.ZERO, friction)

	if velocity == Vector2.ZERO:
		$AnimatedSprite2D.animation = "idle"
	else:
		$AnimatedSprite2D.animation = "move"

	move_and_slide()


func _on_movement_timer_timeout() -> void:
	move()
