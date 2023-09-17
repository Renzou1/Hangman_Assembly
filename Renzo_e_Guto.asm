.data
	char: .byte 
	menu: .asciiz "Bem vindo. Escolha o modo de jogo:\n1. modo padrao\n2. escolher palavra\n3. Sair\n"
	palavra1: .asciiz "dados"
	palavra2: .asciiz "pipeline"
	palavra3: .asciiz "assembly"
	palavra4: .asciiz "compilador"
	palavra5: .asciiz "registradores"
	palavra6: .asciiz "microprocessador"
	fim: .asciiz "Fim de jogo.\n"
	acertou_string: .asciiz "Voce acertou a palavra!"
	proxima_string: .asciiz " Proxima:\n"
	vidas: .asciiz "\nvidas: "
	barra_n: .asciiz "\n"
	perdeu_string: .asciiz "Voce perdeu.\n"
	digite_string: .asciiz "Digite a palavra.\n"
	custom_string: .asciiz
	empty: .space 20
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
	
	li $v0, 4 # escreve o "Proxima:"
	la $a0, proxima_string
	syscall
	la $a3, palavra2
	jal padrao_f
	
	li $v0, 4
	la $a0, proxima_string
	syscall
	la $a3, palavra3
	jal padrao_f
	
	li $v0, 4
	la $a0, proxima_string
	syscall
	la $a3, palavra4
	jal padrao_f
	
	li $v0, 4
	la $a0, proxima_string
	syscall
	la $a3, palavra5
	jal padrao_f
	
	li $v0, 4
	la $a0, proxima_string
	syscall
	la $a3, palavra6
	jal padrao_f
	j end

padrao_f:
	move $t0, $a3 # endereco fica no t0
	li $t2, 0 # teste pra ver se acertou
	li $t4, 45 # ascii de -
	la $t5, current_word
	li $t8, 7 # t8 = vidas
	li $t9, 10 # new line in ascii
	
	lb $t3, 0($t0) 	#criando current_word com tamanho da palavra (-----), nao sei oq aconteceria com palavra vazia
loop1:	sb $t4, 0($t5) 
	addi $t0, $t0, 1
	addi $t5, $t5, 1
	lb $t3, 0($t0)
	beq $t3, $t9, nline
	bne $t3, $zero, loop1 

nline:	sb $zero, 0($t0) # remove new line if exists
	
print:	
	li $v0, 4 # print string
	la $a0, current_word
	syscall
	la $a0, vidas
	syscall
	la $v0, 1
	move $a0, $t8
	syscall
	li $v0, 4
	la $a0, barra_n
	syscall

	li $v0, 8 # ler char + new line + \0
	la $a0, char
	li $a1, 3
	syscall

	lb $t6, char  # t6 = caracter lido
	
	move $t0, $a3  # t0 = endereco da palavra certa
	la $t5, current_word # t5 = iterador da current word
	la $t7, current_word # t7 = começo da current word
	
loop2:	lb $t3, 0($t0)  # carrega char atual da palavra certa
	beq $t3, $zero, check # se chegou no fim
	bne $t3, $t6, wrong # se caracter nao eh igual a lido
	# se eh igual a lido:
	sb $t6, 0($t5) # escreve caracter certo na current word
	addi $t2, $t2, 1 # mostra que acertou pra nao contar erro
	
wrong:	addi $t5, $t5, 1 # iterador
	addi $t0, $t0, 1  # iterador
	j loop2
	
check:	lb $t1, 0($t7)
	beq $t1, $zero, acertou
	addi $t7, $t7, 1 # itera
	bne $t1, $t4, check # ve se tem algum -
	bne $t2, $zero, skip  # se nao errou 
	addi $t8, $t8, -1 # diminui vidas
	beq $t8, $zero, perdeu  # se vidas == 0
skip:	move $t2, $zero
	j print
	
acertou:li $v0, 4 # print string
	la $a0, acertou_string
	syscall
	jr $ra


modo2:	li $v0, 4 # print string
	la $a0, digite_string
	syscall
	li $v0, 8 # read string
	la $a0, custom_string
	li $a1, 20
	syscall
	la $a3, custom_string
	jal padrao_f
	j end

perdeu:	li $v0, 4
	la $a0, perdeu_string	
	syscall
	move $a3, $v0
	jal padrao_f

end:	li $v0, 4 # print string
	la $a0, fim
	syscall
