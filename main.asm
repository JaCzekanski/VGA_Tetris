.include "m8def.inc"
.include "macros.asm"

.dseg
.org SRAM_START+960
block_y: .BYTE 1
block_x: .BYTE 1
block_color: .BYTE 1
block_type: .BYTE 1
block_rotation: .BYTE 1
pause: .BYTE 1
gameover: .BYTE 1
score: .BYTE 1
lines: .BYTE 1
level: .BYTE 1
next: .BYTE 1

.cseg

.org RESET
	rjmp START
.org OC1Aaddr
	rjmp VIDEO_isr

.include "Video.asm"
.include "Initialization.asm"


/* Main program  */
PROGRAM_START:
	rcall DrawSplashScreen
	Splash_loop:
	cpi VSYNC, 0xff
	brne Splash_loop
	clr VSYNC

	rcall PAD_GetState
	sbrc r10, 4 ; Start
	rjmp StartGame
	sbrc r10, 6 ; Highscores
	rcall Highscores

	rjmp Splash_loop

StartGame:

	rcall ClearScreen
	rcall DebugDrawCorners
	rcall DrawMap

	mov r11, r10

	; Variables
	ldi r16, 6
	sts block_y, r16
	ldi r16, 5+X_DELTA
	sts block_x, r16

	ldi r16,0b1
	sts block_color, r16
	ldi r16, 1
	sts block_type, r16

	sts pause, r2
	sts gameover, r2
	sts SCORE, r2
	sts lines, r2
	sts level, r2

	rcall RANDOM_block
	sts block_type, r16

	rcall RANDOM_block
	sts next, r16

InfinityLoop:
	cpi VSYNC, 0xff
	brne InfinityLoop
	clr VSYNC

	/*in r16, OCR2
	cpi r16, 0xff
	breq changeto0

	ldi r16, 0xff
	out OCR2, r16

	rjmp asdasdasDAS

	changeto0:
	ldi r16, 0
	out OCR2, r16


asdasdasDAS:*/
	; Input

	rcall PAD_GetState

	sbrc r10, 5 ; Select
	rcall PROGRAM_START

	sbrc r10, 4 ; Start
	rcall PauseGame
	;sbrc r10, 5 ; Select
	;rcall RandomBlock

	lds r16, pause
	cpi r16, 0xff
	breq omnitinput

	sbrc r10, 0 ; Right
	rcall MoveRight
	sbrc r10, 1 ; Left
	rcall MoveLeft
	sbrc r10, 2 ; Down
	rcall MoveDown
	sbrc r10, 7 ; B
	rcall RotateRight
	sbrc r10, 6 ; A
	rcall RotateLeft

omnitinput:
	mov r11, r10

 	clr r6 ;  No new frame
	; 500ms between block moves

	mov r16, r5
	inc r16
	cpi r16, 30
	mov r5, r16
	breq update_block

	rjmp InfinityLoop

	update_block:
	
		lds r16, pause
		cpi r16, 0
		brne MainLoop_Redraw_tramp

		mov r6, r3 ;  New frame
		mov r5, r2 ; reset counter

		;; Check for collision below

		ldi r16, 0
		rcall ClearBlock

		lds r16, block_x
		lds r17, block_y
		inc r17

		rcall check_collision

		cpi r16, 0

		breq block_clear_tramp; We can go further
		rjmp block_clear_tramp_

MainLoop_Redraw_tramp:
 	rjmp MainLoop_Redraw

block_clear_tramp:
	rjmp block_clear

block_clear_tramp_:

		lds r16, block_color
		rcall SetBlock

	; Collision

	; Check for full lines

	;for (int y=0; y<20; y++)

		ldi r17, 0
		clr r13 ; line count

		loop_check_map:
			push r17
			rcall check_line
			pop r17

			cpi r16, 0xff
			breq check_map_linefull

		loop_check_map_continue:

			inc r17
			cpi r17, 21
			breq loop_check_map_end_tramp
			rjmp loop_check_map

