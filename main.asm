.include "m8def.inc"
.include "macros.asm"
.cseg

.org RESET
	rjmp START
.org OC1Aaddr
	rjmp VIDEO_isr

.include "Video.asm"
.include "Initialization.asm"

/* Main program  */

	ldi r16, 241
	clr Xh
	ldi Xl, 0x60

	ClearLoop:
	st X+, r0
	st X+, r0
	st X+, r0
	st X+, r0
	dec r16            ; 1 clk
	breq ClearLoop_    ; 1/2 clk
	rjmp ClearLoop     ; 2 clk

ClearLoop_:

	; Set corners
	ldi r16, 0b1

	ldi Xl, LOW( 96 )
	ldi Xh, HIGH( 96 )
	st X, r16


	ldi r16, 0b10
	ldi Xl, LOW( 96+31)
	ldi Xh, HIGH( 96+31)
	st X, r16


	ldi r16, 0b1
	ldi Xl, LOW( 96 +(32*28) )
	ldi Xh, HIGH( 96 +(32*28))
	st X, r16

	ldi r16, 0b10
	ldi Xl, LOW( 96 +(32*28) +31)
	ldi Xh, HIGH( 96 +(32*28)+31)
	st X, r16

	ldi r16, 15
	ldi Xl, LOW( 96+9 + 32*4 )
	ldi Xh, HIGH( 96+9 + 32*4 )
hor_loop_1:

	st X+, r1

	dec r16            ; 1 clk
	breq hor_loop_1_end    ; 1/2 clk
	rjmp hor_loop_1     ; 2 clk

hor_loop_1_end:
	ldi r16, 21
	ldi Xl, LOW( 96+9 + 32*5 )
	ldi Xh, HIGH( 96+9 + 32*5 )

ver_loop:

	st X, r1
	adiw X, 14
	st X, r1
	adiw X, 18

	dec r16            ; 1 clk
	breq ver_loop_end    ; 1/2 clk
	rjmp ver_loop     ; 2 clk

ver_loop_end:

	ldi r16, 15
	ldi Xl, LOW( 96+9 + (32*26) )
	ldi Xh, HIGH( 96+9 + (32*26) )
hor_loop_2:

	st X+, r1

	dec r16            ; 1 clk
	breq InfinityLoop    ; 1/2 clk
	rjmp hor_loop_2     ; 2 clk



InfinityLoop:
	WAIT_VSYNC:
	cpi VSYNC, 0xff
	brne WAIT_VSYNC
	clr VSYNC

	rcall PAD_GetState
	;out UDR, r10

	mov r16, r5
	inc r16
	cpi r16, 10
	mov r5, r16
	breq update_block

	rjmp update_block_

	update_block:

	;; Check, if there is another block in the wall :)

	
		lds r16, block_y
		inc r16
		ldi Xl, LOW( 96+10 + (32*5) )
		ldi Xh, HIGH( 96+10 + (32*5) )


	loop_check_for_block:

		adiw X, 32

		dec r16            ; 1 clk
		breq loop_check_for_block_    ; 1/2 clk
		rjmp loop_check_for_block     ; 2 clk

	loop_check_for_block_:
		lds r16, block_x
		add Xl, r16
		adc Xh, r0
		ld r17, X

		cp r17, r0
		breq block_clear; We can go further

		; We just reset position

		mov r5, r0
		clr r16

		rjmp LimitBlockY_


block_clear:
	;; Clear previous position
		lds r16, block_y
		ldi Xl, LOW( 96+10 + (32*5) )
		ldi Xh, HIGH( 96+10 + (32*5) )


	loop_clear_block:

		adiw X, 32

		dec r16            ; 1 clk
		breq loop_clear_block_    ; 1/2 clk
		rjmp loop_clear_block     ; 2 clk

	loop_clear_block_:
		lds r16, block_x
		add Xl, r16
		adc Xh, r0
		ldi r17, 0b000
		st X, r17


		mov r5, r0
		lds r16, block_y
		inc r16

		cpi r16, 21
		brsh LimitBlockY

LimitBlockY_:

		sts block_y, r16

		sbrc r10, 0 ; Right
		rcall MoveRight
		sbrc r10, 1 ; Left
		rcall MoveLeft

		rjmp update_block_

MoveRight:
	lds r16, block_x

	cpi r16, 12
	brne MoveRightContinue

	ret

MoveRightContinue:
	inc r16
	sts block_x, r16
	ret

MoveLeft:
	lds r16, block_x
	
	cpi r16, 0
	brne MoveLeftContinue

	ret
	
MoveLeftContinue:
	dec r16
	sts block_x, r16
	ret

LimitBlockY:
	ldi r16, 0
	rjmp LimitBlockY_

LimitBlockXr:
	ldi r16, 12
	sts block_x, r16
	
	update_block_:


	lds r16, block_y
		ldi Xl, LOW( 96+10 + (32*5) )
		ldi Xh, HIGH( 96+10 + (32*5) )
	

	loop_draw_block:

		adiw X, 32

		dec r16            ; 1 clk
		breq loop_draw_block_    ; 1/2 clk
		rjmp loop_draw_block     ; 2 clk

	loop_draw_block_:
		lds r16, block_x
		add Xl, r16
		adc Xh, r0
		ldi r17, 0b001
		st X, r17


rjmp InfinityLoop


.include "Pad.asm"
.include "Uart.asm"

.dseg
.org SRAM_START+960
block_y: .BYTE 1
block_x: .BYTE 1
