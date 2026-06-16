.MODEL SMALL
.STACK 100H
.DATA

; --- Data Section ---
MSG1 DB 'Enter Password: $'
MSG2 DB 0AH,0DH, 'Access Granted!$'
MSG3 DB 0AH,0DH, 'Access Denied!$'
MSG4 DB 0AH,0DH, 'Attempts Left: $'
PASS DB '1234$', 0   ; Correct password
USER DB 5 DUP(?)     ; Space for user input
TRIES DB 3           ; Allow 3 attempts

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

START:
    ; Display "Enter Password"
    LEA DX, MSG1
    MOV AH, 09H
    INT 21H

    ; Take user input
    LEA DI, USER
    MOV CX, 0

READ_LOOP:
    MOV AH, 1        ; Input character
    INT 21H
    CMP AL, 13       ; Enter key (Carriage Return)
    JE CHECK_PASS
    MOV [DI], AL
    INC DI
    INC CX
    JMP READ_LOOP

CHECK_PASS:
    MOV AL, '$'
    MOV [DI], AL     ; End user input with $

    ; Compare user input with password
    LEA SI, PASS
    LEA DI, USER

COMPARE_LOOP:
    MOV AL, [SI]
    MOV BL, [DI]
    CMP AL, '$'
    JE CHECK_END
    CMP AL, BL
    JNE WRONG
    INC SI
    INC DI
    JMP COMPARE_LOOP

CHECK_END:
    ; If all characters matched
    LEA DX, MSG2
    MOV AH, 09H
    INT 21H
    JMP EXIT

WRONG:
    ; Decrease tries
    DEC TRIES
    CMP TRIES, 0
    JE LOCKED

    ; Show "Access Denied"
    LEA DX, MSG3
    MOV AH, 09H
    INT 21H

    ; Show remaining attempts
    LEA DX, MSG4
    MOV AH, 09H
    INT 21H

    MOV AL, TRIES
    ADD AL, 30H       ; Convert to ASCII
    MOV DL, AL
    MOV AH, 02H
    INT 21H

    JMP START

LOCKED:
    LEA DX, MSG3
    MOV AH, 09H
    INT 21H
    JMP EXIT

EXIT:
    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN
