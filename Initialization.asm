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

; Initialize ADC (for randomizing), PC5
cbi DDRC, 5

; AREF, ADC5
ldi r16, 5
out ADMUX, r16
ldi r16, 0b11100101;(1<<ADEN)|(1<<ADSC)|(1<<ADIF)|(1<<ADPS0)
out ADCSRA, r16

; Variables
ldi r16, 0
sts block_y, r16
sts block_x, r16

ldi r16,0b1
sts block_color, r16

sei
