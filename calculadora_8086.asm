name "calculadora"
;|==========================================|
;|Esta maro foi copiada de emu8086.inc      |
;|==========================================|
;|Esta macro imprime um char em AL e avanca |
;|indica posicao atual do cursor            |
;|==========================================|                                             
PUTC    MACRO   char                        
        PUSH    AX                          
        MOV     AL, char
        MOV     AH, 0Eh
        INT     10h     
        POP     AX
ENDM
;|==========================================|
org 100h
jmp iniciar
;|==========================================|
;|definindo mensagem                        |
;|==========================================|
msgT db "Projeto - Calculadora Assembly emu8086",0Dh,0Ah,'$'
msgN db 0Dh,0Ah,"Grupo - israel, hugo, matheus, rodolfo, vitor.",0Dh,0Ah,'$'
msg0 db 0Dh,0Ah,"OBS: Esta calculadora funciona apenas com valores inteiros.",0Dh,0Ah,'$'
msg1 db 0Dh,0Ah, 0Dh,0Ah, 'Digite o primeiro valor: $'
msg2 db "Digite o operador:    +  -  *  /     : $"
msg3 db "Digite o segundo valor: $", 0Dh,0Ah , '$'
msg4 db 0dh,0ah,'Resultado : $'
msg5 db 0dh,0ah,'Obrigado por usar a calculadora! pressione qualquer tecla...', 0Dh,0Ah, '$'
err1 db "digite um operador!", 0Dh,0Ah , '$'
smth db " resultado inteiro$"
;|==========================================|
;|Os Operadores podem ser:                  |
;|'+', '-', '*', '/' ou 'q' para sair       |                 
;|==========================================|
opr db '?'          ;
;|==========================================|
;|Primero e Segundo Numero                  |
;|==========================================|
num1 dw ?           ;
num2 dw ?           ;
;|==========================================|
iniciar:
mov dx, offset msgT ;
mov ah, 9           ;
int 21h             ;            
mov dx, offset msgN ;
mov ah, 9           ;
int 21h             ;
mov dx, offset msg0 ;
mov ah, 9           ;
int 21h             ;
lea dx, msg1        ;
mov ah, 09h         ;String de saida em ds:dx
int 21h             ;
;|==========================================|
;|Obter o numero assinado com varios        |
;|digitos, do teclado e armazenar o         |
;|resultado em cx register                  |
;|==========================================|
call scan_num       ;
mov num1, cx        ;Armazenar primeiro numero
putc 0Dh            ;Nova linha:
putc 0Ah            ;
lea dx, msg2        ;
mov ah, 09h         ;String de saida em ds:dx
int 21h             ;
;|==========================================|
;|Obter o operador                          |
;|==========================================|
mov ah, 1           ;Unica entrada de caracter para AL
int 21h             ;
mov opr, al         ;
putc 0Dh            ;Nova linha:
putc 0Ah            ;
cmp opr, 'q'        ;Ao inserir 'q' sair
je exit             ;
cmp opr, '*'        ;
jb op_aviso         ;
cmp opr, '/'        ;
ja op_aviso         ;
lea dx, msg3        ;String de saida em ds:dx
mov ah, 09h         ;
int 21h             ;
;|==========================================|
;|Obter o numero assinado com varios        |
;|digitos, do teclado e armazenar o         |
;|resultado em cx register                  |
;|==========================================|
call scan_num       ;
mov num2, cx        ;Armazenar primeiro numero
lea dx, msg4        ;String de saida em ds:dx
mov ah, 09h         ;
int 21h             ;
;|==========================================|
;|Calcular                                  |
;|desvios de fluxos para as funcoes         |
;|==========================================|
cmp opr, '+'        ;
je op_adicao        ;
cmp opr, '-'        ;
je op_subtracao     ;
cmp opr, '*'        ;
je op_multip        ;
cmp opr, '/'        ;
je op_divisao       ;
;|==========================================|
;|Caso nenhuma das opcoes de calculo        |
;|exibir mensagem de erro                   |
;|==========================================|
op_aviso:          ;
lea dx, err1        ;String de saida em ds:dx
mov ah, 09h         ;
int 21h             ;
exit:               ;
lea dx, msg5        ;String de saida em ds:dx
mov ah, 09h         ;
int 21h             ;
mov ah, 0           ;Aguardando qualquer tecla 
int 16h             ;
ret                 ;Retornar ao Sistema Operacional
;|==========================================|
;|Calcular Adicao                           |
;|==========================================|
op_adicao:          ;
mov ax, num1        ;
add ax, num2        ;
call impri_num      ;Imprime o valor do registrador ax
jmp exit            ;
;|==========================================|
;|Calcular Subtracao                        |
;|==========================================|
op_subtracao:       ;
mov ax, num1        ;
sub ax, num2        ;
call impri_num      ; Imprime o valor do registrador ax
jmp exit            ;                         
;|==========================================|

