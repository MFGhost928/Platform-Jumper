extends Node2D

const IDLE_DURATION = 2

export var move_to = Vector2.RIGHT * 300
export var speed = 40

var follow = Vector2.ZERO

onready var platform = $KinematicBody2D
onready var tween = $Tween


# Called when the node enters the scene tree for the first time.
func _ready():
	_init_tween()

func _init_tween():
	var duration = move_to.length() / float(speed)
	tween.interpolate_property(platform, "position", Vector2.ZERO, move_to, duration, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT, IDLE_DURATION)
	tween.interpolate_property(platform, "position", move_to, Vector2.ZERO, duration, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT, duration + IDLE_DURATION * 2)
	tween.start()
