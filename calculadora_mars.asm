	.text
inicioCal:
li	$v0,4					#carrega o valor 4 no registrador especial $v0, dando um comando para informa que sera escrito na tela uma string
la	$a0,operacao				#carrega o valor do label(operação, que está na linha 90) no registrador especial $a0, fazendo com que carreguer uma string no registrador a0, que automaticamente e carregado no registror $v0
syscall 					#escreve na tela o que estiver no registrador $v0 (\n 1-SOMA \n 2-SUBTRAÇÂO \n 3-MULTIPLICAÇÂO \n 4-DIVISÂO \n 0-SAIR\n )
li	$v0,5					#carrega o valor 5 no registrador especial $v0, informando que o sera capturado da tela um valor inteiro
syscall 					#carrega o valor digitado na tela para o registrador $v0
move	$t0,$v0					#movimenta um valor inteiro do registrador $v0, para o registrador $t0(armazenando um valor em $t0)

retornaCalc:					#é uma label que será chamada caso o programa execulte a linha 67 ou 79(label é como se fosse uma variavel)
bne	$t0,0,rodaCalculadora			#verifica se o valor contido no registrador $t0 è diferente de 0, e caso seja, chama a label rodaCalculadora na linha 13
beq	$t0,0,fechaCalculadora			#verifica se o valor contido no registrador $t0 è igual a 0, e caso seja, chama a label fechaCalculadora na linha 87
rodaCalculadora:				#é uma label que é chamada caso o teste na linha 11 seja verdadeiro				
	beq	$t0,1,teste1			#testa se o valor do registrador $t0 e´igual ao valor 1,se for, chama a label teste1 na linha 24 e o programa continuará apartir de la
	beq	$t0,2,teste1			#testa se o valor do registrador $t0 e´igual ao valor 2,se for, chama a label teste1 na linha 24 e o programa continuará apartir de la
	beq	$t0,3,teste1			#testa se o valor do registrador $t0 e´igual ao valor 3,se for, chama a label teste1 na linha 24 e o programa continuará apartir de la
	beq	$t0,4,teste1			#testa se o valor do registrador $t0 e´igual ao valor 4,se for, chama a label teste1 na linha 24 e o programa continuará apartir de la
	beq	$t0,0,fechaCalculadora		#testa se o valor do registrador $t0 e´igual ao valor 0,se for, chama a label fechaCalculadora na linha 91 e o programa continuará apartir de la
	bne	$t0,1,operacaoException		#testa se o valor do registrador $t0 e´diferente ao valor 1,se for, chama a label operacaoException na linha 85 e o programa continuará apartir de la
	bne	$t0,2,operacaoException		#testa se o valor do registrador $t0 e´diferente ao valor 2,se for, chama a label operacaoException na linha 85 e o programa continuará apartir de la
	bne	$t0,3,operacaoException		#testa se o valor do registrador $t0 e´diferente ao valor 3,se for, chama a label operacaoException na linha 85 e o programa continuará apartir de la
	bne	$t0,4,operacaoException		#testa se o valor do registrador $t0 e´diferente ao valor 4,se for, chama a label operacaoException na linha 85 e o programa continuará apartir de la
	bne	$t0,0,operacaoException		#testa se o valor do registrador $t0 e´diferente ao valor 0,se for, chama a label operacaoException na linha 85 e o programa continuará apartir de la
	     teste1:				# é uma label que será chamado caso no registrador $t0 tenha o valor 1 ou 2 ou 3 ou 4
		li	$v0,4			#carrega o valor 4 no registrador especial $v0, dando um comando para informa que sera escrito na tela uma string
		la	$a0,operador1		#carrega o valor da label(operador1, que está na linha 91) no registrador especial $a0, fazendo com que carreguer uma string no registrador a0, que automaticamente e carregado no registror $v0
		syscall 			#escreve na tela o que estiver no registrador $v0 (\ndigite o primeiro n° )
		li	$v0,6			#carrega o valor 6 no registrador especial $v0, informando que o sera capturado da tela um valor float
		syscall 			#carrega o valor digitado na tela para o registrador $v0 e f0
		mov.s	$f1,$f0			#movimenta um valor float do registrador $f0, para o registrador $f1(armazenando um valor em $f1, que por se float e pego no registrador $f0 em vez de $v0)
		
		li	$v0,4			#carrega o valor 4 no registrador especial $v0, dando um comando para informa que sera escrito na tela uma string
		la	$a0,operador2		#carrega o valor da label(operador2, que está na linha 92) no registrador especial $a0, fazendo com que carreguer uma string no registrador a0, que automaticamente e carregado no registror $v0
		syscall 			#escreve na tela o que estiver no registrador $v0 (digite o segundo n°  )
		li	$v0,6			#carrega o valor 6 no registrador especial $v0, informando que o sera capturado da tela um valor float
		syscall 			#carrega o valor digitado na tela para o registrador $v0
		mov.s	$f2,$f0			#movimenta um valor float do registrador $f0, para o registrador $f2(armazenando um valor em $f2, que por se float e pego no registrador $f0 em vez de $v0)
		
		beq	$t0,1,soma		#testa se o valor do registrador $t0 é igual a 1, caso seja chama a label soma na linha 41, e execulta o programa apartir dela
			b outro			#chama a label outro na linha 43, exultando o programa a partir dessa linha
			soma: add.s $f1,$f1,$f2 #soma os valores contido nos registradores $f1 e $f2, e gurada o valor em $f1
			b nome			#chama a label nome na linha 69, exultando o programa a partir dessa linha
			outro:			#é uma label que é chamada caso a linha 41 seja execultada
			
		beq	$t0,2,subt		#testa se o valor do registrador $t0 é igual a 2, caso seja chama a label subt na linha 47, e execulta o programa apartir dela
			b outro1		#chama a label outro1 na linha 49, exultando o programa a partir dessa linha
			subt: sub.s $f1,$f1,$f2 #subtrai o valor contido no registrador $f2 de $f1, e gurada o valor em $f1
			b nome			#chama a label nome na linha 69, exultando o programa a partir dessa linha
			outro1:			#é uma label que é chamada caso a linha 48 seja execultada
			
		beq	$t0,3,multp		#testa se o valor do registrador $t0 é igual a 3, caso seja chama a label multp na linha 53, e execulta o programa apartir dela
			b outro2		#chama a label outro2 na linha 55, exultando o programa a partir dessa linha
			multp: mul.s $f1,$f1,$f2#multiplica os valores contido nos registradores $f1 e $f2, e gurada o valor em $f1
			b nome			#chama a label nome na linha 69, exultando o programa a partir dessa linha
			outro2:			#é uma label que é chamada caso a linha 55 seja execultada
			
		beq	$t0,4,divi		#testa se o valor do registrador $t0 é igual a 4, caso seja chama a label divi na linha 59, e execulta o programa apartir dela
			b outro3		#chama a label outro3 na linha 61, exultando o programa a partir dessa linha
			divi: div.s $f1,$f1,$f2 #divide o valor contido no registrador $f1 pelo valor contido em $f2, e gurada o valor em $f1
			b nome			#chama a label nome na linha 69, exultando o programa a partir dessa linha
			outro3:			#é uma label que é chamada caso a linha 62 seja execultada
			
			li	$v0,4		#carrega o valor 4 no registrador especial $v0, dando um comando para informa que sera escrito na tela uma string
			la	$a0,notOperacao #carrega o valor da label(notOperacao, que está na linha 94) no registrador especial $a0, fazendo com que carreguer uma string no registrador a0, que automaticamente e carregado no registror $v0
			syscall 		#escreve na tela o que estiver no registrador $v0 (\n operação invalida )
			
			b retornaCalc		#chama a label retornaCalc na linha 10, exultando o programa a partir dessa linha,retornando assim ao inicio da calculadora
				
		nome:				#é uma label que é chamada caso algum branch nas linhas 42,48,54 e 60 sejam execultados
			li	$v0,2		#carrega o valor 2 no registrador especial $v0, dando um comando para informa que sera escrito na tela um valor float
			mov.s	$f12,$f1	#movimenta um valor float do registrador $f1 para o registrador $f12(armazenando um valor temporario em em $f12)
			syscall 		#escreve na tela o que estiver no registrador $v0 ( exibi o resultado da operação )
			li	$v0,4		#carrega o valor 4 no registrador especial $v0, dando um comando para informa que sera escrito na tela uma string
			la	$a0,tipoOperacao#carrega o valor da label(tipoOperacao, que está na linha 93) no registrador especial $a0, fazendo com que carreguer uma string no registrador a0, que automaticamente e carregado no registror $v0
			syscall 		#escreve na tela o que estiver no registrador $v0 (\n\ntipo de operação:  )
			li	$v0,5		#carrega o valor 5 no registrador especial $v0, informando que o sera capturado da tela um valor inteiro			syscall 
			syscall			#escreve na tela o que estiver no registrador $v0 (\n\ntipo de operação: )
			move	$t0,$v0		#movimenta um valor inteiro do registrador $v0, para o registrador $t0(armazenando um valor em $t0)
			b retornaCalc		#chama a label retornaCalc na linha 10, exultando o programa a partir dessa linha,retornando assim ao inicio da calculadora
			
		operacaoException:		#é uma label que é chamada caso algum dos testes feitos entre as linhas 19 e 23 seja verdadeiros
			li	$v0,4		#carrega o valor 4 no registrador especial $v0, dando um comando para informa que sera escrito na tela uma string
			la	$a0,notOperacao #carrega o valor da label(notOperacao, que está na linha 94) no registrador especial $a0, fazendo com que carreguer uma string no registrador a0, que automaticamente e carregado no registror $v0
			syscall 		#escreve na tela o que estiver no registrador $v0 (\n operação invalida )
			b	inicioCal	#chama a label inicioCal que está la linha 2, e o programa continua a partir da label
			
fechaCalculadora:				#é uma label que é chamada caso o teste na linha 12 seja verdadeiro
			
	.data
operacao:	.asciiz  "\n 1-SOMA \n 2-SUBTRAÇÂO \n 3-MULTIPLICAÇÂO \n 4-DIVISÂO \n 0-SAIR\n"
operador1:	.asciiz	 "\ndigite o primeiro n°: " 
operador2:	.asciiz  "digite o segundo n° : "
tipoOperacao:	.asciiz  "\n\ntipo de operação: "
notOperacao:	.asciiz  "\n operação invalida"

