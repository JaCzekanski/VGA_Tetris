.org 0x13

/*
 Main interrupt

 4 ticks - enter
 4 ticks - reti
 Leaves 636-8 = 628

 Registers used:

 r21 - Used internally by ISR
 r22 - Used internally by ISR
 r23 - VSYNC (tells if you can render graphics)
 r24 - LINEl 
 r25 - LINEh
 r28 Yl - Graphics pointer
 r29 Yh - Graphics pointer
*/
VIDEO_isr:
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; Cykle policzone, dziala
	; HFP 12-4 = 8 cycles

	in r22, sreg ;1
	push r22     ;2


	; Timer si� waha o 1 jednostke, to powoduje zygzaki na ekranie
	; Trzeba to wykry� i skorygowa�
	cpi r22, 11   ;1
	brlo delay2     ;1/2
delay2:
	cpi r22, 12   ;1
	brlo delay3     ;1/2
delay3:
	

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; Cyke policzone, dziala
	; HSP, 76 cycles
	cbi PORTB, 2  ;2

	inc LINEl  ;1
	breq inc_lineh  ;1/2   if overflow

	rjmp _inc_lineh ;2

inc_lineh:
	inc LINEh ;1
_inc_lineh:

	; if ( line>524 ) line = 0
	ldi r22, HIGH(524); ;1
	cpi LINEl, LOW(524) ;1
	cpc LINEh, r22      ;1
	breq line_ovf       ;1/2

	nop
	rjmp _line_ovf      ;2


line_ovf:
	clr LINEh  ;1
	clr LINEl  ;1
_line_ovf:

	mov r22, r16
	delay200ns 15
	mov r16, r22

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; HBP, 36 cycles
	sbi PORTB, 2  ;2

	ldi r22, HIGH( 480 )  ;1
	cpi LINEl, LOW( 480 ) ;1
	cpc LINEh, r22        ;1

	brsh DRAW_BLANK       ;1/2

	rjmp DRAW_LINE        ;2
DRAW_BLANK: 
	; Reset data pointer
	clr Yh
	ldi Yl, 1

	ldi r22, HIGH( 491 )  ;1
	cpi LINEl, LOW( 491 ) ;1
	cpc LINEh, r22        ;1

	breq SET_VSYNC        ;1/2

	ldi r22, HIGH( 492 )  ;1
	cpi LINEl, LOW( 492 ) ;1
	cpc LINEh, r22        ;1

	breq CLEAR_VSYNC      ;1/2
	nop

	rjmp _VSYNC           ;2

SET_VSYNC:
	cbi PORTB, 1          ;2   
	ser VSYNC 
	rjmp _VSYNC           ;2

CLEAR_VSYNC:	
	sbi PORTB, 1          ;2 
	clr VSYNC 
	rjmp _VSYNC           ;2


_VSYNC:
	pop r22               ;2
	out sreg, r22         ;1
	reti                  ;4


DRAW_LINE:

		; 28 cycles left

		mov r21, LINEl    ;1 ; wystarczy sprawdzic 0bxxxxx, to dowiemy sie x%32
		andi r21, 0b1111  ;1 

		breq inc_pointer  ;1/2 ; jezeli zero to

		nop               ;1
		rjmp _inc_pointer ;2

	inc_pointer:
		adiw Y, 32	  ;2
	_inc_pointer:

		push Yl
		push Yh

		;; Begining of SRAM
		adiw Y, 0x30
		adiw Y, 15

		ldi r22, 32 ;;;;;;;;;;;;;;;;;;;;;; 33 !!!!!!!!!!!!!!!!
	loop_blank: 
		ld r21, Y+
		out PORTC, r21
		dec r22           ; 1 clk
		nop
		nop
		nop
		nop

		breq loop_blank_end ; 1/2 clk

		nop
		nop
		nop
		nop
		nop
		rjmp loop_blank     ; 2 clk


	loop_blank_end:	
		pop Yh ;2
		pop Yl ;2
	
		pop r22 ;2
		out sreg, r22 ;1
		out PORTC, r0 ;1	
reti

; Video
; Uses PORTC for color data (whole!)
; and PORTB for vsync and hsync  (only 2 pins)
VIDEO_init:
	clr Yh
	clr Yl

	;RGB 
	ldi r16, 0b000111
	out DDRC, r16

	; VSYNC HSYNC
	ldi r16, 0b00000110
	out DDRB, r16

	; RGB
	ldi r16, 0b110
	out PORTC, r16

	; HIGH, HSYNC, VSYNC
	ldi r16, 0b000
	out PORTB, r16


	;;;;;;;;;;;;;;;;;
	; Timer1, HBLANK
	; CTC, clk/1
	ldi r16, 0
	out TCCR1A, r16

	ldi r16, (1<<WGM12)|(1<<CS10)
	out TCCR1B, r16

	; 636 ticks
	ldi r16, HIGH(HLINE_CLOCKS)
	out OCR1AH, r16
	ldi r16, LOW(HLINE_CLOCKS)
	out OCR1AL, r16

	; Enable CTC interrupt
	ldi r16, (1<<OCIE1A)
	out TIMSK, r16

	ret
