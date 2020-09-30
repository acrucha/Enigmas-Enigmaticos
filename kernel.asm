org 0x7e00
jmp 0x0000:start

data:
	
	;string que vai guardar a resposta do usuário
    resposta times 20 db 0 
    
    ;tela inicial
    titulo db 'Enigmas Enigmaticos', 0
    aperteEnter db 'aperte Enter para continuar', 0

    ;tela de instrução
    instrucoes db 'Dicas de como jogar:', 0
    instrucao_0 db '1.Apos cada resposta aperte enter para continuar.', 0
    instrucao_1 db '2.Observe atentamente cada dica.', 0
    instrucao_2 db '3.Erros nao serao permitidos.', 0
    instrucao_3 db '4.Lembre-se: o google eh seu amigo!!!!!!!!!!!!!', 0
    instrucao_4 db '5.Boa sorte S2', 0

    ;tela enigma 1
    enig1 db 'j_mamjjasond', 0
    solucaoEnig1 db 'fevereiro', 0

    ;tela enigima 2
    enig2 db 'AMBICODJEOF GCHOIMJ',0
    enig2_1 db 'KSLAMLNSOIPCQHRAS',0
    solucaoEnig2 db 'miojo com salsicha', 0

    ;tela enigma 3
    enig3 db 'www aa w dd ww d ss dd s aa sss a',0
    solucaoEnig3 db 'cruz', 0

    ;tela enigma 4
    enig4 db '   Alfabeto', 0
    enig4_1 db '  (25-6) (7+8) (22-10) (10+10) (1/1)', 0
    enig4_2 db '      (19-4) (26-13) (18/2) (5-2)',0
    ;enig4_2 db '', 0
    solucaoEnig4 db 'solta o mic', 0

    ;tela enigma 5 
    enig5 db 'X 0 X 11 X 10 X 4 X 16 X  19  X', 0
    enig5_1 db '8 9 8 -2 7 -1 6 5 4 -7 1 -10 -4', 0
    solucaoEnig5 db 'fibonacci', 0

    ;tela venceu
    tela_venceu db 'CONGRATULATIONS! :)', 0

    ;tela perdeu
    tela_perdeu db 'GAME OVER! :(', 0

ajustarVideo:;atualiza na tela as mudanças de video (interrupção)
    mov ah, 02h
    mov bh, 0
    int 10h ;interrupção de video
    ret
 
setarCursor: ;seta o cursor no centro da tela
    mov dl, 31 ; posição da coluna da tela
    mov dh, 12 ; posição da linha na tela
    call ajustarVideo
    ret

setarCursor2:
    mov dl, 25 ; posição da coluna da tela
    mov dh, 12 ; posição da linha na tela
    call ajustarVideo
    ret

setarEnter: ;seta o cursor no fim da tela
    mov dl, 27 ; posição da coluna na tela
    mov dh, 25 ; posição da linha na tela
    call ajustarVideo
    ret

pularLinhaI:
    add dh, 2  ; posição da linha na tela
    call ajustarVideo
    ret

pularLinha:
    add dh, 3  ; aumenta a posição da linha na tela
    call ajustarVideo
    ret

clear: ;limpa a tela
    mov ah, 0h
    mov al, 12h
    int 10h
    ret

lerLetra:
	mov ah, 0
	int 16h
	ret

printarLetra:
	mov ah, 0xe
	int 10h
	ret

printarFrase:
  	lodsb ; move do si para al
    cmp al, 0 ;se a string chegar ao fim
        je .fim
    call printarLetra
    jmp printarFrase
    .fim:
        ret

esperarEnter: 
    call lerLetra
    cmp al, 13 ; comparar se usuário deu enter (13 é o enter)
        jne esperarEnter
        call clear
    ret

zerarRegistradores:
	xor ax, ax
    mov ds, ax
    mov es, ax
    ret
        
guardarResposta:               
 	 xor cx, cx     ; zera registrador         
 	.for:
 		call lerLetra
        cmp al, 0x08; backspace
 		    je .apagar
 	    cmp al, 13  ; enter
 	        je .terminar
 	    cmp cl, 20  ; tam max de resposta    
 	        je .for
 	    stosb       ; usa di pra guardar a entrada
 	    inc cl
 	    call printarLetra
    jmp .for
    .apagar:
      cmp cl, 0     ; se a resposta estiver vazia    
        je .for
      dec di        ; volta um byte
      dec cl        
      mov byte[di], 0
      call apagarLetra
    jmp .for
    .terminar:
        dec cl
        mov al, 0
        stosb
    ret

