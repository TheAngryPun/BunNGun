class_name MobRedCrawler extends Mob

var direction: Vector2


func _ready() -> void:
	super()
	direction = Vector2(randf_range(-1, 1), 0)
	velocity = direction.normalized() * speed
	$AnimatedSprite2D.animation = "crawl"


func _physics_process(delta: float) -> void:
	super(delta)
	velocity = direction.normalized() * speed

	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()
