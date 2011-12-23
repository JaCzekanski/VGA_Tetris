
; No args.
RANDOM_init:

	; Initialize ADC (for randomizing), PC5
	cbi DDRC, 5

	; AREF, ADC5
	ldi r16, 5
	out ADMUX, r16
	ldi r16, 0b11100101;(1<<ADEN)|(1<<ADSC)|(1<<ADIF)|(1<<ADPS0)
	out ADCSRA, r16

	ret

; return r16 - 8bit random
RANDOM_get:

	in r16, ADCL
	push r16
	in r16, ADCH
	pop r16

	ret