loop_check_map_end_tramp:
rjmp loop_check_map_end_

	check_map_linefull:
	push r17
	inc r13

	mov r16, r17

linefull_loop:
	mov r17, r16
	push r16
	rcall MoveLine
	pop r16

	dec r16
	breq linefull_end
	rjmp linefull_loop
linefull_end:
	pop r17

	
	lds r16, lines
	inc r16
	sts lines, r16
	rjmp loop_check_map_continue

			add_single:
			lds r16, score

			ldi r17, 5
			add r16, r17

			sts score, r16
			rjmp loop_check_map_end


			add_double:
			lds r16, score

			ldi r17, 5
			add r16, r17

			sts score, r16
			rjmp loop_check_map_end


			add_triple:
			lds r16, score

			ldi r17, 5
			add r16, r17

			sts score, r16
			rjmp loop_check_map_end


			add_tetris:
			lds r16, score

			ldi r17, 5
			add r16, r17

			sts score, r16
			rjmp loop_check_map_end

level_up:
	lds r16, level
	inc r16
	sts level, r16

loop_check_map_end_:
mov r16, r13
cpi r16, 0
breq loop_check_map_end
cpi r16, 1
breq add_single
cpi r16, 2
breq add_double
cpi r16, 3
breq add_triple
cpi r16, 4
breq add_tetris

lds r16, lines
cpi r16, 0
breq loop_check_map_end
ldi r17, 30
rcall divide
cpi r17, 0
breq level_up

loop_check_map_end:
	; We just reset position

	lds r16, SCORE
	inc r16
	sts SCORE, r16

	sts block_y, r2

	ldi r16, 5+X_DELTA
	sts block_x, r16

	sts block_rotation, r2

	lds r16, next
	sts block_type, r16

	rcall RANDOM_block
	sts next, r16


	ldi Zl, LOW(2*COLORS)
	ldi Zh, HIGH(2*COLORS)

	add Zl, r16
	adc Zh, r2

	lpm r16, Z

	sts block_color, r16

	; if collision, end of game
	lds r16, block_x
	lds r17, block_y
	inc r17
	inc r17
	rcall check_collision
	cpi r16, 0xff
	breq _GameOver

	rjmp MainLoop_Redraw


_GameOver:
;rcall ClearScreen
sts pause, r3
sts gameover, r3
rjmp InfinityLoop

block_clear:

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

	lds r16, gameover
	cpi r16, 0xff
	breq DrawGameover

	lds r16, pause
	cpi r16, 0xff
	breq DrawPause
	brne DrawEmpty
	
DrawPause:

	ldi Zl, LOW(stringPauza*2)
	ldi Zh, HIGH(stringPauza*2)

	rjmp drawstrings_Cont
DrawEmpty:
	ldi Zl, LOW(stringEmpty*2)
	ldi Zh, HIGH(stringEmpty*2)
	rjmp drawstrings_Cont
	
	DrawGameover:
	ldi Zl, LOW(stringGameover*2)
	ldi Zh, HIGH(stringGameover*2)

