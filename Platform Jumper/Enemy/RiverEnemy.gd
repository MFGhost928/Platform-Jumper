extends KinematicBody2D


enum State {IDLING, WALKING, HURTING}

export var gravity = 3800
export var max_speed = 1200
var velocity = Vector2(0,0)
var direction = 0
var state = State.IDLING

var is_dead = false

onready var AnimatedSprite = $AnimatedSprite
onready var Timer = $Timer
onready var GroundCheckLeft = $GroundCheckLeft
onready var GroundCheckRight = $GroundCheckRight
onready var WallCheckLeft = $WallCheckLeft
onready var WallCheckRight = $WallCheckRight

export(int) var hp = 1

func _ready():
	call_deferred("set_state", State.IDLING)
	
func dead():
	hp = hp - 1
	if hp <= 0:
		is_dead = true
		velocity = Vector2(0, 0)
		$AnimatedSprite.play("hurt")
		$CollisionShape2D.disabled = true
		$Timer.start()
	
func _physics_process(delta):
	#Calculate speed in x and y directions and move
	if is_dead == false:
		velocity.x = max_speed * direction
		velocity.y += gravity * delta
		velocity = move_and_slide(velocity)
		
	if get_slide_count() > 0:
		for i in range (get_slide_count()):
			if "player" in get_slide_collision(i).collider.name:
				get_slide_collision(i).collider.dead()



func _on_Timer_timeout():
	if is_dead == false:
		if state == State.IDLING:
			set_state(State.WALKING)
		elif state == State.WALKING:
			set_state(State.IDLING)
	
	if is_dead == true:
		queue_free()


func set_state(new_state):
	if is_dead == false:
		state = new_state
	
		match state:
			State.IDLING:
				direction = 0 # stand
				AnimatedSprite.play("idle")
				Timer.start(0.5) # start timer
			State.WALKING:
				direction = check_direction()
				AnimatedSprite.play("walk")
				AnimatedSprite.flip_h = direction > 0
				Timer.start(0.5)
		
func check_direction():
	if not GroundCheckLeft.is_colliding():
		return 1
	elif not GroundCheckRight.is_colliding():
		return -1
	elif WallCheckLeft.is_colliding():
		return 1
	elif WallCheckRight.is_colliding():
		return -1
	elif direction == 0:
		return 1 if AnimatedSprite.flip_h else -1
	else:
		return direction
	


func _on_Hitbox_body_entered(body):
	if body.has_method("take_damage"):
		var bounce_force = body.global_position - self.global_position
		bounce_force = bounce_force.normalized() * 700
		body.take_damage(5, bounce_force)
