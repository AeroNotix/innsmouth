.exportzp buttons, x_pos, y_pos, graphics_need_update


.segment "ZEROPAGE"
;;; Function locals.
;;;
;;; * I really dislike the idea of an assembly program using locals,
;;;   so let's add them here and export them all to be used as locals
;;;   for functions elsewhere. This is not memory efficient but
;;;   optimizations can happen when necessary.
;;;
buttons = 0
x_pos = 1
y_pos = 2
graphics_need_update = 3
;;; Global variables
