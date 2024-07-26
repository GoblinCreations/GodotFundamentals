extends CharacterBody2D

const SPEED = 64
const TURN_SPEED = 2
const ROTATE_SPEED = 20

@export var weapon : Weapon

@onready var animation_player = $AnimationPlayer
@onready var collision = $CollisionShape2D
@onready var body_sprite = $BodySprite

var direction = Vector2.RIGHT

func _physics_process(delta):
	var input_direction = Input.get_vector("turn_left", "turn_right", "move_backward", "move_forward")
	if input_direction.x != 0:
		#rotate the tank based on the input vector
		direction = direction.rotated(input_direction.x * (PI / 2) * TURN_SPEED * delta)
		rotation = direction.angle()
	if input_direction.y != 0:
		#Move forward/backwards and play move animation
		animation_player.play("Move")
		velocity = lerp(velocity, (direction.normalized() * input_direction.y) * SPEED, SPEED * delta)
	else:
		velocity = Vector2.ZERO
		animation_player.play("Idle")
	
	#apply movement velocity
	move_and_slide()
	
	#Apply weapon rotation
	var weapon_rotate_direction = Input.get_axis("rotate_weapon_left","rotate_weapon_right")
	weapon.rotation_degrees += (weapon_rotate_direction * ROTATE_SPEED * delta * PI)

func _input(event):
	if event.is_action_pressed("weapon_fire"):
		weapon.fire()
