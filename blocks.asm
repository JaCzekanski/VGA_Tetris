.cseg 
BLOCK_START:

;XX
;XX
.DB 0, 1, 2, 0, \
    0, 3, 4, 0, \
    0, 0, 0, 0,\
    0, 0, 0, 0,\
\
    0, 1, 2, 0, \
    0, 3, 4, 0, \
    0, 0, 0, 0,\
    0, 0, 0, 0,\
\
    0, 1, 2, 0, \
    0, 3, 4, 0, \
    0, 0, 0, 0,\
    0, 0, 0, 0,\
\
    0, 1, 2, 0, \
    0, 3, 4, 0, \
    0, 0, 0, 0,\
    0, 0, 0, 0

;X
;X
;X
;X
.DB \
 0, 0, 5, 0, \
 0, 0, 6, 0, \
 0, 0, 6, 0, \
 0, 0, 7, 0, \
\
 8, 9, 9, 10, \
 0, 0, 0, 0, \
 0, 0, 0, 0, \
 0, 0, 0, 0, \
\
 0, 0, 5, 0, \
 0, 0, 6, 0, \
 0, 0, 6, 0, \
 0, 0, 7, 0, \
\
 8, 9, 9, 10, \
 0, 0, 0, 0, \
 0, 0, 0, 0, \
 0, 0, 0, 0

; X
;XXX
.DB \
 0, 0, 11, 0, \
 0, 12, 13, 14, \
 0, 0, 0, 0, \
 0, 0, 0, 0, \
\
 0, 0, 11, 0, \
 0, 0, 15, 14, \
 0, 0, 16, 0, \
 0, 0, 0, 0, \
\
 0, 12, 17, 14, \
 0, 0, 16, 0, \
 0, 0, 0, 0, \
 0, 0, 0, 0, \
\
 0, 0, 11, 0, \
 0, 12, 18, 0, \
 0, 0, 16, 0, \
 0, 0, 0, 0

;+2+1+1

;X
;XX
; X
.DB \
 0, 19, 0, 0, \
 0, 20, 21, 0, \
 0, 0, 22, 0, \
 0, 0, 0, 0, \
\
 0, 0, 24, 23, \
 0, 26, 25, 0, \
 0, 0, 0, 0, \
 0, 0, 0, 0, \
\
 0, 19, 0, 0, \
 0, 20, 21, 0, \
 0, 0, 22, 0, \
 0, 0, 0, 0, \
\
 0, 0, 24, 23, \
 0, 26, 25, 0, \
 0, 0, 0, 0, \
 0, 0, 0, 0
 
; X
;XX
;X
.DB \
 0, 0, 27, 0, \
 0, 29, 28, 0, \
 0, 30, 0, 0, \
 0, 0, 0, 0, \
\
 0, 31, 32, 0, \
 0, 0, 33, 34, \
 0, 0, 0, 0, \
 0, 0, 0, 0, \
\
 0, 0, 27, 0, \
 0, 29, 28, 0, \
 0, 30, 0, 0, \
 0, 0, 0, 0, \
\
 0, 31, 32, 0, \
 0, 0, 33, 34, \
 0, 0, 0, 0, \
 0, 0, 0, 0

 ;+4
 
;X 
;X 
;XX
.DB \
 0, 0, 35, 0, \
 0, 0, 36, 0, \
 0, 0, 37, 38, \
 0, 0, 0, 0, \
\
 0, 0, 0, 0, \
 0, 41, 40, 39, \
 0, 42, 0, 0, \
 0, 0, 0, 0, \
\
 0, 0, 43, 44, \
 0, 0, 0, 36, \
 0, 0, 0, 42, \
 0, 0, 0, 0, \
\
 0, 0, 0, 0, \
 0, 0, 0, 35, \
 0, 43, 40, 45, \
 0, 0, 0, 0
 

 ;+7

; X
; X
;XX

.DB \
 0, 0, 0, 5, \
 0, 0, 0, 6, \
 0, 0, 8, 46, \
 0, 0, 0, 0, \
\
 0, 0, 0, 0, \
 0, 5, 0, 0, \
 0, 47, 9, 10, \
 0, 0, 0, 0, \
\
 0, 0, 48, 10, \
 0, 0, 6, 0, \
 0, 0, 7, 0, \
 0, 0, 0, 0, \
