extends KinematicBody2D

export var jumpMultiplier = 7
export var jumpApexTime = 0.4
export var player_acceleration = 10
var gravity: float
var jump_speed: float
var run_speed: float
var velocity = Vector2()
const time_on_air_to_jump = 0.2
var time_on_air = 0.0


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
	var jump = Input.is_action_just_pressed("jump")
	time_on_air = time_on_air + delta if !is_on_floor() else 0.0

	if time_on_air <= time_on_air_to_jump and jump:
		velocity.y = jump_speed
	if right:
		velocity.x = run_speed
	elif left:
		velocity.x = -run_speed
	else:
		velocity.x = 0

func _physics_process(delta):
	velocity.y += gravity * delta
	get_input(delta)
	velocity = move_and_slide(velocity, Vector2(0, -1), true)
