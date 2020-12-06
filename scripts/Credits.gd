extends Control
class_name Credits

onready var tween: Tween = $Tween
onready var background: ColorRect = $Background

func init():
  background.color = Color(1,1,1)
  tween.interpolate_property(self, "modulate",
    Color(1,1,1,0), Color(1,1,1,1),
    1.7, Tween.TRANS_SINE, Tween.EASE_OUT)
  tween.start()

func display_title():
  background.color = Color(0,0,0)
  
func hide():
  modulate = Color(1,1,1,0)