\
 0, 0, 0, 0, \
 0, 8, 9, 49, \
 0, 0, 0, 7, \
 0, 0, 0, 0

COLORS:
.DB \
 0b0100, \
 0b0001, \
 0b0011, \
 0b1010, \
 0b1101, \
 0b1100, \
 0b1001




; BRUTE
.org 4096/2
TILES:
; 0xAB
; BABA

.DB 0x00, 0x00,\
    0x00, 0x00,\
    0x00, 0x00,\
    0x00, 0x00

;XX
;XX
.DB 0xCC, 0xCC,\
    0x4C, 0x44,\
    0x4C, 0x44,\
    0x4C, 0x44
	
.DB 0xCC, 0x4C,\
    0x44, 0x04,\
    0x44, 0x04,\
    0x44, 0x04
	
.DB 0x4C, 0x44,\
    0x4C, 0x44,\
    0x4C, 0x44,\
    0x04, 0x00
	
.DB 0x44, 0x04,\
    0x44, 0x04,\
    0x44, 0x04,\
    0x00, 0x00

	
;X
;X
;X
;X
.DB 0x99, 0x19,\
    0x19, 0x01,\
    0x19, 0x01,\
    0x19, 0x01
	
.DB 0x19, 0x01,\
    0x19, 0x01,\
    0x19, 0x01,\
    0x19, 0x01
	
.DB 0x19, 0x01,\
    0x19, 0x01,\
    0x19, 0x01,\
    0x01, 0x00
	
;XXXX
;UNDONE
;;;;;;;;;;;;;;;;;;;;;;;;
.DB 0x99, 0x99,\
    0x19, 0x11,\
    0x19, 0x11,\
    0x01, 0x00
	
.DB 0x99, 0x99,\
    0x11, 0x11,\
    0x11, 0x11,\
    0x00, 0x00
	
.DB 0x99, 0x19,\
    0x11, 0x01,\
    0x11, 0x01,\
    0x00, 0x00
;UNDONE
;;;;;;;;;;;;;;;;;;;;;;;;
	


; X
;XXX

.DB 0xbb, 0x3b,\
    0x3b, 0x03,\
    0x3b, 0x03,\
    0x3b, 0x03
	
.DB 0xbb, 0xbb,\
    0x3b, 0x33,\
    0x3b, 0x33,\
    0x03, 0x00
	
.DB 0x3b, 0x33,\
    0x33, 0x33,\
    0x33, 0x33,\
    0x00, 0x00

.DB 0xbb, 0x3b,\
    0x33, 0x03,\
    0x33, 0x03,\
    0x00, 0x00


;X
;XX  2,4
;X

.DB 0x3b, 0x33,\
    0x3b, 0x33,\
    0x3b, 0x33,\
    0x3b, 0x03

.DB 0x3b, 0x03,\
    0x3b, 0x03,\
    0x3b, 0x03,\
    0x03, 0x00

;XXX
; X  2
;

.DB 0xbb, 0xbb,\
    0x33, 0x33,\
    0x33, 0x33,\
    0x33, 0x03


; X 
;XX  3
; X

.DB 0x3b, 0x03,\
    0x33, 0x03,\
    0x33, 0x03,\
    0x3b, 0x03

;X
;XX
; X

.DB 0xaa, 0x2a,\
    0x2a, 0x02,\
    0x2a, 0x02,\
    0x2a, 0x02
	
.DB 0x2a, 0x22,\
    0x2a, 0x22,\
    0x2a, 0x22,\
    0x02, 0x00
	
.DB 0xaa, 0x2a,\
    0x22, 0x02,\
    0x22, 0x02,\
    0x2a, 0x02
	
.DB 0x2a, 0x02,\
    0x2a, 0x02,\
    0x2a, 0x02,\
    0x02, 0x00

; XX
;XX
; 

.DB 0xaa, 0x2a,\
    0x22, 0x02,\
    0x22, 0x02,\
    0x00, 0x00
	
.DB 0xaa, 0xaa,\
    0x2a, 0x22,\
    0x2a, 0x22,\
    0x2a, 0x02
	
.DB 0x2a, 0x02,\
    0x22, 0x02,\
    0x22, 0x02,\
    0x00, 0x00
	
.DB 0xaa, 0xaa,\
    0x2a, 0x22,\
    0x2a, 0x22,\
    0x02, 0x00

