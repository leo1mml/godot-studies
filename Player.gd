extends KinematicBody2D

enum Direction {
	right
	left
}

export var jumpMultiplier = 7
export var jumpApexTime = 0.4
export var player_acceleration = 10
var gravity: float
var jump_speed: float
var run_speed: float
var velocity = Vector2()
const MAX_TIME_ON_AIR_TO_JUMP = 0.2
var time_on_air = 0.0
var direction = Direction.right


# Called when the node enters the scene tree for the first time.
func _ready():
	var character_length = $CollisionShape2D.shape.extents.y * 2
	var character_height = $CollisionShape2D.shape.extents.x * 2
	var jumpHeight = character_height * jumpMultiplier
	gravity = jumpHeight / pow(jumpApexTime, 2)
	jump_speed = -gravity * jumpApexTime
	run_speed = character_length * 10

func get_input(delta):
	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	var isJumpJustPressed = Input.is_action_just_pressed("jump")
	time_on_air = time_on_air + delta if !is_on_floor() else 0.0

	if time_on_air <= MAX_TIME_ON_AIR_TO_JUMP and isJumpJustPressed:
		velocity.y = jump_speed
	if right:
		velocity.x = run_speed
	elif left:
		velocity.x = -run_speed
	else:
		velocity.x = 0

func _physics_process(delta):
	var snap = Vector2.DOWN * 16 if is_on_floor() else Vector2.ZERO
	velocity.y += gravity * delta
	get_input(delta)
	velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP)
	set_animation(velocity)

func set_animation(velocity):
	var animatedSprite = $AnimatedSprite
	if velocity.x < 0.011 && velocity.x > -0.011 && is_on_floor():
		animatedSprite.play("Idle")
	elif velocity.y != 0 && !is_on_floor():
		animatedSprite.play("Jump")
	else:
		animatedSprite.play("Run")
	flip_if_necessary(velocity, animatedSprite)

func flip_if_necessary(velocity, animatedSprite):
	if velocity.x < 0 && direction == Direction.right:
		animatedSprite.set_flip_h(true)
	elif velocity.x > 0:
		animatedSprite.set_flip_h(false)
