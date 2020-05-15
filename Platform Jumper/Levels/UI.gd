extends CanvasLayer



var redBar : = preload("res://Images/Bar/bar_red_200.png")
var yellowBar : = preload("res://Images/Bar/bar_yellow_200.png")
var greenBar : = preload("res://Images/Bar/bar_green_200.png")
var bar_texture
var current_health = 0

onready var labelScore : = $HBoxContainer/Score
onready var _healthBar : = $CenterContainer/healthBar


func update_healthbar(value):
	current_health = value
	bar_texture = greenBar
	if value < 60:
		bar_texture = yellowBar
	if value < 25:
		bar_texture = redBar
	$MarginContainer/HBoxContainer/HealthBar.texture_progress = bar_texture
	$MarginContainer/HBoxContainer/HealthBar/Tween.interpolate_property(
		$MarginContainer/HBoxContainer/HealthBar, 'value', 
		$MarginContainer/HBoxContainer/HealthBar.value, value,
		0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$MarginContainer/HBoxContainer/HealthBar/Tween.start()
	$AnimationPlayer.play("healthbar_flash")
	#$MarginContainer/HBoxContainer/HealthBar.value = value

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "healthbar_flash":
		$MarginContainer/HBoxContainer/HealthBar.texture_progress = bar_texture

