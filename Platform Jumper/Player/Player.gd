extends KinematicBody2D
								  
const SPEED = 400
const GRAVITY = 10
const JUMP_POWER = -500
const FLOOR = Vector2(0, -1)
const UNIT = 16
const maxHealth=100
const FIREBALL = preload("res://Player/Fireball.tscn")
var velocity = Vector2()

var on_ground = false

var is_shooting = false

var is_hurt = false

var _health = 100  
var score = 0

func _physics_process(delta):
	if is_hurt == false:
		if Input.is_action_pressed("ui_right"):
			if is_shooting == false:
				velocity.x = SPEED
				$AnimatedSprite.play("run")
				$AnimatedSprite.flip_h = false
				if sign($Position2D.position.x) == -1:
					$Position2D.position.x *= -1
		elif Input.is_action_pressed("ui_left"):
			if is_shooting == false:
				velocity.x = -SPEED
				$AnimatedSprite.play("run")
				$AnimatedSprite.flip_h = true
				if sign($Position2D.position.x) == 1:
					$Position2D.position.x *= -1
		else:
			velocity.x = 0
			if on_ground == true && is_shooting == false:
				$AnimatedSprite.play("idle")
	
		if Input.is_action_just_pressed("ui_up"):
			if is_shooting == false:
				if on_ground == true:
					velocity.y = JUMP_POWER
					on_ground = false
			
		if Input.is_action_just_pressed("shoot") && is_shooting == false:
			if is_on_floor():
				velocity.x = 0
			is_shooting = true
			$AnimatedSprite.play("fire")
			var fireball = FIREBALL.instance()
			if sign($Position2D.position.x) == 1:
				fireball.set_fireball_direction(1)
			else:
				fireball.set_fireball_direction(-1)
			get_parent().add_child(fireball)
			fireball.position = $Position2D.global_position
		
	velocity.y += GRAVITY
	
	if is_on_floor():
		if on_ground == false:
			is_shooting = false
		on_ground = true
	else:
		if is_shooting == false:
			on_ground = false
			if velocity.y < 0:
				$AnimatedSprite.play("jump")
			else:
				$AnimatedSprite.play("fall")
	
	velocity = move_and_slide(velocity, FLOOR)
	
	if get_slide_count() > 0:
		for i in range(get_slide_count()):
			if "Enemy" in get_slide_collision(i).collider.name:
				dead()
	
func dead():
	is_hurt = true
	velocity = Vector2(0, 0)
	$AnimatedSprite.play("hurt")
	$CollisionShape2D.disabled = true
	$Timer.start()

func _on_AnimatedSprite_animation_finished():
	is_shooting = false

func _ready():
	set_camera_limits()
	set_process(true)
	
func set_camera_limits():
	var tile_map = $"../TileMap" as TileMap
	if tile_map == null:
		print_debug("no")
		return
	var rect = tile_map.get_used_rect()
	var cell_size = tile_map.cell_size
	var camera = $Camera2D
	camera.limit_left = 0
	camera.limit_bottom = rect.end.y * cell_size.y
	camera.limit_right = rect.end.x * cell_size.x
	
func PieCollection():
	score += 1
	self.emit_signal('pie_collection',score)

func _on_Timer_timeout():
	get_tree().change_scene("res://GameOver.tscn")



