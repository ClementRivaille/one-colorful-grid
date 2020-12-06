extends Node2D
class_name Melody

signal play

var phrase := []
var waiting := 0
var playing := false
var active := false

var phrase_min_length := 3
var max_add := 2
var phrase_interval := 4
var notes_max_interval := 3
var quarter_only := true

var difficulty := 0
var difficulty_min_length := [0, 0, 1, 2, 3, 4]
var difficulty_add := [0, 2, 2, 2, 4, 0]
var difficulty_max_interval := [0, 2, 2, 3, 3, 2]
var difficulty_quarter = [true, true, true, true, false, true]

var phrase_idx := 0
var level_phrases := [
  [],
  [ [], [], [2], [2] ],
  [ [2,1], [2,1],[1,2],[1,2,2] ],
  [],
  [],
  [[2,2,1,1]]
 ]

func write_phrase():
  var phrases = level_phrases[difficulty]
  if phrase_idx < phrases.size():
    phrase = phrases[phrase_idx].duplicate()
  elif difficulty == 5:
    phrase = phrases[0].duplicate()
  else:
    phrase = []
    var length = phrase_min_length + randi()%(max_add + 1)
    for i in range(0, length):
      var interval = 1 + randi()%notes_max_interval
      
      # difficulty specific rules
      if difficulty == 1:
        # play only on beats
        interval = 2
      elif difficulty == 2:
        # no two consecutives 1
        if interval == 1 && i > 0 && phrase[i-1] == 1:
          interval = 2
      elif difficulty == 3:
        # no more than two consecutives 1
        if interval == 1 && i > 1 && phrase[i-1] == 1 && phrase[i-2] == 1:
          interval = 2 + randi()%2
        # no two consecutives 3
        elif interval == 3 && i > 0 && phrase[i-1] == 3:
          interval = 1 + randi()%2
      elif difficulty == 4:
        # 4 consecutives 1 max
        if interval == 1 && i > 3:
          var combo_breaking = false
          for j in range(i-4, i):
            combo_breaking = phrase[j] != 1 || combo_breaking
          if !combo_breaking:
            interval = 2 + randi()%2
          
      phrase.append(interval)
  
  phrase_idx += 1
  
func clear(delay: int = 0):
  phrase = []
  playing = false
  waiting = 4 + delay
  
func init():
  waiting = 6
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
        if phrase.size() > 0:
          waiting = phrase.pop_front()
        else:
          waiting = phrase_interval
          playing = false
        emit_signal("play", randi()%4)

func set_difficulty(level: int):
  difficulty = level
  phrase_min_length = difficulty_min_length[level]
  max_add = difficulty_add[level]
  notes_max_interval = difficulty_max_interval[difficulty]
  quarter_only = difficulty_quarter[level]
  phrase_idx = 0
  if level < 2:
    phrase_interval = 6
  elif level >= 5:
    phrase_interval = 1
  else:
    phrase_interval = 4
