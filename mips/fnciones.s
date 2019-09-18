##################################################
.data
nl: .asciiz "\n"
prompt1: .asciiz "\nElija que hacer:\n"
prompt2: .asciiz"[a] - Agregar nodo\n"
prompt3: .asciiz"[f] - Find max\n"
prompt4: .asciiz"[p] - Mostrar arbol\n"
prompt5: .asciiz"[i] - Mostrar arbol inorder\n"
prompt6: .asciiz"[q] - Quit\n"
prompt7: .asciiz"\nEscriba un caracter: "
empty: .asciiz"\nEl arbol esta vacio."
youentered: .asciiz"\nYou Entered: "
recordfound: .asciiz"\nRecord Found: "
recordnotfound: .asciiz"\nRecord Not Found! "
addid: .asciiz"\nIngrese la prioridad del nodo: "
addyear: .asciiz"Ingresa un entero: "
id: .asciiz"\nPrioridad: "
year: .asciiz"\nDato: "
######################################
#   $a1 - Puntero al nodo root
#
#   
#   Cada nodo tiene 32 Bytes:
#   8 Bytes - [ID]
#   8 Bytes - [DireccionLista]
#   8 Bytes - [DireccionLeft]
#   8 Bytes - [DireccionRight]
#
######################################
.text 
main:

li $a1, 0
#addi $sp, $sp, -4	#pide espacio en el stack
#sw  $a1, 0($sp)		#guarda en el stack 
###################
##Prompt Function##
###################
prompt:
li $v0, 4
la $a0, prompt1         #Elija que hacer
syscall

li $v0, 4
la $a0, prompt2         #[A] - Agregar nodo
syscall

li $v0, 4
la $a0, prompt3         #[F] - Find max
syscall

li $v0, 4
la $a0, prompt4         #[P] - Mostrar arbol
syscall

li $v0, 4
la $a0, prompt5         #[I] - Mostrar arbol inorder
syscall

li $v0, 4
la $a0, prompt6         #[Q] - Quit
syscall
###################
##Get User Input ##
################### 
getinput:   
li $v0, 4           #Escriba un caracter:
la $a0, prompt7
syscall

li $v0, 12          #Espera un caracter
syscall

move $s0, $v0

bne $s0, 97, c1     # 'a'	
jal addrecord 
c1:
bne $s0, 102, c2   	#'f'
jal findrecord 
c2:	
bne $s0, 105, c3    #'i'	
jal inorder
c3:
bne $s0, 113, c4    #'q'
li $v0, 10          #Fin
syscall
c4:
li $v0, 4           
la $a0, nl          
syscall

j getinput          #else te pide ingresar caracter otra vez

###################
## Add A Record  ##
###################
addrecord:
	addi $sp, $sp, -4	#pide espacio en el stack
	sw  $a1, 0($sp)		#guarda en el stack
	
	li $v0, 9           
	li $a0, 32   		#reservo memoria para mi nodo
	syscall
	
	move $s0, $v0       #s0 direccion de la memoria reservada

	li $v0, 4           
	la $a0, addid
	syscall				#Ingrese la prioridad del nodo

	li $v0, 5           #espera integer
	syscall

	sw $v0, 0($s0)      #guarda la prioridad en el bloque de memoria pedido

	li $v0, 4           #ingrese un entero
	la $a0, addyear
	syscall

	li $v0, 5           #espera integer
	syscall

	sw $v0, 4($s0)      #store year into our memory Offset: 4

	bne $a1, 0, setlocations    #if this isn't root node let's set the locations
	lw  $s0, 0($sp)     #store this address as root node for now
	jr $ra
		########################
		##Set Memory Locations##
		########################
		setlocations:
		move $s6, $a1           #Keep $a1 as  our root and use $s6 as temporary storage
		move $s4, $s6           #Use $s4 to find the null node slot
			storelocations:
			beqz $s4, store         #If we've reached a leaf, store
			lw $t2, 0($s4)          #get prioriti from current node
			lw $t1, 0($s0)          #get Current prioriti from new node node we're adding
			ble $t1,$t2,goleft      #get left location if new node <= current node
			move $s6, $s4
			lw $s4, 16($s4)        #get node to the right if new node > current node
			li $t3, 16         #be ready to store to the right slot
			j storelocations
				goleft:
				move $s6, $s4
				lw $s4, 8($s4)        #load the node to the left
				li $t3, 8         #be ready to store to the left slot
				j storelocations
				store:
				beq $t3, 16, storeright    #if $t3 was set to storeRight, then store to the right
				sw $s0, 8($s6)        #else store the new node's location into our node's left slot
				
				jr $ra          #back to the main
				storeright:
				sw $s0, 16($s6)        #store new node to the right slot
				
				jr $ra           #back to the main
##############################
## Find Record by prioriti  ##
##############################
findrecord:
move $s6, $s5
bne $s5, 0, search 
li $v0, 4           	#else esta vacio
la $a0, empty           
syscall
jr $ra            #va al menu

#####################################
#
#   The Inorder Function
#
#####################################
inorder:
lw  $s5, 0($sp)
beq $s5, 0, treeempty       #If the tree is empty display empty message
move $s6, $s5           #$s6 is the record we're currently at
move $t0, $s6           #t0 will iterate $s6 is our starting node
move $t1, $t0           #t1 will be thrown on the stack to keep track of everything
jal printinorder
j prompt
printinorder:
addi $sp, $sp, -12      #allocate 12 bytes for the stack
sw $ra, 0($sp)          #4 for the $ra variable
sw $t1, 4($sp)          #4 for $t1

bne $t0, 0, dontreturn      #if $t0 isn't null don't return
lw $ra, 0($sp)          #otherwise:
lw $t1, 4($sp)          #pop stack
addi $sp, $sp, 12       #and prepare
jr $ra              #to return
dontreturn:
move $t1, $t0           #put $t0 in $t1
lw $t0, 8($t0)        #load the next pointer to the left
jal printinorder        #and recurse back to printorder
move $s6, $t1           #if we're back here, it's time to print
j goprint           #so go print
afterprint:
move $t0, $t1           #after we print, move $t1 back to $t0
lw $t0, 16($t0)        #get the next pointer to the right
jal printinorder        #recurse to see if it's the last one
move $s6, $t1           #if we made it here, it is, let's print
beq $s6, $t1, done      #if we already printed this one, we're done (Root Node)
j goprint           #Go print the node to the right
done:
lw $ra, 0($sp)          #if we're done, pop our stack
lw $t1, 4($sp)          #clean it up
addi $sp, $sp, 12       #12 bytes worth
jr $ra              #and return
goprint:
li $v0, 4           #Print ID:
la $a0, id
syscall

li $v0, 1           #Print the ID stored at $s6     [Offset: 0]
lw $a0, 0($s6)
syscall

li $v0, 4           #Print Year:
la $a0, year
syscall

li $v0, 1           #Print the Year stored at $s6   [Offset: 4]
lw $a0, 4($s6)
syscall


j afterprint
