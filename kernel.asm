org 0x7e00
jmp 0x0000:start

data:
	
	resposta times 20 db 0 ;declarei a string q vai ser a resposta do cara
    
    ;tela inicial
    titulo db 'Enigmas Enigmaticos', 0
    ;tela 1 enigma
    enig1 db 'j_mamjjasond', 0
    solucaoEnig1 db 'fevereiro', 0
    ;tela venceu
    tela_venceu db 'CONGRATULATIONS! :)', 0
    ;tela perdeu
    tela_perdeu db 'GAME OVER! :(', 0
    enig_2 db 'qualquer coisa',0

setarCursor:
    mov dl, 31 ; dl eh a posicao da coluna da tela
    mov dh, 12 ; dh eh a posi da linha na tela
    ;interrupcao pra ajustar
    mov ah, 02h
    mov bh, 0
    int 10h
    ret

pularLinha:
    mov dl, 31 ; dl eh a posicao da coluna da tela
    add dh, 3; dh eh a posi da linha na tela
    ;interrupcao pra ajustar
    mov ah, 02h
    mov bh, 0
    int 10h
    ret

;função de limpar a tela
clear:
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
  	lodsb ;
    cmp al, 0
        je .fim
    call printarLetra
    jmp printarFrase
    .fim:
        ret

esperarEnter: 
    call lerLetra
    cmp al, 13 ;comparar se deu enter  (13 eh o enter)
        jne esperarEnter
        call clear
    ret

zerarRegistradores:
	xor ax, ax
    mov ds, ax
    mov es, ax
    ret
        
guardarResposta:               
 	 xor cx, cx          
 	.for:
 		call lerLetra
 	    cmp al, 13  
 	        je .terminar
 	    cmp cl, 10       
 	        je .for

 	stosb ;usa di pra guardar a entrada
 	inc cl
 	call printarLetra
    
    jmp .for
    .terminar:
        dec cl
        mov al, 0
        stosb
        ;call endl
    ret
    
compararResposta: ;vai comparar o que ta no si e no di
    .for:
        lodsb
        cmp al, byte[di]
            jne telaPerdeu
        cmp al, 0
            je telaGanhou
        inc di ;ir pro próximo byte
    jmp .for
    ret
  
telaPerdeu:
        ;call esperarEnter
        call clear
        call setarCursor
        mov bl, 4
	    mov si, tela_perdeu 
   	    call printarFrase
        call esperarEnter
        ret

telaGanhou:
        ;call esperarEnter
        call clear
        call setarCursor
        mov bl, 10
	    mov si, tela_venceu
   	    call printarFrase
        call esperarEnter
        jmp start
        ret

start:
  	;zerar registradores
    call zerarRegistradores

    call clear

    ;como botei o modo 13, ele vai setar a cor da letra
    mov ah, 0bh
    mov bh, 0
    mov bl, 00 ; cor
    int 10h ; 

    ;setando a cor da letra / o 13 seta a cor da letra
    mov ah, 0h
    mov al, 13h
    mov bl, 11 ;cor


    .telaTitulo:
	    call setarCursor
      	mov si, titulo
      	call printarFrase
        call esperarEnter
    
	;quando clicar no enter, pular pra telaEnig1
  	.telaEnig1:
      	call setarCursor
	  	mov si, enig1 
   		call printarFrase
        call pularLinha
        mov bl, 4
        mov di, resposta
        call guardarResposta
        mov di, resposta ;apontando onde deve guardar o valor de di (a resposta)
        mov si, solucaoEnig1
        call compararResposta

    jmp start ;volta para o inicio do jogo
     
;missao: transformar o .pularlinha em uma função call
jmp $ ; acabar o codigo