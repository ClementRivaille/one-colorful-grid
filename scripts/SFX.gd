extends Node2D
class_name SFX

func play_error():
  $error.play()

func play_success():
  $success.play()
  
func play_end():
  $end.play()
