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

	rcall ClearScreen
	rcall DebugDrawCorners
	rcall DrawMap

InfinityLoop:
	cpi VSYNC, 0xff
	brne InfinityLoop
	clr VSYNC


	; Input

	rcall PAD_GetState


	sbrc r10, 4 ; Start
	rcall ClearMap
	sbrc r10, 0 ; Right
	rcall MoveRight
	sbrc r10, 1 ; Left
	rcall MoveLeft
	sbrc r10, 2 ; Down
	rcall MoveDown
;	sbrc r10, 7 ; A
	;rcall check_move_down
	mov r11, r10


	; 500ms between block moves
	mov r16, r5
	inc r16
	cpi r16, 30
	mov r5, r16
	breq update_block

	rjmp InfinityLoop

	update_block:
		mov r5, r0 ; reset counter

	;; Check for collision below


		push r0
		push r1

			lds r16, block_y
			inc r16

			ldi r17, 32

			mul r16, r17

			ldi Xl, LOW( 96+10 + (32*5) )
			ldi Xh, HIGH( 96+10 + (32*5) )
			add r0, Xl
			adc r1, Xh


			mov Xh, r1
			mov Xl, r0

		pop r1
		pop r0



			lds r16, block_x
			ldi r17, 0
			add Xl, r16
			adc Xh, r17

		ld r17, X
		cp r17, r0

		breq block_clear; We can go further

	; Collision

	; We just reset position

	sts block_y, r0

	ldi r16, 6
	sts block_x, r16

	; And random new color
	rcall RANDOM_get

	sts block_color, r16
	andi r16, 0b111
	breq random_inc

	sts block_color, r16
	rjmp MainLoop_Redraw

random_inc:
	inc r16
	sts block_color, r16
	rjmp MainLoop_Redraw

block_clear:
	ldi r16, 0
	rcall SetBlock

	lds r16, block_y
	inc r16

	cpi r16, 21
	brsh LimitBlockY
	sts block_y, r16
	rjmp MainLoop_Redraw

LimitBlockY:
	ldi r16, 0
	sts block_y, r16
	rjmp MainLoop_Redraw
	
MainLoop_Redraw:
	lds r16, block_color
	rcall SetBlock

rjmp InfinityLoop



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; r16 - color
SetBlock:

	push r16
	lds r16, block_y
		ldi Xl, LOW( 96+10 + (32*5) )
		ldi Xh, HIGH( 96+10 + (32*5) )

	cpi r16, 0
	breq loop_SetBlock
	
	loop_SetBlock:

		adiw X, 32

		dec r16            ; 1 clk
		breq loop_SetBlock_    ; 1/2 clk
		rjmp loop_SetBlock     ; 2 clk

	loop_SetBlock_:
		lds r16, block_x
		add Xl, r16
		ldi r16, 0
		adc Xh, r16
		pop r16
		st X, r16

		ret



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MoveRight:
		sbrs r11, 0 
		rjmp MoveRight_Begin
		ret

MoveRight_Begin:

	lds r16, block_x

	cpi r16, 12
	brne MoveRightContinue

	ret

MoveRightContinue:

	ldi r16, 0  ; Delete prev block
	rcall SetBlock

	lds r16, block_x
	inc r16
	sts block_x, r16

	lds r16, BLOCK_COLOR ; Set curr block
	rcall SetBlock

	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MoveLeft:
		sbrs r11, 1 ; A
		rjmp MoveLeft_Begin
		ret

MoveLeft_Begin:

	lds r16, block_x
	
	cpi r16, 0
	brne MoveLeftContinue

	ret
	
MoveLeftContinue:
	
	ldi r16, 0  ; Delete prev block
	rcall SetBlock

	lds r16, block_x
	dec r16
	sts block_x, r16

	lds r16, BLOCK_COLOR ; Set curr block
	rcall SetBlock

	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MoveDown:
		;sbrs r11, 2 
		rjmp MoveDown_Begin
		ret

MoveDown_Begin:

	lds r16, block_y

	cpi r16, 20
	brne MoveDownContinue

	ret

MoveDownContinue:

	ldi r16, 0  ; Delete prev block
	rcall SetBlock

	lds r16, block_y
	inc r16
	sts block_y, r16

	lds r16, BLOCK_COLOR ; Set curr block
	rcall SetBlock

	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
/*check_move_down:
		sbrs r11, 7 ; A
		rcall MoveDown
		ret

MoveDown:
			push r0
			push r1



			lds r16, block_y
			ldi r17, 32
			mul r16, r17 ; 32*y ->r0:r1

				ldi Xl, LOW( 96+10 + (32*5) )
				ldi Xh, HIGH( 96+10 + (32*5) )
				
			add r0, Xl
			adc r1, Xh


			mov Xh, r1
			mov Xl, r0

			lds r16, block_x
			ldi r17, 0
			add Xl, r16
			adc Xh, r17


			;; We've got multipled y pos

			ldi r18, 21
			lds r16, block_y
			sub r18, r16

			MoveDown_loop:
				adiw X, 32
				ld r17, X

				cpi r17, 0
				brne MoveDownStop 

		MoveDownStop_:
				inc r16            ; 1 clk
				cp r16, r19
				breq MoveDown_loop_    ; 1/2 clk
				rjmp MoveDown_loop     ; 2 clk

			MoveDown_loop_:
				pop r1
				pop r0
				ret

			MoveDownStop:
				push r16
				clr r16
				rcall SetBlock
				pop r16
				sts block_y, r16

				lds r16, block_color
				rcall SetBlock

				ldi r16, 0
				sts block_y, r16


	ldi r16, 6
	sts block_x, r16


				rjmp MoveDown_loop_



*/

/*
		DrawMap
*/
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DrawMap:
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
		breq DrawMap_    ; 1/2 clk
		rjmp hor_loop_2     ; 2 clk

DrawMap_:
	ret


/*
		DebugDrawCorners
*/
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DebugDrawCorners:
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

	ret

/*
		ClearScreen
*/
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ClearScreen:
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
	ret


/*
		ClearMap
*/
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

.include "Random.asm"
.include "Pad.asm"
.include "Uart.asm"

.dseg
.org SRAM_START+960
block_y: .BYTE 1
block_x: .BYTE 1
block_color: .BYTE 1
