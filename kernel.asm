org 0x7e00
jmp 0x0000:start

data:
	
	;Dados do projeto... (onde ficam as declaracoes de variaveis)
    titulo db 'Enigmas Enigmaticos', 0
    enig1 db 'j_mamjjasond first', 0
    resposta1 db 'f', 0
    tela_venceu db 'CONGRATULATIONS! :)', 0
    tela_perdeu db 'GAME OVER! :(', 0
    enig_2 db 'qualquer coisa',0

pularLinha:
    mov dl, 31 ; dl eh a posicao da coluna da tela
    mov dh, 12 ; dh eh a posi da linha na tela
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
	
esperarEnter: 
    call lerLetra
    cmp al, 13 ;comparar se deu enter  (13 eh o enter)
        jne chamarEsperarEnter
        call clear
    ret

chamarEsperarEnter:
    call esperarEnter
    ret

printarFrase:
  	lodsb ; pega o q si ta apontando, bota no al e manda o si pra prox letra
    cmp al, 0
        je chamarEsperarEnter
    ;printando letra q leu 
    call printarLetra
    jmp printarFrase
    ret

zerarRegistradores:
	xor ax, ax
    mov ds, ax
    mov es, ax
    ret

        
telaFINAL2:
    call pularLinha
	mov si, tela_perdeu 
   	call printarFrase
   

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

    ;ler letra
   	; mov ah, 0
   	; int 16h

    ;printando letra q leu
    ;mov ah, 0xe
    ;int 10h
    ;jmp .ler ;a funcao q eu usar c jmp eu n coloco ret

    .telaTitulo:
	    call pularLinha
      	mov si, titulo
      	call printarFrase
    	;vai esperar espaço
    
	;quando clicar no espaço, pular pra telaEnig1
  	.telaEnig1:
      	call pularLinha
	  	mov si, enig1
   		call printarFrase

    .verificarResposta1:
    ;ler letra
   	    call lerLetra
    ;printando letra q leu
        call printarLetra
        cmp al, 'f'
            jne .telaFINAL2
    
    ;essas funcoes vao ser chamadas dentro da comparacao das respostas
    .telaFINAL1:
        call chamarEsperarEnter
        call pularLinha
	    mov si, tela_venceu
   	    call printarFrase
        jmp start

    .telaFINAL2:
        call chamarEsperarEnter
        call pularLinha
	    mov si, tela_perdeu 
   	    call printarFrase
    

    jmp start ;volta para o inicio do jogo
     
;missao: transformar o .pularlinha em uma função call
jmp $ ; acabar o codigo