extends Node2D
class_name Melody

signal play

var phrase := []
var waiting := 0
var quarter_only := false
var playing := false
var active := false

var phrase_min_length := 3
var max_add := 2
var phrase_interval := 4
var notes_max_interval := 3

func write_phrase():
  phrase = []
  var length = phrase_min_length + randi()%(max_add + 1)
  for i in range(0, length):
    phrase.append(1 + randi()%notes_max_interval)
  
func clear():
  phrase = []
  playing = false
  waiting = phrase_interval + 2
  
func init():
  waiting = phrase_interval + 1
  playing = false
  active = true

func deactivate():
  clear()
  active = false

func on_beat(beat):
  if !active:
    return

  if waiting > 0:
    waiting -= 1
  
  if waiting == 0:
    if playing:
      emit_signal("play", randi()%4)
      if phrase.size() > 0:
        waiting = phrase.pop_front()
      else:
        playing = false
        waiting = phrase_interval
    else:
      if !quarter_only || beat % 2 == 0:
        write_phrase()
        playing = true
        waiting = phrase.pop_front()
        emit_signal("play", randi()%4)
