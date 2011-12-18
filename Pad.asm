; No args

; Information about buttons is stored in R10
PAD_init:
	sbi DDRD, PAD_LATCH
	cbi DDRD, PAD_DATA
	sbi DDRD, PAD_CLK

	cbi PORTD, PAD_LATCH
	sbi PORTD, PAD_CLK
	sbi PORTD, PAD_DATA
	ret

; Reads pad state
; return r10 - pad1_byte
; 0bB A S S U D L R
;       e t p o e i
;       l a   w f g
;       e r   n t h
;       c t       t
;       t
PAD_GetState:
		push r16
		push r17
		push r18

		sbi PAD_PORT, PAD_LATCH
		delay200ns 60 ;12us
		cbi PAD_PORT, PAD_LATCH

		ldi r18, 8
		clr r17
	; 8bits
	GetPadState_loop:

		delay200ns 60 ;6us
		cbi PAD_PORT, PAD_CLK
	
		sbis PAD_PIN, PAD_DATA ; pominie, jezeli nienacisniety
		rcall button_pressed

		delay200ns 60 ;6us
		sbi PAD_PORT, PAD_CLK

	GetPadState_continue:

		dec r18
		breq GetPadState_end
		lsl r17 ; xxxxxxx1 -> xxxxxx1y
		rjmp GetPadState_loop

	GetPadState_end:
	mov r10, r17

	pop r18
	pop r17
	pop r16
	ret

	button_pressed:
		ori r17, 1
		ret