drawstrings_Cont:
	ldi r16, 10
	ldi r17, 2
	rcall DrawString


	ldi r16, 18
	ldi r17, 4
	ldi Zl, LOW(stringWynik*2)
	ldi Zh, HIGH(stringWynik*2)
	rcall DrawString


	ldi r16, 24
	ldi r17, 6
	lds r18, SCORE
	rcall DrawNumber

	ldi r16, 18
	ldi r17, 8
	ldi Zl, LOW(stringLinie*2)
	ldi Zh, HIGH(stringLinie*2)
	rcall DrawString

	ldi r16, 24
	ldi r17, 10
	lds r18, lines
	rcall DrawNumber
	

	ldi r16, 17
	ldi r17, 13
	ldi Zl, LOW(stringNastepny*2)
	ldi Zh, HIGH(stringNastepny*2)

	rcall DrawString

	lds r16, block_x
	lds r17, block_y
	lds r18, block_type
	lds r19, block_rotation

	push r16
	push r17
	push r18
	push r19

	ldi r16, 20
	ldi r17, 12
	ldi r19, 0

	sts block_rotation, r19
	sts block_type, r18
	sts block_y, r17
	sts block_x, r16

	rcall ClearBlock

	lds r18, next
	sts block_type, r18

	rcall SetBlock

	pop r19
	pop r18
	pop r17
	pop r16

	sts block_rotation, r19
	sts block_type, r18
	sts block_y, r17
	sts block_x, r16

	/*ldi r16, 18
	ldi r17, 12
	ldi Zl, LOW(stringPoziom*2)
	ldi Zh, HIGH(stringPoziom*2)

	rcall DrawString

	ldi r16, 24
	ldi r17, 14
	lds r18, level
	rcall DrawNumber*/

rjmp InfinityLoop



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; r16 - color
SetBlock:

	push r16
	lds r16, block_y
		ldi Xl, LOW( 96+MAP_X+1 + (SCREEN_WIDTH*5) - X_DELTA)
		ldi Xh, HIGH( 96+MAP_X+1 + (SCREEN_WIDTH*5) - X_DELTA )

	cpi r16, 0
	breq loop_SetBlock_
	
	loop_SetBlock:

		adiw X, SCREEN_WIDTH

		dec r16            ; 1 clk
		breq loop_SetBlock_    ; 1/2 clk
		rjmp loop_SetBlock     ; 2 clk

	loop_SetBlock_:


		lds r16, block_x
		add Xl, r16
		ldi r16, 0
		adc Xh, r16
		pop r16
		

		ldi Zl, LOW(2*BLOCK_START)
		ldi Zh, HIGH(2*BLOCK_START)

		ldi r18, 64
		lds r17, block_type
		; block type * 16
		; 4x line
		mul r17, r18

		
		lds r18, block_rotation
		lsl r18
		lsl r18
		lsl r18
		lsl r18
		add r0, r18
		adc r1, r2

		add Zl, r0
		adc Zh, r1



		ldi r17, 4
	loop_DrawBlock:
		lpm r18, Z+
		
		cpse r18, r2
		rcall SetPixel
		adiw X, 1

		lpm r18, Z+
		cpse r18, r2
		rcall SetPixel
		adiw X, 1

		lpm r18, Z+
		cpse r18, r2
		rcall SetPixel
		adiw X, 1

		lpm r18, Z+
		cpse r18, r2
		rcall SetPixel
		
		adiw X, SCREEN_WIDTH-3

		dec r17
		breq SetBlock_End
		rjmp loop_DrawBlock

		SetBlock_End:
		ret


SetPixel:
	st X, r18
	ret

	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; r16 - color
ClearBlock:

	push r16
	lds r16, block_y
		ldi Xl, LOW( 96+MAP_X+1 + (SCREEN_WIDTH*5) - X_DELTA)
		ldi Xh, HIGH( 96+MAP_X+1 + (SCREEN_WIDTH*5) - X_DELTA )

	cpi r16, 0
	breq loop_ClearBlock_
	
	loop_ClearBlock:

		adiw X, SCREEN_WIDTH

		dec r16            ; 1 clk
		breq loop_ClearBlock_    ; 1/2 clk
		rjmp loop_ClearBlock     ; 2 clk

	loop_ClearBlock_:


		lds r16, block_x
		add Xl, r16
		ldi r16, 0
		adc Xh, r16
		pop r16
		

		ldi Zl, LOW(2*BLOCK_START)
		ldi Zh, HIGH(2*BLOCK_START)

		ldi r18, 64
		lds r17, block_type
		; block type * 16
		; 4x line
		mul r17, r18

		
		lds r18, block_rotation
		lsl r18
		lsl r18
		lsl r18
		lsl r18
		add r0, r18
		adc r1, r2

		add Zl, r0
		adc Zh, r1



		ldi r17, 4
	loop_Draw_ClearBlock:
		lpm r18, Z+
		
		cpse r18, r2
		rcall SetPixel2
		adiw X, 1

		lpm r18, Z+
		cpse r18, r2
		rcall SetPixel2
		adiw X, 1

		lpm r18, Z+
		cpse r18, r2
		rcall SetPixel2
		adiw X, 1

		lpm r18, Z+
		cpse r18, r2
		rcall SetPixel2
		
		adiw X, SCREEN_WIDTH-3

		dec r17
		breq ClearBlock_End
		rjmp loop_Draw_ClearBlock

		ClearBlock_End:
		ret


