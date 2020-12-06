extends Control
class_name Credits

onready var tween: Tween = $Tween
onready var background: ColorRect = $Background

onready var current_slide: Control = $itooh

func init():
  current_slide.visible = false
  background.color = Color(1,1,1)
  tween.interpolate_property(self, "modulate",
    Color(1,1,1,0), Color(1,1,1,1),
    1.7, Tween.TRANS_SINE, Tween.EASE_OUT)
  tween.start()

func display_title():
  background.color = Color(0,0,0)
  switch_slide($itooh)
func display_colorful_dimension():
  switch_slide($ColorfulDimension)
func display_jam():
  switch_slide($PotatosJam)
func display_bonus():
  switch_slide($Bonus)
func display_free_mode():
  switch_slide($FreeMode)

func switch_slide(slide: Control):
  current_slide.visible = false
  current_slide = slide
  current_slide.visible = true
  
func hide():
  modulate = Color(1,1,1,0)
  current_slide.visible = false
