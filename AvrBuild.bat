@ECHO OFF
"d:\app\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "D:\KubX\dev\AVR\AVR_Tetris\labels.tmp" -fI -W+ie -C V2E -o "D:\KubX\dev\AVR\AVR_Tetris\AVR_Tetris.hex" -d "D:\KubX\dev\AVR\AVR_Tetris\AVR_Tetris.obj" -e "D:\KubX\dev\AVR\AVR_Tetris\AVR_Tetris.eep" -m "D:\KubX\dev\AVR\AVR_Tetris\AVR_Tetris.map" -l "D:\KubX\dev\AVR\AVR_Tetris\AVR_Tetris.lst" "D:\KubX\dev\AVR\AVR_Tetris\main.asm"
