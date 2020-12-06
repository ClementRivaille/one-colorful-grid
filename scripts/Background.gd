extends ColorRect
class_name Background

onready var tween: Tween = $Tween

func set_color(value: Color):
  tween.interpolate_property(self, "color", color, value, 0.4, Tween.TRANS_SINE, Tween.EASE_OUT)
  tween.start()
