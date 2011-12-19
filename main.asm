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

	ldi r16, 240
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
	ldi Xl, LOW( 96 +(32*29) )
	ldi Xh, HIGH( 96 +(32*29))
	st X, r16

	ldi r16, 0b10
	ldi Xl, LOW( 96 +(32*29) +31)
	ldi Xh, HIGH( 96 +(32*29)+31)
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
	cpi r16, 5
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
		sts block_y, r16


		; And random new color

		;lds r16, block_color
		;inc r16
		in r16, ADCL
		in r17, ADCH
		sts block_color, r16
		andi r16, 0b111
		breq random_inc
random_inc_:
		sts block_color, r16

		
		clr r16

		rjmp LimitBlockY_

random_inc:
	inc r16
	rjmp random_inc_

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
		brsh LimitBlockY_branch

LimitBlockY_:

		sts block_y, r16

		sbrc r10, 4 ; Start
		rcall ClearMap
		sbrc r10, 0 ; Right
		rcall MoveRight
		sbrc r10, 1 ; Left
		rcall MoveLeft
		sbrc r10, 7 ; A
		rjmp check_move_down
		ldi r16, 0x00
		mov r11, r16

		rjmp update_block_


LimitBlockY_branch:
	rjmp LimitBlockY

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

rcall_MoveDown:
	rcall MoveDown
	rjmp check_move_down_
	
check_move_down:

		mov r16, r11
		cpi r16, 0x00 ; Pressed, not continuosly
		breq rcall_MoveDown
check_move_down_:
		ldi r16, 0xff
		mov r11, r16
		rjmp update_block_
MoveDown:
			push r0
			push r1

			lds r16, block_y
			lds r17, 32
			mul r16, r17 ; 32*y ->r0:r1

				ldi Xl, LOW( 96+10 + (32*5) )
				ldi Xh, HIGH( 96+10 + (32*5) )
				
			add r0, Xl
			adc r1, Xh

			lds r16, block_x
			ldi r17, 0
			add r0, r16
			adc r1, r17

			mov Xh, r1
			mov Xl, r0

			;; We've got multipled y pos

			ldi r16, 0

			MoveDown_loop:
				adiw X, 32
				ld r17, X

				cpi r17, 0
				brne MoveDownStop 

		MoveDownStop_:
				inc r16            ; 1 clk
				cpi r16, 21
				breq MoveDown_loop_    ; 1/2 clk
				rjmp MoveDown_loop     ; 2 clk

			MoveDown_loop_:
				pop r1
				pop r0
				ret

			MoveDownStop:
				sts block_y, r16
				rjmp MoveDown_loop_



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
		lds r17, block_color
		;ldi r17, 0b001
		st X, r17


rjmp InfinityLoop


ClearMap:
	ldi r16, 21
	ldi Xl, LOW( 96+9 + 32*5 +1)
	ldi Xh, HIGH( 96+9 + 32*5 +1)

	ClearMapLoop:
	st X+, r0
	st X+, r0
	st X+, r0
	st X+, r0
	st X+, r0
	st X+, r0
	st X+, r0
	st X+, r0
	st X+, r0
	st X+, r0
	st X+, r0
	st X+, r0
	st X, r0

	adiw X, 20

	dec r16            ; 1 clk
	breq ClearMapLoop_    ; 1/2 clk
	rjmp ClearMapLoop     ; 2 clk

ClearMapLoop_:
	sts block_y, r0

	ret


.include "Pad.asm"
.include "Uart.asm"

.dseg
.org SRAM_START+960
block_y: .BYTE 1
block_x: .BYTE 1
block_color: .BYTE 1
