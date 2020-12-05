extends Node2D
class_name Validator

signal missed

var in_queue := []

enum validation {VALID, INVALID, NEUTRAL}

func add_note(value: int, current_beat: int):
  in_queue.append([value, (current_beat + 2) % 32])
  
func read_note(value, current_beat) -> int:
  if in_queue.size() == 0:
    return validation.NEUTRAL
  
  var awaiting = in_queue[0]
  if awaiting[0] == value && awaiting[1] == current_beat:
    in_queue.pop_front()
    return validation.VALID
  
  # check if no note is expected for this value
  var value_expected := false
  var i := 0
  while !value_expected && i < in_queue.size():
    var note = in_queue[i]
    value_expected = note[0] == value
    i += 1
  if value_expected:
    return validation.INVALID
    
  return validation.NEUTRAL

func on_beat_end(beat: int):
  if in_queue.size() > 0:
    var awaiting = in_queue[0]
    if awaiting[1] == beat:
      in_queue.pop_front()
      emit_signal("missed")
      
func clear():
  in_queue = []
