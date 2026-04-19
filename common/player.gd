extends CharacterBody2D


const SPEED = 50.0
const JUMP_VELOCITY = -300.0

var is_rolling = false
var rolling_total_frames = 50
var rolling_current_frame = 0
var last_direction = 1

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:		
	var direction := Input.get_axis("player_move_left", "player_move_right")
	if !is_rolling:
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta
		
		# Handle jump.
		if Input.is_action_just_pressed("player_jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		if direction:
			last_direction = direction
			velocity.x = direction * SPEED
			animated_sprite_2d.play("move")
			if (direction < 0):
				animated_sprite_2d.flip_h = true
			else:
				animated_sprite_2d.flip_h = false
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			animated_sprite_2d.play("idle")
			
		# Handle Roll
		if Input.is_action_just_pressed("player_roll") and is_on_floor() and !is_rolling:
			is_rolling = true
			rolling_current_frame = 0
			animated_sprite_2d.play("roll")
			velocity.x = last_direction * SPEED * 2
	elif rolling_current_frame < rolling_total_frames:
		rolling_current_frame += 1
	else:
		is_rolling = false

	move_and_slide()
