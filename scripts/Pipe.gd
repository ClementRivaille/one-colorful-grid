extends Control
class_name Pipe

var duration := 60.0 / 115.0

export(PackedScene) var line_prefab: PackedScene
export(Color) var line_color := Color(1,1,1,1)
onready var success_bar: ColorRect = $success

onready var lines: Control = $Lines
onready var tween: Tween = $Tween

func _ready():
  success_bar.color = line_color.lightened(0.5)

func add_line(fast: bool = false):
  var line: ColorRect = line_prefab.instance()
  line.color = line_color
  lines.add_child(line)
  var line_tween: Tween = line.get_child(0)
  var trans: int = { false: Tween.TRANS_LINEAR, true: Tween.TRANS_SINE }[fast]
  line_tween.interpolate_property(line, "anchor_left",
    0.0, 1.0,
    duration, trans, Tween.EASE_IN)
  line_tween.start()

func clear():
  while lines.get_child_count() > 0:
    remove_line()

func remove_line():
  if lines.get_child_count() > 0:
    var line: ColorRect = lines.get_child(0)
    var tween:Tween = line.get_child(0)
    tween.stop_all()
    lines.remove_child(line)
    
func success():
  tween.interpolate_property(success_bar, "modulate",
    Color(1,1,1,0.4), Color(1,1,1,0),
    0.4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
  tween.start()
