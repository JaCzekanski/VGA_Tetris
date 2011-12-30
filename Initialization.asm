START:
;Just to be sure
cli

; Stack, MUST BE INITIALIZED
; for interrupts, rcalls, etc
ldi r16, high(RAMEND)
out SPH, r16
ldi r16, low(RAMEND)
out SPL, r16

; Because r0:r1 is used in multiplication

; R2 is always 0
clr r2

; R3 is always 0xff
ser r16
mov r3, r16


; Init UART at 57600bps
rcall UART_init

; Initialize pad
rcall PAD_init

rcall RANDOM_init

; Init Video
rcall VIDEO_init


; Init sound
; Timer2 as PWM
ldi r16, (1<<WGM21) | (1<<WGM20) | (1<<COM21) | (1<<CS20)
out TCCR2, r16

ldi r16, 0
out OCR2, r16

sbi DDRB, 3

; Variables
ldi r16, 0
sts block_y, r16
ldi r16, 5+X_DELTA
sts block_x, r16

ldi r16,0b1
sts block_color, r16

sei
