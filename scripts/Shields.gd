extends Control
class_name Shield

onready var shields := [$Shield, $Shield2, $Shield3, $Shield4]
var qt := 0

func add_shield():
  qt = int(min(4, qt+1))
  shields[qt-1].visible = true

func remove_shield():
  qt = int(max(0, qt-1))
  shields[qt].visible = false

func has_shield():
  return qt > 0

func clear():
  qt = 0
  for s in shields:
    s.visible = false