; X
;XX
;X

.DB 0xdd, 0x5d,\
    0x5d, 0x05,\
    0x5d, 0x05,\
    0x5d, 0x05
	
.DB 0x5d, 0x05,\
    0x55, 0x05,\
    0x55, 0x05,\
    0x00, 0x00
	
.DB 0xdd, 0xdd,\
    0x5d, 0x55,\
    0x5d, 0x55,\
    0x5d, 0x05
	
.DB 0x5d, 0x05,\
    0x5d, 0x05,\
    0x5d, 0x05,\
    0x05, 0x00


;XX
; XX
;

.DB 0xdd, 0xdd,\
    0x5d, 0x55,\
    0x5d, 0x55,\
    0x05, 0x00
	
.DB 0xdd, 0x5d,\
    0x55, 0x05,\
    0x55, 0x05,\
    0x5d, 0x05
	
.DB 0x5d, 0xd5,\
    0x5d, 0x55,\
    0x5d, 0x55,\
    0x05, 0x00
	
.DB 0xdd, 0x5d,\
    0x55, 0x05,\
    0x55, 0x05,\
    0x00, 0x00


;X
;X
;XX

.DB 0xee, 0x6e,\
    0x6e, 0x06,\
    0x6e, 0x06,\
    0x6e, 0x06
	
.DB 0x6e, 0x06,\
    0x6e, 0x06,\
    0x6e, 0x06,\
    0x6e, 0x06
	
.DB 0x6e, 0x66,\
    0x6e, 0x66,\
    0x6e, 0x66,\
    0x06, 0x00
	
.DB 0xee, 0x0e,\
    0x66, 0x06,\
    0x66, 0x06,\
    0x00, 0x00


;XXX
;X

.DB 0xee, 0x6e,\
    0x66, 0x06,\
    0x66, 0x06,\
    0x00, 0x00
	
.DB 0xee, 0xee,\
    0x66, 0x66,\
    0x66, 0x66,\
    0x00, 0x00
	
.DB 0xee, 0xee,\
    0x6e, 0x66,\
    0x6e, 0x66,\
    0x6e, 0x06
	
.DB 0x6e, 0x06,\
    0x6e, 0x06,\
    0x6e, 0x06,\
    0x06, 0x00


;XX  1 2
; X
; X

.DB 0xee, 0xee,\
    0x6e, 0x66,\
    0x6e, 0x66,\
    0x06, 0x00
	
.DB 0xee, 0x6e,\
    0x66, 0x06,\
    0x66, 0x06,\
    0x60, 0x06

;  X
;XXX  2

.DB 0x6e, 0x06,\
    0x66, 0x06,\
    0x66, 0x06,\
    0x00, 0x00
	


; X
; X
;XX 3
	
.DB 0x19, 0x01,\
    0x11, 0x01,\
	0x11, 0x01,\
    0x00, 0x00
	
	



;X
;XXX2
	
.DB 0x19, 0x91,\
    0x19, 0x11,\
	0x19, 0x11,\
    0x01, 0x00
	

;XX
;X 1
;X
	
.DB 0x99, 0x99,\
    0x19, 0x11,\
	0x19, 0x11,\
    0x19, 0x01
	

;XXX 3
;  X
;
	
.DB 0x99, 0x19,\
    0x11, 0x01,\
	0x11, 0x01,\
    0x19, 0x01
	


; RAMKA

;123
;4 4
;526


; 50!!!
.DB 0xff, 0xff,\
	0x7f, 0x77,\
	0x7f, 0x77,\
	0x7f, 0x07


.DB 0xff, 0xff,\
	0x77, 0x77,\
	0x77, 0x77,\
	0x00, 0x00


.DB 0xff, 0x7f,\
	0x77, 0x07,\
	0x77, 0x07,\
	0x7f, 0x07

	

.DB 0x7f, 0x07,\
	0x7f, 0x07,\
	0x7f, 0x07,\
	0x7f, 0x07

	

.DB 0x7f, 0x77,\
	0x7f, 0x77,\
	0x7f, 0x77,\
	0x07, 0x00
	

.DB 0x7f, 0x07,\
	0x77, 0x07,\
	0x77, 0x07,\
	0x00, 0x00

 ;56
 FONT_START:
.include "font.asm"