apagarLetra:
	mov al, 0x08          ; backspace
 	call printarLetra
 	mov al, ' '
 	call printarLetra
 	mov al, 0x08         
 	call printarLetra
 	ret

compararResposta: ;vai comparar o que ta no si(gabarito) e no di(resp usuario)
    .for:
        lodsb
        cmp al, byte[di]
            jne telaPerdeu
        cmp al, 0
            je .sair
        inc di ;ir pro próximo byte
    jmp .for

    .sair
        ret
  
telaPerdeu:
    call clear
    call setarCursor
    mov bl, 4 ; letra vermelha
	mov si, tela_perdeu 
   	call printarFrase
    mov si, aperteEnter
    call setarEnter
    call printarFrase
    call esperarEnter
    jmp start ; volta para o começo do jogo depois do Enter
    ret

telaGanhou:
    call clear
    call setarCursor
    mov bl, 10 ; letra verde
	mov si, tela_venceu
   	call printarFrase
    mov si, aperteEnter
    call setarEnter
    call printarFrase
    call esperarEnter
    jmp start
    ret

start:
  	;zerar registradores
    call zerarRegistradores
    call clear

    ;setando modo video
    mov ah, 0h
    mov al, 13h
    mov bl, 11 ; letra azul


    .telaTitulo:
	    call setarCursor
      	mov si, titulo
      	call printarFrase
        mov si, aperteEnter
        call setarEnter
        call printarFrase
        call esperarEnter
    
    .telaInstrucao:
        call clear
	    mov dl, 12 ; posição da coluna na tela
        mov dh, 5 ; posição da linha na tela
        call ajustarVideo
        
        mov si, instrucoes
        call printarFrase
        call pularLinhaI
        call pularLinhaI
      	mov si, instrucao_0
      	call printarFrase
        call pularLinhaI
        mov si, instrucao_1
        call printarFrase
        call pularLinhaI
        mov si, instrucao_2
        call printarFrase
        call pularLinhaI
        mov si, instrucao_3
        call printarFrase
        call pularLinhaI
        mov si , instrucao_4
        call printarFrase
        mov si, aperteEnter
        call setarEnter
        call printarFrase

        call esperarEnter
    
  	.telaEnig1:
      	call setarCursor
	  	mov si, enig1 
   		call printarFrase
        call pularLinha ;centro +3
        mov bl, 4         ;letra vermelha
        mov di, resposta
        call guardarResposta
        mov di, resposta ;apontando onde deve guardar o valor de di (a resposta)
        mov si, solucaoEnig1
        call compararResposta

    .telaEnig2:
      	call setarCursor
        mov bl, 11
	  	mov si, enig2 
   		call printarFrase
        call pularLinha
        mov si, enig2_1 
   		call printarFrase
        call pularLinha
        mov bl, 4         ;muda a cor da letra
        mov di, resposta
        call guardarResposta
        mov di, resposta ;apontando onde deve guardar o valor de di (a resposta)
        mov si, solucaoEnig2
        call compararResposta

    .telaEnig3:
        call clear
      	call setarCursor2
        mov bl, 11; volta a cor pra azul
	  	mov si, enig3
   		call printarFrase
        call pularLinha
        mov bl, 4 ;muda a cor da letra pra vermelho
        mov di, resposta
        call guardarResposta
        mov di, resposta ;apontando onde deve guardar o valor de di (a resposta)
        mov si, solucaoEnig3
        call compararResposta

    .telaEnig4:
        call clear 
        call setarCursor
        mov bl, 11      ; volta a cor pra azul
	  	mov si, enig4
   		call printarFrase
        mov dl, 20      ; altero a coluna
        call pularLinha
        mov si, enig4_1
        call printarFrase
        call pularLinha
        mov si, enig4_2
        call printarFrase
        call pularLinha
        mov bl, 4        ; muda a cor da letra pra vermelho
        mov di, resposta
        call guardarResposta
        mov di, resposta ;apontando onde deve guardar o valor de di (a resposta)
        mov si, solucaoEnig4
        call compararResposta

    .telaEnig5:
        call clear
        call setarCursor2
        mov bl, 11       ; letra azul
	  	mov si, enig5 
   		call printarFrase
        add dh, 1
        call ajustarVideo
        mov si, enig5_1 
   		call printarFrase
        call pularLinha
        mov bl, 4        ; muda a cor da letra pra vermelho
        mov di, resposta
        call guardarResposta
        mov di, resposta ; apontando onde deve guardar o valor de di (a resposta)
        mov si, solucaoEnig5
        call compararResposta

    call telaGanhou

jmp $