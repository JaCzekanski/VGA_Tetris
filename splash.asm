DrawSplashScreen:
	rcall ClearScreen

	ldi r16, 10
	ldi r17, 3
	ldi Zl, LOW(stringTetris*2)
	ldi Zh, HIGH(stringTetris*2)
	rcall DrawString

	ldi r16, 10
	ldi r17, 6
	ldi Zl, LOW(stringAutor*2)
	ldi Zh, HIGH(stringAutor*2)
	rcall DrawString


	ldi r16, 6
	ldi r17, 8
	ldi Zl, LOW(stringJakubCzekanski*2)
	ldi Zh, HIGH(stringJakubCzekanski*2)
	rcall DrawString

	
	ldi r16, 6
	ldi r17, 15
	ldi Zl, LOW(stringNacisnij1*2)
	ldi Zh, HIGH(stringNacisnij1*2)
	rcall DrawString


	ldi r16, 6
	ldi r17, 17
	ldi Zl, LOW(stringNacisnij2*2)
	ldi Zh, HIGH(stringNacisnij2*2)
	rcall DrawString

	
	ldi r16, 4
	ldi r17, 22
	ldi Zl, LOW(stringinfo1*2)
	ldi Zh, HIGH(stringinfo1*2)
	rcall DrawString

	

	
	ldi r16, 5
	ldi r17, 24
	ldi Zl, LOW(stringinfo2*2)
	ldi Zh, HIGH(stringinfo2*2)
	rcall DrawString

	
	
	ldi r16, 6
	ldi r17, 27
	ldi Zl, LOW(stringinfo3*2)
	ldi Zh, HIGH(stringinfo3*2)
	rcall DrawString
	ret


stringTetris: .DB "TETRIS", 0
stringAutor: .DB "AUTOR", 0
stringJakubCzekanski: .DB "JAKUB CZEKANSKI", 0
stringNacisnij1: .DB "START   GRAJ", 0
stringNacisnij2: .DB "    A   WYNIKI", 0
stringinfo1: .DB "PROJEKT WYKONANY NA ", 0
stringinfo2: .DB "KONKURS GRA RETRO" ,0 
stringinfo3: .DB " ELEKTRODA.PL", 0
