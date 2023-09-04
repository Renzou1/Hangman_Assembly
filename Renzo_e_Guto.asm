.data

	menu: .asciiz "Bem vindo. Escolha o modo de jogo:\n1. modo padrao\n2. escolher palavra.\n3. Sair\n"
	palavra1: .asciiz "teste"
	palavra2: .asciiz "voce"
	palavra3: .asciiz "ganhou"
	char: .byte
	saiu: .asciiz "Usuario saiu.\n"
	acertou_string: .asciiz "Voce acertou a palavra!\n"
	current_word: .ascii
	

.text
	li $t1, 1
	li $t2, 2
	
	la $a0, menu
	li $v0, 4 # print string
	syscall
	
	li $v0, 5 # read integer
	syscall
	
	beq $v0, $t1, padrao  # se for 1
	beq $v0, $t2, modo2 # se for 2
	j end #se for outro
	
padrao:	la $a3, palavra1 # carregando argumento
	jal padrao_f
	la $a3, palavra2
	jal padrao_f
	la $a3, palavra3
	jal padrao_f

padrao_f:
	move $t0, $a3 # endereco fica no t0
	li $t2, 0 # teste pra ver se acertou
	li $t4, 45 # ascii de -
	la $t5, current_word
	
	lb $t3, 0($t0) 	#criando current_word com tamanho da palavra (-----), nao sei oq aconteceria com palavra vazia
loop1:	sb $t4, 0($t5) 
	addi $t0, $t0, 1
	addi $t5, $t5, 1
	lb $t3, 0($t0)  
	bne $t3, $zero, loop1 

print:	li $v0, 4 # print string
	la $a0, current_word
	syscall

	li $v0, 8 # ler char + new line + \0
	la $a0, char
	li $a1, 3
	syscall

	lb $t6, char  # t6 = caracter lido
	#subi $t6, $t6, 2560   # tirando valor do enter do char
	
	move $t0, $a3  # t0 = endereco da palavra certa
	la $t5, current_word # t5 = iterador da current word
	la $t7, current_word # t7 = começo da current word
	
loop2:	lb $t3, 0($t0)  # carrega char atual da palavra certa
	beq $t3, $zero, check # se chegou no fim
	bne $t3, $t6, wrong # se caracter nao eh igual a lido
	# se eh igual a lido:
	sb $t6, 0($t5) # escreve caracter certo na current word
	addi $t2, $t2, 1 # mostra que acertou pra nao contar erro (erro ainda nao implementado)
	
wrong:	addi $t5, $t5, 1 # iterador
	addi $t0, $t0, 1  # iterador
	j loop2
	
check:	lb $t1, 0($t7)
	beq $t1, $zero, acertou
	addi $t7, $t7, 1 # itera
	bne $t1, $t4, check # ve se tem algum -
	j print
	
acertou:li $v0, 4 # print string
	la $a0, acertou_string
	syscall	


modo2:	

ganhou:

end:	la $a0, saiu
	li $v0, 4 # print string
	syscall
