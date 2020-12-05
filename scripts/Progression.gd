extends Control
class_name Progression

signal completed

var step := 0.5
var side_steps := 2
var score := 0

onready var top_bar: ColorRect = $Top
onready var right_bar: ColorRect = $Right
onready var bottom_bar: ColorRect = $Bottom
onready var left_bar: ColorRect = $Left

onready var tween:Tween = $Tween

func init(nb_steps: int):
  side_steps = nb_steps / 4
  step = 1.0 / float(side_steps)
  score = 0

func progress():
  score += 1
  if (score <= side_steps):
    top_bar.anchor_right += step
  elif score <= side_steps * 2:
    right_bar.anchor_bottom += step
  elif score <= side_steps * 3:
    bottom_bar.anchor_left -= step
  elif score <= side_steps * 4:
    left_bar.anchor_top -= step
    
func reset():
  top_bar.anchor_right = 0
  right_bar.anchor_bottom = 0
  bottom_bar.anchor_left = 1
  left_bar.anchor_top = 1
  score = 0

func complete():
  for bar in [top_bar, right_bar, bottom_bar, left_bar]:
    tween.interpolate_property(bar, "color", Color(1,1,1,1), Color(1,1,1,0), 0.5, Tween.TRANS_SINE, Tween.EASE_IN)
    tween.start()
  yield(tween, "tween_all_completed")
  emit_signal("completed", self)
