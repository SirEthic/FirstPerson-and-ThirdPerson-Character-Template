class_name Character
extends CharacterBody3D

const GRAVITY := 9.8

@export var can_respawn : bool

@onready var animation_player: AnimationPlayer = $CharacterModel/Character/AnimationPlayer

enum State {IDLE, WALK, RUN, CROUCH, STRAFE_LEFT, STRAFE_RIGHT}

var anim_map : Dictionary = {
	State.IDLE : "Idle",
	State.WALK : "Walk",
	State.RUN : "Run",
	State.CROUCH : "Crouch_Idle",
	State.STRAFE_LEFT : "Strafe_Left",
	State.STRAFE_RIGHT : "Strafe_Right",
}

var current_state = State.IDLE

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	gravity(delta)
	handle_input(delta)
	handle_animations()

func gravity(delta) -> void:
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

func handle_input(_delta) -> void:
	pass

func handle_animations() -> void:
	if animation_player.has_animation(anim_map[current_state]):
		animation_player.play(anim_map[current_state])
