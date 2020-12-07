extends Control
class_name Visualizer

onready var bottom_pipe: Pipe = $Bottom
onready var left_pipe: Pipe = $Left
onready var right_pipe: Pipe = $Right
onready var top_pipe: Pipe = $Top

onready var bottom_center: ColorRect = $Center/Bottom
onready var left_center: ColorRect = $Center/Left
onready var right_center: ColorRect = $Center/Right
onready var top_center: ColorRect = $Center/Top
onready var center_bg: ColorRect = $Center/background

var pipes: Array
var center: Array

var progression : Progression
export(PackedScene) var progression_prefab: PackedScene

func _ready():
  pipes = [bottom_pipe, left_pipe, right_pipe, top_pipe]
  center = [bottom_center, left_center, right_center, top_center]
  
func add_note(note: int):
  var pipe: Pipe = pipes[note]
  pipe.add_line()

func clear():
  for pipe in pipes:
    pipe.clear()
  
func validate_note(note: int):
  var pipe: Pipe = pipes[note]
  pipe.remove_line()
  pipe.success()

func press(note: int):
  var position: ColorRect = center[note]
  position.visible = true
  
func release(note: int):
  var position: ColorRect = center[note]
  position.visible = false
  
func create_progression(max_score: int):
  progression = progression_prefab.instance()
  progression.init(max_score)
  $Center.add_child(progression)
  progression.connect("completed", self, "on_progression_completed")
  progression.colorize(center_bg.modulate.darkened(0.3))

func progress():
  progression.progress()
  
func reset_progress(max_score: int = 0):
  progression.reset()
  if max_score > 0:
    progression.init(max_score)
  progression.colorize(center_bg.modulate.darkened(0.3))
    
func progress_complete():
  progression.complete()

func on_progression_completed(prog: Progression):
  $Center.remove_child(prog)

func colorize(color: Color, keep: bool = false):
  if !keep:
    center_bg.modulate = color.lightened(0.2)
  else:
    center_bg.modulate = color
