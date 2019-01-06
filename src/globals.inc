;; -*- asm -*-
.ifndef GLOBAL_INC
.define GLOBAL_INC

;;; main.asm
.global nmi_handler, irq_handler, reset_handler

;;; graphics.asm
.global update_graphics, OAM

;;; input.asm
.global handle_input
.endif