SetPixel2:
	st X, r2
	ret
/*
SetBlock:

	push r16
	lds r16, block_y
		ldi Xl, LOW( 96+MAP_X+1 + (SCREEN_WIDTH*5) - X_DELTA)
		ldi Xh, HIGH( 96+MAP_X+1 + (SCREEN_WIDTH*5) - X_DELTA )

	cpi r16, 0
	breq loop_SetBlock_
	
	loop_SetBlock:

		adiw X, SCREEN_WIDTH

		dec r16            ; 1 clk
		breq loop_SetBlock_    ; 1/2 clk
		rjmp loop_SetBlock     ; 2 clk

	loop_SetBlock_:


		lds r16, block_x
		add Xl, r16
		ldi r16, 0
		adc Xh, r16
		pop r16
		

		ldi Zl, LOW(2*BLOCK_START)
		ldi Zh, HIGH(2*BLOCK_START)

		lds r17, block_type
		; block type * 16
		; 4x line
		lsl r17
		lsl r17
		lsl r17
		lsl r17

		
		lds r18, block_rotation
		lsl r18
		lsl r18
		add r17, r18

		add Zl, r17
		adc Zh, r2



		ldi r17, 4
	loop_DrawBlock:
		lpm r18, Z+

		sbrc r18, 3
		rcall SetPixel
		adiw X, 1

		sbrc r18, 2
		rcall SetPixel
		adiw X, 1

		sbrc r18, 1
		rcall SetPixel
		adiw X, 1

		sbrc r18, 0
		rcall SetPixel
		
		adiw X, SCREEN_WIDTH-3

		dec r17
		breq SetBlock_End
		rjmp loop_DrawBlock

		SetBlock_End:
		ret


SetPixel:
	st X, r16
	ret*/
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PauseGame:
		sbrs r11, 4
		rjmp PauseGame_Begin
		ret

PauseGame_Begin:
	lds r16, gameover
	cpi r16, 0xff
	breq Pause_uciekamy
	lds r16, pause
	ldi r17, 0xff
	eor r16, r17

	sts pause, r16

	ldi r17, 29

	mov r5, r17
Pause_uciekamy:
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RotateRight:
		sbrs r11, 7
		rjmp RotateRight_Begin
		ret

RotateRight_Begin:

	ldi r16, 0
	rcall ClearBlock

	lds r16, block_rotation
	push r16
	inc r16
	cpi r16, 4
	brsh RotateRight_Reset

RotateRight_Continue:

	sts block_rotation, r16

	
	lds r16, block_x
	lds r17, block_y
	rcall check_collision

	cpi r16, 0
	pop r16
    
	breq RotateRight_End 

	sts block_rotation, r16 ;prev rotation

RotateRight_End:
	lds r16, block_color
	rcall SetBlock
	ret

RotateRight_Reset:
	ldi r16, 0
	rjmp RotateRight_Continue

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RotateLeft:
		sbrs r11, 6
		rjmp RotateLeft_Begin
		ret