;|==========================================|
;|Calcular Multiplicacao                    |
;|==========================================|
op_multip:          ;
mov ax, num1        ;
imul num2           ; (dx ax) = ax * num2. 
call impri_num      ; Imprime o valor do registrador ax
jmp exit            ; dx is ignored (calc works with tiny numbers only).
;|==========================================|

;|==========================================|
;|Calcular Divisao                          |
;|==========================================|
op_divisao:         ;
mov dx, 0           ; dx is ignored (calc works with tiny integer numbers only).
mov ax, num1        ;
idiv num2           ; ax = (dx ax) / num2.
cmp dx, 0           ;
jnz approx          ;
call impri_num      ; Imprime o valor do registrador ax
jmp exit            ;
approx:             ;
call impri_num      ; Imprime o valor do registrador ax
lea dx, smth        ;
mov ah, 09h         ; output string at ds:dx
int 21h             ;
jmp exit            ;
;|===========================================|

;|===========================================|
;|Estas funcoes foram copiadas do emu8086.inc|
;|===========================================|
;|===========================================|
;|Obtem o numero assinado de varios digitos  |
;|a partir do teclado, e armazenar o         |
;|o resultado no registrador CX              |
;|===========================================|
SCAN_NUM PROC    NEAR               ; Inicio do Procedimento
         PUSH    DX                 ;
         PUSH    AX                 ;
         PUSH    SI                 ;
         MOV     CX, 0              ;
         MOV     CS:marca_menos, 0  ;reset flag:
prox_digito:                        ;
;|===========================================|
;|Captura o Caracter do teclado para AL  e   |
;|imprime na tela                            |
;|===========================================|
        MOV     AH, 00h             ;
        INT     16h                 ;
        MOV     AH, 0Eh             ;
        INT     10h                 ;
        CMP     AL, '-'             ;Verifica se for -
        JE      set_minus           ;
;|===========================================|
;|Verifica se precionou Enter                |
;|===========================================|
        CMP     AL, 0Dh             ;
        JNE     nao_lpz             ;
        JMP     stop_input          ;
nao_lpz:                            ;
        CMP     AL, 8               ; 'BACKSPACE' pressed?
        JNE     backspace_pressionado   ;
        MOV     DX, 0               ; remove last digit by
        MOV     AX, CX              ; division:
        DIV     CS:ten              ; AX = DX:AX / 10 (DX-rem).
        MOV     CX, AX              ;
        PUTC    ' '                 ; clear position.
        PUTC    8                   ; backspace again.
        JMP     prox_digito         ;
;|===========================================|
;|Verifica se precionou BackSpace            |
;|===========================================|        
backspace_pressionado:              ;
        CMP     AL, '0'             ;Permitir apenas numero
        JAE     ok_AE_0             ;
        JMP     remover_nao_num     ;
ok_AE_0:                            ;
        CMP     AL, '9'             ;
        JBE     testa_num           ;
remover_nao_num:                    ;
        PUTC    8                   ; backspace.
        PUTC    ' '                 ; clear last entered not digit.
        PUTC    8                   ; backspace again.        
        JMP     prox_digito         ; wait for next input.       
testa_num:                          ;
        PUSH    AX                  ; multiply CX by 10 (first time the result is zero)
        MOV     AX, CX              ;
        MUL     CS:ten              ; DX:AX = AX*10
        MOV     CX, AX              ;
        POP     AX                  ;
        CMP     DX, 0               ; check if the number is too big ; (result should be 16 bits)
        JNE     too_big             ;
        SUB     AL, 30h             ; convert from ASCII code:
        MOV     AH, 0               ; add AL to CX:
        MOV     DX, CX              ; backup, in case the result will be too big.
        ADD     CX, AX              ;
        JC      too_big2            ; jump if the number is too big.
        JMP     prox_digito         ;
set_minus:                          ;
        MOV     CS:marca_menos, 1   ;
        JMP     prox_digito         ;
too_big2:                           ;
        MOV     CX, DX              ; restore the backuped value before add.
        MOV     DX, 0               ; DX was zero before backup!
too_big:                            ;
        MOV     AX, CX              ;
        DIV     CS:ten              ; reverse last DX:AX = AX*10, make AX = DX:AX / 10
        MOV     CX, AX              ;
        PUTC    8                   ; backspace.
        PUTC    ' '                 ; clear last entered digit.
        PUTC    8                   ; backspace again.        
        JMP     prox_digito         ; wait for Enter/Backspace.
stop_input:                         ;
        CMP     CS:marca_menos, 0     ; check flag:
        JE      not_minus           ;
        NEG     CX                  ;
not_minus:                          ;
        POP     SI                  ;
        POP     AX                  ;
        POP     DX                  ;
        RET                         ;
marca_menos      DB      ?          ; used as a flag.
                                    ;
SCAN_NUM ENDP                       ; Fim do Procedimento
;|===========================================|  

