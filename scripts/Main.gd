extends Control

onready var music: Music = $Music
onready var instrument: Instruments = $Instruments
onready var melody = $Melody
onready var visualizer: Visualizer = $Visualizer
onready var validator: Validator = $Validator
onready var sfx: SFX = $SFX
onready var shields: Shield = $Shields
onready var background: Background = $Background
onready var view: View = $View
onready var credits: Credits = $Credits
onready var title: Control = $Title

var playing := false

var level := 0
var completion_needed := 0
var level_completions := [0,8,16,32,32,4]
var free_mode := false

export(Array, Color) var level_colors: Array

var LAST_LEVEL := 5
var last_bar := false
var beats_end := 0

func _ready():
  randomize()
  Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

  music.connect("beat", melody, "on_beat")
  melody.connect("play", self, "play_lead")
  music.connect("beat_ended", validator, "on_beat_end")
  validator.connect("missed", self, "on_miss")
  melody.init()
  visualizer.colorize(level_colors[0])
  
func _input(event: InputEvent):
  if event.is_action_pressed("ui_accept"):
    if !playing:
      music.start()
      start_game()
      visualizer.create_progression(completion_needed)
    elif level == 0:
      start_game()
      visualizer.reset_progress(completion_needed)
    elif free_mode:
      exit_freemode()
      
  if event.is_action_pressed("ui_cancel"):
    get_tree().call_deferred("quit")
  if event.is_action_pressed("fullscreen"):
    OS.window_fullscreen = !OS.window_fullscreen
    
  if playing && level > 0:
    if event.is_action_pressed("ui_down"):
      play_note(0)
    if event.is_action_pressed("ui_left"):
      play_note(1)
    if event.is_action_pressed("ui_right"):
      play_note(2)
    if event.is_action_pressed("ui_up"):
      play_note(3)
    
  if event.is_action_released("ui_down"):
    visualizer.release(0)
  if event.is_action_released("ui_left"):
    visualizer.release(1)
  if event.is_action_released("ui_right"):
    visualizer.release(2)
  if event.is_action_released("ui_up"):
    visualizer.release(3)
      
func start_game():
  level = 1
  title.visible = false
  setup_level()
  melody.init()
  shields.add_shield()
  playing = true

func play_lead(note_idx: int):
  instrument.play_lead(music.current_bar, note_idx)
  visualizer.add_note(note_idx)
  validator.add_note(note_idx, music.get_active_beat())
  
func play_note(value: int):
  visualizer.press(value)
  if !free_mode:
    var valid = validator.read_note(value, music.get_active_beat())
    if valid == Validator.validation.INVALID:
      on_miss()
    elif valid == Validator.validation.VALID:
      validate_note(value)
  else:
    visualizer.validate_note(value)
    instrument.play_player(music.current_bar, value)

func on_miss():
  sfx.play_error()
  visualizer.clear()
  validator.clear()
  melody.clear()
  view.shake()
  
  if shields.has_shield() && level < LAST_LEVEL:
    shields.remove_shield()
  else:
    if level == LAST_LEVEL:
      cancel_end()

    level -= 1
    setup_level()
    
    if level == 0:
      melody.deactivate()
      visualizer.reset_progress()
      title.visible = true
    else:
      visualizer.reset_progress(completion_needed)

func validate_note(value: int):
  visualizer.validate_note(value)
  instrument.play_player(music.current_bar, value)
  
  if level < LAST_LEVEL:
    completion_needed -= 1
    visualizer.progress()
    if completion_needed <= 0:
      visualizer.clear()
      validator.clear()
      melody.clear(2)
      
      level += 1
      sfx.play_success()
      setup_level()
      
      visualizer.progress_complete()
      visualizer.create_progression(completion_needed)
      
      if level == LAST_LEVEL:
        setup_end()
      else:
        shields.add_shield()

func setup_level():
  music.set_layer(level)
  completion_needed = level_completions[level]
  melody.set_difficulty(level)
  background.set_color(level_colors[level])
  instrument.change_instruments(level)
  if level < LAST_LEVEL:
    visualizer.colorize(level_colors[level])
  else:
    visualizer.colorize(Color(0,0,0), true)

func setup_end():
  music.trigger_end()
  last_bar = false
  beats_end = 0
  music.connect("beat_ended", self, "on_end_beat")
  music.connect("end", self, "on_end_loop")
  
func cancel_end():
  music.cancel_end()
  music.disconnect("beat_ended", self, "on_end_beat")
  music.disconnect("end", self, "on_end_loop")
  
func on_end_beat(beat):
  beats_end += 1
  if last_bar:
    if beat == 29:
      melody.clear()
    if beat == 31:
      end()
  
func on_end_loop():
  if beats_end > 16:
    last_bar = true  

func end():
  music.validate_end()
  music.disconnect("beat_ended", self, "on_end_beat")
  music.disconnect("end", self, "on_end_loop")
  melody.deactivate()
  
  music.connect("end", self, "start_credits")
  
func start_credits():
  music.disconnect("end", self, "start_credits")
  credits.init()
  yield(music, "bar")
  credits.display_title()
  yield(music, "bar")
  yield(music, "bar")
  credits.display_colorful_dimension()
  yield(music, "bar")
  yield(music, "bar")
  credits.display_jam()
  yield(music, "bar")
  yield(music, "bar")
  if shields.qt < 4:
    credits.display_bonus()
    music.stop_after_loop()
  else:
    credits.display_free_mode()
    free_mode = true

  yield(music, "end")
  if !free_mode: 
    sfx.play_end()
    start_over()
  else:
    enter_freemode()
  
func start_over():
  playing = false
  level = 0
  background.color = level_colors[0]
  visualizer.colorize(level_colors[0])
  
  last_bar = false
  beats_end = 0
  title.visible = true
  
  music.reset()
  shields.clear()
  credits.hide()
  
func enter_freemode():
  background.color = level_colors[6]
  visualizer.colorize(level_colors[6])
  instrument.change_instruments(4)
  credits.hide()
  last_bar = false
  beats_end = 0
  free_mode = true
  
func exit_freemode():
  level = 0
  setup_level()
  music.reset_track_speed()
  title.visible = true
  shields.clear()
  free_mode = false