RotateLeft_Begin:

	ldi r16, 0
	rcall ClearBlock
	
	lds r16, block_rotation
	push r16
	dec r16
	cpi r16, 255
	brsh RotateLeft_Reset

RotateLeft_Continue:

	sts block_rotation, r16

	
	lds r16, block_x
	lds r17, block_y
	rcall check_collision

	cpi r16, 0
	pop r16
	breq RotateLeft_End

	sts block_rotation, r16 ;prev rotation

RotateLeft_End:
	lds r16, block_color
	rcall SetBlock
	ret

RotateLeft_Reset:
	ldi r16, 3
	rjmp RotateRight_Continue


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MoveRight:
		sbrs r11, 0 
		rjmp MoveRight_Begin
		ret

MoveRight_Begin:

	ldi r16, 0
	rcall ClearBlock

	lds r16, block_x
	lds r17, block_y
	inc r16

	rcall check_collision


	cpi r16, 0
	breq MoveRightContinue


	lds r16, BLOCK_COLOR ; Set curr block
	rcall SetBlock

	ret

MoveRightContinue:

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

	ldi r16, 0
	rcall ClearBlock

	lds r16, block_x
	lds r17, block_y
	dec r16

	rcall check_collision


	cpi r16, 0
	breq MoveLeftContinue


	lds r16, BLOCK_COLOR ; Set curr block
	rcall SetBlock

	ret
	
MoveLeftContinue:
	
	ldi r16, 0  ; Delete prev block
	rcall ClearBlock

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

	ldi r16, 0
	rcall ClearBlock

	lds r16, block_x
	lds r17, block_y
	inc r17

	rcall check_collision


	cpi r16, 0
	breq MoveDownContinue


	lds r16, BLOCK_COLOR ; Set curr block
	rcall SetBlock

	ldi r16, 29
	mov r5, r16

	ret

MoveDownContinue:

	lds r16, block_y
	inc r16
	sts block_y, r16

	lds r16, BLOCK_COLOR ; Set curr block
	rcall SetBlock

	ret

/*
		DrawMap
*/
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DrawMap:
		ldi r16, 13
		ldi Xl, LOW( 96+MAP_X + SCREEN_WIDTH*4 )
		ldi Xh, HIGH( 96+MAP_X + SCREEN_WIDTH*4 )
		ldi r17, 50
		st X+, r17
		ldi r17, 51
	hor_loop_1:

		st X+, r17
		dec r16            ; 1 clk
		breq hor_loop_1_end    ; 1/2 clk
		rjmp hor_loop_1     ; 2 clk

	hor_loop_1_end:
		ldi r17, 52
		st X+, r17

		ldi r16, 21
		ldi Xl, LOW( 96+MAP_X + SCREEN_WIDTH*5 )
		ldi Xh, HIGH( 96+MAP_X + SCREEN_WIDTH*5 )

	ver_loop:


		ldi r17, 53
		st X, r17
		adiw X, 14
		st X, r17
		adiw X, SCREEN_WIDTH-14


		dec r16            ; 1 clk
		breq ver_loop_end    ; 1/2 clk
		rjmp ver_loop     ; 2 clk

	ver_loop_end:

		ldi r16, 13
		ldi Xl, LOW( 96+MAP_X + (SCREEN_WIDTH*26) )
		ldi Xh, HIGH( 96+MAP_X + (SCREEN_WIDTH*26) )
		ldi r17, 54
		st X+, r17
		ldi r17, 51
	hor_loop_2:

		st X+, r17

		dec r16            ; 1 clk
		breq DrawMap_    ; 1/2 clk
		rjmp hor_loop_2     ; 2 clk

