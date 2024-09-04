class_name MobYellowBee extends Mob


func _ready() -> void:
	super()
	$AnimatedSprite2D.animation = "move"


func _physics_process(delta: float) -> void:
	super(delta)
		
	var direction = AutoloadVars.player_position - global_position
	velocity = direction.normalized() * speed
	
	move_and_slide()
