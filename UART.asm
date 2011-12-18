.ifndef F_UART
	.error "F_UART not defined!"
.endif
.ifndef F_CPU
	.error "F_CPU not defined!"
.endif


; No args. F_CPU defined required
UART_init:
	ldi r16, high(F_CPU/16/F_UART-1 )
	out UBRRH, r16
	ldi r16, low(F_CPU/16/F_UART-1)
	out UBRRL, r16

	ldi r16, (1<<RXEN)|(1<<TXEN)
	out UCSRB, r16

	; 8N1
	ldi r16, (1<<URSEL)|(1<<UCSZ1)|(1<<UCSZ0); ;8bit
	out UCSRC, r16

	ret

; r16 - byte
UART_putc:
	sbis UCSRA, UDRE
	rjmp UART_putc

	out UDR, r16
	ret

; Z - String address
UART_puts:
	; Z -> r0
	lpm r16, Z+
	cpi r16, 0
	breq UART_puts_end

	rcall UART_putc
	rjmp UART_puts

UART_puts_end:
	ret

; r16 - byte
UART_getc:
	sbis UCSRA, RXC
	rjmp UART_getc

	in r16, UDR
	ret