DrawMap_:
	ldi r17, 55
	st X+, r17
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
	ldi Xl, LOW( 96+SCREEN_WIDTH-1)
	ldi Xh, HIGH( 96+SCREEN_WIDTH-1)
	st X, r16


	ldi r16, 0b1
	ldi Xl, LOW( 96 +(SCREEN_WIDTH*29) )
	ldi Xh, HIGH( 96 +(SCREEN_WIDTH*29))
	st X, r16

	ldi r16, 0b10
	ldi Xl, LOW( 96 +(SCREEN_WIDTH*29) +SCREEN_WIDTH-1)
	ldi Xh, HIGH( 96 +(SCREEN_WIDTH*29)+SCREEN_WIDTH-1)
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
	st X+, r2
	st X+, r2
	st X+, r2
	st X+, r2
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
	ldi Xl, LOW( 96+MAP_X + SCREEN_WIDTH*5 +1)
	ldi Xh, HIGH( 96+MAP_X + SCREEN_WIDTH*5 +1)

	ldi r17, 0b0000
	ClearMapLoop:
	st X+, r17
	st X+, r17
	st X+, r17
	st X+, r17
	st X+, r17
	st X+, r17
	st X+, r17
	st X+, r17
	st X+, r17
	st X+, r17
	st X+, r17
	st X+, r17
	st X, r17

	adiw X, SCREEN_WIDTH-12

	dec r16            ; 1 clk
	breq ClearMapLoop_    ; 1/2 clk
	rjmp ClearMapLoop     ; 2 clk

ClearMapLoop_:
	sts block_y, r2
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; r16 - x, r17 - y
check_collision:
	ldi r18, SCREEN_WIDTH
	mul r18, r17
	
	ldi Xl, LOW( 96 + MAP_X+ (5*SCREEN_WIDTH)+1  - X_DELTA)
	ldi Xh, HIGH( 96 + MAP_X+ (5*SCREEN_WIDTH)+1  - X_DELTA)

	add r0, Xl
	adc r1, Xh

	add r0, r16
	adc r1, r2


	mov Xl, r0
	mov Xh, r1

	;; Flash pointer of block


	ldi Zl, LOW(2*BLOCK_START)
	ldi Zh, HIGH(2*BLOCK_START)



	ldi r18, 64
	lds r17, block_type
	; block type * 16
	; 4x line
	mul r17, r18

	
	lds r18, block_rotation
	lsl r18
	lsl r18
	lsl r18
	lsl r18
	add r0, r18
	adc r1, r2

	add Zl, r0
	adc Zh, r1

	clr r19

	; for (y;y<4;y++)
	; for (x;x<4;x++)

		ldi r17, 4
	loop_CheckBlock:
		lpm r18, Z+

		cpse r18, r2
		rcall CheckPixel
		adiw X, 1

		lpm r18, Z+
		cpse r18, r2
		rcall CheckPixel
		adiw X, 1

		lpm r18, Z+
		cpse r18, r2
		rcall CheckPixel
		adiw X, 1

		lpm r18, Z+
		cpse r18, r2
		rcall CheckPixel
		
		adiw X, SCREEN_WIDTH-3

		dec r17
		breq CheckBlock_End
		rjmp loop_CheckBlock

		CheckBlock_End:
		mov r16, r19
		ret


CheckPixel:
	ld r16, X
	cpi r16, 0x00

	breq CheckPixel_no; no collision

	; Collision
	ldi r19, 0xff

	ret

CheckPixel_no:
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; r17 - y
; ret - 0 - holes, 0xff - full
check_line:
	ldi r18, SCREEN_WIDTH
	mul r18, r17
	
	ldi Xl, LOW( 96+MAP_X + SCREEN_WIDTH*5 +1)
	ldi Xh, HIGH( 96+MAP_X + SCREEN_WIDTH*5 +1)

	add r0, Xl
	adc r1, Xh

	mov Xl, r0
	mov Xh, r1

	ser r19

	; for (x;x<12;x++)

		ldi r17, 13
	loop_check_line:
		ld r16, X+
		cpi r16, 0
		breq CheckLine_false

		dec r17
		breq CheckLine_end
		rjmp loop_check_line

		CheckLine_false:
		clr r19

		CheckLine_end:
		mov r16, r19
		ret

