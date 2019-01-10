.exportzp _buttons, graphics_need_update


.segment "ZEROPAGE"
;;; Function locals.
;;;
;;; * I really dislike the idea of an assembly program using locals,
;;;   so let's add them here and export them all to be used as locals
;;;   for functions elsewhere. This is not memory efficient but
;;;   optimizations can happen when necessary.
;;;
_buttons:    .res 1
graphics_need_update:   .res 1
