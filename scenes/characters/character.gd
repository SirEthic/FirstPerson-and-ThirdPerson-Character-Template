class_name Character
extends CharacterBody3D

const GRAVITY := 9.8

@export var can_respawn : bool

@onready var animation_player: AnimationPlayer = $CharacterModel/Character/AnimationPlayer

enum State {IDLE, WALK, RUN, JUMP, CROUCHING, CROUCH_IDLE, CROUCH_WALK, AIM}

var anim_map : Dictionary = {
	State.IDLE : "Idle",
	State.WALK : "Walk",
	State.RUN : "Run",
	State.JUMP : "Idle",
	State.CROUCHING : "Crouch",
	State.CROUCH_IDLE : "Crouch_Idle",
	State.CROUCH_WALK : "Crouch_Walk",
	State.AIM : "Aim",
	
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
	var target_animation = anim_map[current_state]
	
	if animation_player.has_animation(target_animation):
		if animation_player.current_animation != target_animation:
			animation_player.play(target_animation, 0.25)