; r17 - y	
ClearLine:
	ldi r18, SCREEN_WIDTH
	mul r18, r17

	ldi Xl, LOW( 96+MAP_X + SCREEN_WIDTH*5 +1)
	ldi Xh, HIGH( 96+MAP_X + SCREEN_WIDTH*5 +1)

	add r0, Xl
	adc r1, Xh

	mov Xl, r0
	mov Xh, r1

	st X+, r2
	st X+, r2
	st X+, r2
	st X+, r2
	st X+, r2
	st X+, r2
	st X+, r2
	st X+, r2
	st X+, r2
	st X+, r2
	st X+, r2
	st X+, r2
	st X, r2

	ret

; r17 - line cleared
MoveLine:
	ldi r18, SCREEN_WIDTH
	mul r18, r17

	ldi Xl, LOW( 96+MAP_X + SCREEN_WIDTH*5 +1)
	ldi Xh, HIGH( 96+MAP_X + SCREEN_WIDTH*5 +1)

	add r0, Xl
	adc r1, Xh

	mov Xl, r0
	mov Xh, r1

	mov Zl, Xl
	mov Zh, Xh

	sbiw Z, SCREEN_WIDTH

	ld r16, Z+
	st X+, r16


	ld r16, Z+
	st X+, r16

	ld r16, Z+
	st X+, r16

	ld r16, Z+
	st X+, r16

	ld r16, Z+
	st X+, r16

	ld r16, Z+
	st X+, r16

	ld r16, Z+
	st X+, r16

	ld r16, Z+
	st X+, r16

	ld r16, Z+
	st X+, r16

	ld r16, Z+
	st X+, r16

	ld r16, Z+
	st X+, r16

	ld r16, Z+
	st X+, r16

	ld r16, Z+
	st X+, r16

	ret

; r16 - x
; r17 - y
; Z - string
DrawString:
	ldi r18, SCREEN_WIDTH
	mul r17, r18

	add r0, r16
	adc r1, r2

	ldi Xl, LOW( 96 )
	ldi Xh, HIGH( 96 )	

	add Xl, r0
	adc Xh, r1


	DrawStringLoop:
	lpm r17, Z+
	cpi r17, 0
	breq DrawStringEnd
	cpi r17, ' '
	breq DrawSpace

	subi r17, 46

	ldi r16, 56
	add r17, r16
	st X+, r17

	rjmp DrawStringLoop
DrawStringEnd:
	ret

DrawSpace:
	adiw X, 1
	rjmp DrawStringLoop

; r16 - x
; r17 - y
; r18 - char
DrawChar:
	push r18
	ldi r18, SCREEN_WIDTH
	mul r17, r18

	add r0, r16
	adc r1, r2

	ldi Xl, LOW( 96 )
	ldi Xh, HIGH( 96 )	

	add Xl, r0
	adc Xh, r1
	pop r18

	subi r18, 46

	ldi r16, 56
	add r18, r16
	st X+, r18

	ret


; r16 - x (r align!)
; r17 - y
; r18 - number
DrawNumber:
	ldi r19, SCREEN_WIDTH
	mul r17, r19

	add r0, r16
	adc r1, r2

	ldi Xl, LOW( 96 )
	ldi Xh, HIGH( 96 )	

	add Xl, r0
	adc Xh, r1

	; x/10
	mov r16, r18
	ldi r17, 10
	rcall divide

	mov r18, r16

	ldi r16, 56+2
	add r17, r16
	st -X, r17


	; x/10
	mov r16, r18
	ldi r17, 10
	rcall divide

	mov r18, r16

	ldi r16, 56+2
	add r17, r16
	st -X, r17

	
	; x/10
	mov r16, r18
	ldi r17, 10
	rcall divide

	mov r18, r16

	ldi r16, 56+2
	add r17, r16
	st -X, r17

	ret


