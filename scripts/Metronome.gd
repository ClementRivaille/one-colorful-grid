extends AudioStreamPlayer
class_name Metronome

signal started

export var bpm := 115

func _ready():
  pass

func play(from: float = 0.0):
  .play(from)
  emit_signal("started")
