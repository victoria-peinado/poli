.data
varOrigen: .word 0    # La direccion de varilla A
varDestino: .word 0    # La direccion de varilla B
varAuxiliar: .word 0    # La direccion de varilla C

msg1: .asciiz "Ingrese la Cantidad de discos en el juego  "

.text

main:
  la $a0, msg1
  li $v0, 4
  syscall

  li $v0, 5
  syscall

  addi $a0, $v0, 0

  jal inicializarVarillas

  li $v0, 10
  syscall


#####################################



# Le da espacio a todas las varillas y pone el juego en el estado inicial
# $a0 - Cantidad de discos en juego.
#####################################
inicializarVarillas:

  addi $t0, $a0, 0
  la $t1, varOrigen
  la $t2, varDestino
  la $t3, varAuxiliar
  li $t4, 0
  addi $t5, $t0, 0
  
  mul $a0, $a0, 4
  addi $a0, 1
  li $v0, 9
  syscall
  sw $v0, 0($t1)

  lw $t6, 0($t1)
  LoopOrigen:
    sw $t0, 0($t6)
    addi $t6, 32
    addi $t0, -1
    bne $t0, $0, FinLoopOrigen
    j LoopOrigen
  FinLoopOrigen:
  sw $t4, 0($t6)

  li $v0, 9
  syscall
  sw $v0, 0($t2)

  lw $t6, 0($t2)
  addi $t0, $t5, 0
  LoopDestino:
    sw $t4, 0($t6)
    addi $t6, 32
    addi $t0, -1
    bne $t0, $0, FinLoopDestino
    j LoopDestino
  FinLoopDestino:
  sw $t4, 0($t6)

  li $v0, 9
  syscall
  sw $v0, 0($t3)

  lw $t6, 0($t3)
  addi $t0, $t5, 0
  LoopAuxiliar:
    sw $t4, 0($t6)
    addi $t6, 32
    addi $t0, -1
    bne $t0, $0, FinLoopAuxiliar
    j LoopAuxiliar
  FinLoopAuxiliar:
  sw $t4, 0($t6)
  
  jr $ra
#####################################
# No retorna nada
