START:
;Just to be sure
cli

; Stack, MUST BE INITIALIZED
; for interrupts, rcalls, etc
ldi r16, high(RAMEND)
out SPH, r16
ldi r16, low(RAMEND)
out SPL, r16

; R0 is always 0
clr r0

; R1 is always 0xff
ser r16
mov r1, r16

; Init Video
rcall VIDEO_init

; Init UART at 57600bps
rcall UART_init

; Initialize pad
rcall PAD_init

; Variables
ldi r16, 0
sts block_y, r16
sts block_x, r16

sei
