.cseg 
BLOCK_START:
;XX
;XX
.DB \
 0b0110, \
 0b0110, \
 0b0000, \
 0b0000, \
\
 0b0110, \
 0b0110, \
 0b0000, \
 0b0000, \
\
 0b0110, \
 0b0110, \
 0b0000, \
 0b0000, \
\
 0b0110, \
 0b0110, \
 0b0000, \
 0b0000

;X
;X
;X
;X
.DB \
 0b0001, \
 0b0001, \
 0b0001, \
 0b0001, \
\
 0b1111, \
 0b0000, \
 0b0000, \
 0b0000, \
\
 0b0001, \
 0b0001, \
 0b0001, \
 0b0001, \
\
 0b1111, \
 0b0000, \
 0b0000, \
 0b0000




; X
;XXX
.DB \
 0b0010, \
 0b0111, \
 0b0000, \
 0b0000, \
\
 0b0010, \
 0b0011, \
 0b0010, \
 0b0000, \
\
 0b0111, \
 0b0010, \
 0b0000, \
 0b0000, \
\
 0b0010, \
 0b0110, \
 0b0010, \
 0b0000




;X
;XX
; X
.DB \
 0b0100, \
 0b0110, \
 0b0010, \
 0b0000, \
\
 0b0011, \
 0b0110, \
 0b0000, \
 0b0000, \
\
 0b0100, \
 0b0110, \
 0b0010, \
 0b0000, \
\
 0b0011, \
 0b0110, \
 0b0000, \
 0b0000



; X
;XX
;X
.DB \
 0b0010, \
 0b0110, \
 0b0100, \
 0b0000, \
\
 0b0110, \
 0b0011, \
 0b0000, \
 0b0000, \
\
 0b0010, \
 0b0110, \
 0b0100, \
 0b0000, \
\
 0b0110, \
 0b0011, \
 0b0000, \
 0b0000


;X 
;X 
;XX

.DB \
 0b0010, \
 0b0010, \
 0b0011, \
 0b0000, \
\
 0b0000, \
 0b0111, \
 0b0100, \
 0b0000, \
\
 0b0011, \
 0b0001, \
 0b0001, \
 0b0000, \
\
 0b0000, \
 0b0001, \
 0b0111, \
 0b0000




; X 
; X 
;XX
.DB \
 0b0001, \
 0b0001, \
 0b0011, \
 0b0000, \
\
 0b0000, \
 0b0100, \
 0b0111, \
 0b0000, \
\
 0b0011, \
 0b0010, \
 0b0010, \
 0b0000, \
\
 0b0000, \
 0b0111, \
 0b0001, \
 0b0000 
 
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

.DB 0x99, 0x19,\
    0x19, 0x01,\
    0x19, 0x01,\
    0x01, 0x00

.DB 0x22, 0x22,\
    0x22, 0x22,\
    0x22, 0x22,\
    0x22, 0x22


.DB 0x21, 0x43,\
    0x65, 0x87,\
    0xA9, 0xCB,\
    0xED, 0x21

.DB 0x44, 0x44,\
    0x44, 0x44,\
    0x44, 0x44,\
    0x44, 0x44

.DB 0x55, 0x55,\
    0x55, 0x55,\
    0x55, 0x55,\
    0x55, 0x55

.DB 0x66, 0x66,\
    0x66, 0x66,\
    0x66, 0x66,\
    0x66, 0x66

	.DB 0x77, 0x77,\
    0x77, 0x77,\
    0x77, 0x77,\
    0x77, 0x77

	.DB 0x88, 0x88,\
    0x88, 0x88,\
    0x88, 0x88,\
    0x88, 0x88

	.DB 0x99, 0x99,\
    0x99, 0x99,\
    0x99, 0x99,\
    0x99, 0x99

.DB 0xAA, 0xAA,\
    0xAA, 0xAA,\
    0xAA, 0xAA,\
    0xAA, 0xAA

	.DB 0xBB, 0xBB,\
    0xBB, 0xBB,\
    0xBB, 0xBB,\
    0xBB, 0xBB

	.DB 0xCC, 0xCC,\
    0xCC, 0xCC,\
    0xCC, 0xCC,\
    0xCC, 0xCC

	.DB 0xDD, 0xDD,\
    0xDD, 0xDD,\
    0xDD, 0xDD,\
    0xDD, 0xDD

	.DB 0xEE, 0xEE,\
    0xEE, 0xEE,\
    0xEE, 0xEE,\
    0xEE, 0xEE

	.DB 0xFF, 0xFF,\
    0xFF, 0xFF,\
    0xFF, 0xFF,\
    0xFF, 0xFF