; r16 - a
; r17 - b 
;
; a/b = X
; a%b = y
;
; r16 - X
; r17 - y
divide:
push r18
	ldi r18, 0

div_loop:
	cp r16, r17 ; if a>b, divide
	brsh div_
	brlo mod_

	rjmp div_loop


div_:
	inc r18

	sub r16, r17
	rjmp div_loop

mod_:
	mov r17, r16 ;reszta
	mov r16, r18 ;calkowita

pop r18
	ret

Highscores:
	rcall ClearScreen

	ldi r16, 10
	ldi r17, 2
	ldi Zl, LOW(stringWYNIKI*2)
	ldi Zh, HIGH(stringWYNIKI*2)
	rcall DrawString

	ldi r16, 0
	mov r14, r16
Highscores_loop:


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;1
	ldi r18, 0
	mov r17, r14
	lsl r17
	lsl r17
	rcall EEPROM_read

	mov r18, r16

	ldi r16, 8
	ldi r17, 5
	mov r20, r14
	lsl r20
	add r17, r20	
	rcall DrawChar

	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;2
	ldi r18, 0
	mov r17, r14
	lsl r17
	lsl r17
	inc r17
	rcall EEPROM_read

	mov r18, r16

	ldi r16, 9
	ldi r17, 5
	mov r20, r14
	lsl r20
	add r17, r20	
	rcall DrawChar

	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;3
	ldi r18, 0
	mov r17, r14
	lsl r17
	lsl r17
	inc r17
	inc r17
	rcall EEPROM_read

	mov r18, r16

	ldi r16, 10
	ldi r17, 5
	mov r20, r14
	lsl r20
	add r17, r20	
	rcall DrawChar
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;4
	ldi r18, 0
	mov r17, r14
	lsl r17
	lsl r17
	inc r17
	inc r17
	inc r17
	rcall EEPROM_read

	mov r18, r16

	ldi r16, 18
	ldi r17, 5
	mov r20, r14
	lsl r20
	add r17, r20	
	rcall DrawNumber


	inc r14
	mov r16, r14
	cpi r16, 10
	breq Highscores_
	rjmp Highscores_loop

	Highscores_:
	ret

EEPROM_read:
	sbic EECR, EEWE
	rjmp EEPROM_read

	out EEARH, r18
	out EEARL, r17
	
	sbi EECR, EERE
	in r16, EEDR
	ret

check_highscore:
	ldi r19, 0
	ldi r18, 0
check_highscore_loop:
	mov r17, r19
	lsl r17
	lsl r17
	inc r17
	inc r17
	inc r17
	rcall EEPROM_read

	lds r15, lines
	cp r15, r16
	; wieksze - wpisujemy
	; mniejsze - jazda

	inc r19
	cpi r19, 10
	breq check_highscore_end
	rjmp check_highscore_loop
	check_highscore_end:
	ret

stringEmpty: .db "@@@@@", 0
stringPauza: .db "PAUZA", 0
stringGameover:.db "KONIEC GRY", 0
stringWynik: .db "WYNIK", 0
stringLinie: .db "LINIE", 0
stringPoziom: .db "POZIOM", 0
stringNastepny: .db "NASTEPNY", 0
stringWYNIKI: .db "WYNIKI", 0

.include "splash.asm"
.include "Random.asm"
.include "Pad.asm"
.include "Uart.asm"

.include "blocks.asm"


.ESEG
.DB 'K', 'U', 'B', 76
.DB 'A', 'A', 'A', 0
.DB 'A', 'A', 'A', 0
.DB 'A', 'A', 'A', 0
.DB 'A', 'A', 'A', 0
.DB 'A', 'A', 'A', 0
.DB 'A', 'A', 'A', 0
.DB 'A', 'A', 'A', 0
.DB 'A', 'A', 'A', 0
.DB 'A', 'A', 'A', 0
