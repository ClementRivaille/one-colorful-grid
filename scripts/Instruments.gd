extends Node2D
class_name Instruments

onready var lead: Multisampler = $Lead

var lead_notes := [
  [["A", 3], ["C", 4], ["E", 4], ["A", 4]],
  [["C", 4], ["E", 4], ["G", 4], ["C", 5]],
  [["F", 3], ["A", 3], ["C", 4], ["F", 4]],
  [["E", 3], ["Ab", 3], ["B", 3], ["D", 4]]
]

func play_lead(bar: int, note_idx: int):
  var notes: Array = lead_notes[bar]
  var note: Array = notes[note_idx]
  lead.play_note(note[0], note[1])
