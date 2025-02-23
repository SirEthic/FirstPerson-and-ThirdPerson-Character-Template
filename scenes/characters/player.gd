class_name Player
extends Character

@export var sensitivity : float = 0.001
@export var jump_velocity : float = 4.5
@export var speed : float = 3.0
@export var sprint_speed : float = 6.0

@onready var character_model: Node3D = $CharacterModel
@onready var first_person_camera: Camera3D = $Head/FirstPersonCamera
@onready var head: Node3D = $Head
@onready var third_person_camera: Camera3D = $Head/ThirdPersonCamera

var is_first_person : bool = false
var is_third_person : bool = true

var current_speed = speed

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	gravity(delta)
	handle_input(delta)
	handle_animations()
	move_and_slide()

func camera() -> void:
	if is_third_person:
		third_person_camera.current = false
		third_person_camera.visible = false
		
		first_person_camera.current = true
		first_person_camera.visible = true
		
		is_third_person = false
		is_first_person = true
	elif is_first_person:
		third_person_camera.current = true
		third_person_camera.visible = true
		
		first_person_camera.current = false
		first_person_camera.visible = false
		
		is_third_person = true
		is_first_person = false

func _unhandled_input(event):
	if Input.is_action_just_pressed("Camera"):
		camera()
	
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * sensitivity)
		third_person_camera.rotate_x(-event.relative.y * sensitivity)
		first_person_camera.rotate_x(-event.relative.y * sensitivity)
		third_person_camera.rotation.x = clamp(third_person_camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))
		first_person_camera.rotation.x = clamp(third_person_camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func handle_input(delta) -> void:
	
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_velocity
		current_state = State.JUMP
	
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Back")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
		
		character_model.rotation.y = lerp_angle(character_model.rotation.y, atan2(direction.x, direction.z), delta * 8.0)
		
		current_state = State.WALK
		
		if Input.is_action_pressed("Sprint"):
			current_speed = sprint_speed
			current_state = State.RUN
		else:
			current_speed  = speed
			current_state = State.WALK
	else:
		velocity.x = move_toward(velocity.x , 0, current_speed)
		velocity.z = move_toward(velocity.z , 0, current_speed)
		current_state = State.IDLE
			
