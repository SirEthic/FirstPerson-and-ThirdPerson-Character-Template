class_name Player
extends Character

@export var sensitivity : float
@export var jump_velocity : float
@export var speed : float

@onready var head: Node3D = $Head
@onready var third_person_camera: Camera3D = $Head/ThirdPersonCamera

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * sensitivity)
		third_person_camera.rotate_x(-event.relative.y * sensitivity)
		third_person_camera.rotation.x = clamp(third_person_camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func handle_input(_delta) -> void:
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Back")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_velocity
	
	if is_on_floor():
		if direction.x > 0:
			velocity.x = direction.x * speed
			current_state = State.STRAFE_RIGHT
		elif direction.x < 0:
			velocity.x = direction.x * speed
			current_state = State.STRAFE_LEFT
		elif direction.z:
			velocity.z = direction.z * speed
			current_state = State.WALK
		else:
			velocity.x = move_toward(velocity.x , 0, speed)
			velocity.z = move_toward(velocity.z , 0, speed)
			current_state = State.IDLE
			
	move_and_slide()
