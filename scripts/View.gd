extends Camera2D
class_name View

var shaking := false
var STRENGTH = 15.0

onready var timer: Timer = $Timer

func shake():
  shaking = true
  timer.start()
  yield(timer, "timeout")
  shaking = false

func _process(_delta):
  if shaking:
    position = Vector2(randf()*STRENGTH, randf()*STRENGTH)
    
