.data
msg1: .asciiz "Entre un numero:"
msg2: .ascii "El numero en hexa es: 0x"
msg3: .asciiz "00000000\n"
msg4: .asciiz "El signo es: 0x"
msg5: .ascii "\nEl exponente en exceso es: 0x"
msg6: .asciiz "00\n"
hexa: .ascii "0123456789ABCDEF"
msg7:.ascii "La matiza es: 0x"
msg8: .asciiz "000000\n"
msg9: .ascii "El exponente es: 0x"
msg10: .asciiz "00\n"

.text
main: li $v0, 4
      la $a0, msg1
      syscall		#imprime mensaje  "Entre un numero:"

      li $v0, 6 
      syscall		#espera un float

      mfc1 $a0, $f0
      la $a1, msg3	#carga en a0 la direccion de "00000000\n"
      jal i2hs		#va a la funcion i2hs

    
      li $v0, 4
      la $a0, msg2
      syscall		#imprime  "El numero en hexa es: 0x" y el hexa

      li $v0, 4
      la $a0, msg4
      syscall		#imprime mensaje  "El signo es: 0x"

  
      jal signo		#va a la funcion signo


      li $v0, 1
      syscall		#imprime el signo
      
      jal expoe		#va a la funcion expoe 
      li $v0, 4
      la $a0, msg5
      syscall

      jal expo		#va a la funcion expo
      li $v0, 4
      la $a0, msg9
      syscall		#imprime  "El exponente es: 0x" y el hexa

      jal mat		#va a la funcion mat
      li $v0, 4
      la $a0, msg7
      syscall		#imprime  "La matiza es: 0x" y el hexa

      li $v0, 10
      syscall		#finaliza el programa
      

# combierte a hexa
i2hs: addi $sp, $sp, -8	#pide espacio en el stack
      sw  $a1, 0($sp)	
      sw  $a0, 4($sp)	#guarda en el stack 
      la   $t1, hexa
      li   $t2, 8
      addi $a1, $a1, 7	#mueve a1 a la pos 7 del array 
L1:   andi $t0, $a0, 0xf
      add  $t3, $t0, $t1      
      lb   $t4, 0($t3)
      sb   $t4, 0($a1)
      srl  $a0, $a0, 4
      addi $a1, $a1, -1
      addi $t2, $t2, -1
      beqz $t2, E1
      j L1
E1:   lw  $a1, 0($sp)
      lw  $a0, 4($sp)
      jr $ra
#te da el signo en hexa
signo:  lw  $a0, 4($sp)	#carga lo que estaba en la pila
        srl $a0, $a0, 31
        andi $t0, $a0, 1
        move $a0, $t0
        jr $ra
#te da el exponente en exceso en hexa
expoe:  lw  $a0, 4($sp)
        
        srl $a0, $a0, 23
        andi $a0, $a0,0xff
        move $t7, $ra
	la   $t1, hexa
        li   $t2, 2
        la $a1,msg6
        addi $a1, $a1, 1
        jal L2
        move $ra, $t7
        jr $ra
#te da el exponente en hexa
expo:   lw  $a0, 4($sp)
        
        srl $a0, $a0, 23
        andi $a0, $a0,0xff
        
        sub $a0, $a0, 0x7f        
        move $t7, $ra
	la   $t1, hexa
        li   $t2, 2
        la $a1,msg10
        addi $a1, $a1, 1
        jal L2
        move $ra, $t7
        jr $ra

L2:     andi $t0, $a0, 0xf
        add  $t3, $t0, $t1      
        lb   $t4, 0($t3)
        sb   $t4, 0($a1)
        srl  $a0, $a0, 4
        addi $a1, $a1, -1
        addi $t2, $t2, -1
        beqz $t2, E2
        j L2
E2:     jr $ra
#te da la mantiza en hexa
mat: lw  $a0, 4($sp)
        sll  $a0, $a0, 9
        srl  $a0, $a0, 9
        la   $t1, hexa
        li   $t2, 6
        la $a1,msg8
        addi $a1, $a1, 5
L3:     andi $t0, $a0, 0xf
        add  $t3, $t0, $t1      
        lb   $t4, 0($t3)
        sb   $t4, 0($a1)
        srl  $a0, $a0, 4
        addi $a1, $a1, -1
        addi $t2, $t2, -1
        beqz $t2, E3
        j L3
E3:     jr $ra
     jr $ra
     
        
