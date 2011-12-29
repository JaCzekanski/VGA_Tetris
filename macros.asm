.equ HLINE_CLOCKS=636
.equ RESET=0x00

.equ F_CPU=20000000
.equ F_UART=57600

.equ PAD_LATCH=2
.equ PAD_DATA=3
.equ PAD_CLK=4
.equ PAD_PORT=PORTD
.equ PAD_PIN=PIND
.equ PAD_DDR=DDRD

.equ VIDEO_SYNC_PORT = PORTD
.equ VIDEO_SYNC_DDR = DDRD
.equ VIDEO_HSYNC = 5
.equ VIDEO_VSYNC = 6

.equ X_DELTA = 4

.def VSYNC=r23
.def LINEl=r24
.def LINEh=r25

.MACRO NOP10
	nop
	nop

	nop
	nop

	nop
	nop

	nop
	nop

	nop
	nop
.ENDMACRO

; 1st argument - x, x*200ns
; x = 5 = 1us
; Uses r16!
.MACRO delay200ns
	ldi r16, @0

	delay_loop:
		dec r16
		breq end
		rjmp delay_loop
	end:
.ENDMACRO