;|===========================================|  
;|Este procedimento imprime o numero em AX   |
;|Usado com o impri_num_mult para imprimir   |
;|numeros                                    |
;|===========================================|  
impri_num PROC    NEAR              ; Inicio do Procedimento
          PUSH    DX                ;
          PUSH    AX                ;
          CMP     AX, 0             ;
          JNZ     nao_zero          ;
          PUTC    '0'               ;
          JMP     impresso          ;
nao_zero:                           ; 
          CMP     AX, 0             ; the check SIGN of AX,make absolute if it's negative:
          JNS     positivo          ;
          NEG     AX                ;
          PUTC    '-'               ;
positivo:                           ;
        CALL    impri_num_mult      ;
impresso:                           ;
        POP     AX                  ;
        POP     DX                  ;
        RET                         ;
impri_num       ENDP                ; Fim do Procedimento
;|===========================================|  

;|===========================================|  
;|Este procedimento imprime numeros  em AX   |
;|nao apenas um unico digito, valores        |
;|permitidos sao de 0 a 65535 (FFFF)         |
;|===========================================|  
impri_num_mult  PROC    NEAR        ; Inicio do Procedimento
                PUSH    AX          ;
                PUSH    BX          ;
                PUSH    CX          ;
                PUSH    DX          ;
                MOV     CX, 1       ; flag to prevent printing zeros before number:
                MOV     BX, 10000   ; (result of "/ 10000" is always less or equal to 9).     ; 2710h - divider.
                CMP     AX, 0       ; AX is zero?
                JZ      impri_zero  ;
ini_impri:                          ;
        CMP     BX,0                ; Verifica o divisor (se zero for saltar para end_imprimir):
        JZ      end_impri           ;
        CMP     CX, 0               ; Evitar a impressao de zeros antes do numero:
        JE      calc                ;
        CMP     AX, BX              ; Se AX <BX entao resultado da divisao sera zero:
        JB      pular               ;
calc:                               ;
        MOV     CX, 0               ; set flag.
        MOV     DX, 0               ;
        DIV     BX                  ; AX = DX:AX / BX   (DX=remainder).
        ADD     AL, 30h             ; imprimir o ultimo digito, sempre que ZERO ignorar e converter para codigo ASCII.
        PUTC    AL                  ;
        MOV     AX, DX              ; Obter resto da ultima divisao
pular:                              ;
        PUSH    AX                  ; calculate BX=BX/10
        MOV     DX, 0               ;
        MOV     AX, BX              ;
        DIV     CS:ten              ; AX = DX:AX / 10   (DX=remainder).
        MOV     BX, AX              ;
        POP     AX                  ;
        JMP     ini_impri           ;
impri_zero:                         ;
        PUTC    '0'                 ;
end_impri:                          ;
        POP     DX                  ;
        POP     CX                  ;
        POP     BX                  ;
        POP     AX                  ;
        RET                         ;
impri_num_mult   ENDP               ; Fim do Procedimento
;|===========================================|

;|===========================================|
;|Usado como multiplicador / divisor         |
;|pelas funcoes SCAN_NUM & impri_num_mult    |
;|===========================================|
ten     DW      10           
;|===========================================|

;|===========================================|
;|Este procedimento imprime numeros  em AX   |
;|nao apenas um unico digito, valores        |
;|permitidos sao de 0 a 65535 (FFFF)         |
;|===========================================|
GET_STRING  PROC    NEAR            ;
            PUSH    AX              ;
            PUSH    CX              ;
            PUSH    DI              ;
            PUSH    DX              ;
            MOV     CX, 0           ; Contador de caractere.
            CMP     DX, 1           ; Buffer muito pequeno
            JBE     limpar_buffer   ;
            DEC     DX              ; Reserve espaco para o ultimo zero.
;===================================; Loop eterno para obter a captura de teclas:
aguardar_tecla:                     ;
            MOV     AH, 0           ; Captura de tecla
            INT     16h             ;            
            CMP     AL, 0Dh         ; ENTER pressionando?
            JZ      sair_GET_STRING ;
            CMP     AL, 8           ; BACKSPACE pressionando?
            JNE     adicionar_buffer;
            JCXZ    aguardar_tecla  ; nothing to remove!
            DEC     CX              ;
            DEC     DI              ;
            PUTC    8               ; BACKSPACE
            PUTC    ' '             ; Limpar posicao.
            PUTC    8               ; BACKSPACE novamente
            JMP     aguardar_tecla  ;
adicionar_buffer:                   ;
            CMP     CX, DX          ; buffer is full?
            JAE     aguardar_tecla  ; if so wait for 'BACKSPACE' or 'RETURN'...
            MOV     [DI], AL        ;
            INC     DI              ;
            INC     CX              ;
            MOV     AH, 0Eh         ; Imprimir:
            INT     10h             ;
JMP     aguardar_tecla              ;
;====================================
sair_GET_STRING:                    ;
MOV     [DI], 0                     ; terminate by null:
limpar_buffer:                      ;
            POP     DX              ;
            POP     DI              ;
            POP     CX              ;
            POP     AX              ;
            RET                     ;
GET_STRING  ENDP                    ;
int 21h                             ;
;|===========================================|
