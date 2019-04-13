@SoftDrinkMachineARM
@ Use these command to assemble, link and run this program
@    as -o SoftDrinkMachineARM.o SoftDrinkMachineARM.s
@    gcc -o SoftDrinkMachineARM SoftDrinkMachineARM.o
@    ./SoftDrinkMachineARM ;echo $?

.global main

main:

@Initialize registers to starting values 
@r2=coinInput used for user input of char representing coins

@r3 = used for comparisons

@r4=inputTotal used for totaling int value of coinInput
  mov r4,#0

@r5=cInventory used for coke inventory, set cInventory=5
  mov r5,#5                 

@r6=sInventory used for sprite inventory, set sInventory=5
  mov r5,#5                 
 
@r7=pInventory used for dr. pepper inventory, set pInventory=5
  mov r5,#5                 

@r8=dInventory used for diet coke inventory, set dInventory=5
  mov r5,#5                 

@r9=mInventory used for mellow yellow inventory, set mInventory=5
  mov r5,#5                

@Display a welcome message and instructions
display:

  ldr r0, =welcomeMessage
  bl printf

@Display input instructions and read coin input
input:
  ldr r0, =instructionMessage
  bl printf

  ldr r0, =coinInputPattern @set up to read in one character
  ldr r1, =coinInput        @load r1 with the address of where input value will be stored
  bl scanf                  @scan the keyboard

@Test print coinInput
printTest:
  ldr r2, =coinInput        @ Put the address of the input value into r2
  ldr r1,[r2]               @ Read the contents of charInput and store in r1 so that it can be printed
  ldr r0, =printTestCharacter
  bl printf

@Verify coin input is valid by comparing user input to ascii values of accepted change
inputValidate:
  ldr r2, =coinInput        @ Put the address of the input value into r2  
  ldr r3, [r2]              @r2 contains coinInput, put address of input into r3
  
  cmp r3, #66               @Compare coinInput to ascii value of B
  beq bill                   @if equal to B, branch to bill

  cmp r3, #68               @Compare coinInput to ascii value of D
  beq dime                   @if equal to D, branch to dime

  cmp r3, #78               @Compare coinInput to ascii value of N
  beq nickel                 @if equal to N, branch to nickel

  cmp r3, #81               @Compare coinInput to ascii value of Q
  beq quarter                @if equal to Q, branch to quarter

@Print invalid input message, branch back to input
invalid:                    @if reach this label, coinInput is invalid
  ldr r0, =invalidInputMessage
  bl printf
  b input

@Update inputTotal and Display
bill:
  add r4, r4, #100            @add 100 cents to r4 which contains inputTotal
  ldr r0, =inputTotalDisplay
  mov r1, r4
  bl printf
  b selection

dime:
  add r4, r4, #10             @add 10 cents to r4 which contains inputTotal
  ldr r0, =inputTotalDisplay
  mov r1, r4
  bl printf
  b totalCheck

nickel:
  add r4, r4, #5              @add 5 cents to r4 which contains inputTotal
  ldr r0, =inputTotalDisplay
  mov r1, r4
  bl printf
  b totalCheck

quarter:
  add r4, r4, #25             @add 25 cents to r4 which contains inputTotal
  ldr r0, =inputTotalDisplay
  mov r1, r4
  bl printf
  b totalCheck

@Check if input amount >= 55 cents, if so make a drink selection
totalCheck:
  cmp r4, #55                 @Compare r4 which contains inputTotal to 55 cents
  blt input                   @if less than 55, branch to input again

  b selection

@Allow user to make a drink selection
selection:
  ldr r0, =selectionMessage
  bl printf



@*******************
@ End of code. Force the exit and return control to OS
myexit:

  mov r7, #0x01 @SVC call to exit
  svc 0         @Make the system call.

@Data
.data

@Printed Messages
  .balign 4
  welcomeMessage: .asciz "Welcome to Liv's soft drink vending machine. Cost of Coke, Sprite, Dr. Pepper, Diet Coke, and Mellow Yellow is 55 cents. Please enter N, D, Q, or B to input a nickel, dime, quarter, or 1 dollar bill. \n"

  instructionMessage: .asciz "Enter money nickel (N), dime (D), quarter (Q), and one dollar bill (B).\n"

  invalidInputMessage: .asciz "You have entered an invalid value. \n"

  selectionMessage: .asciz "Make selection: (C) Coke, (S) Sprite, (P) Dr. Pepper, (D) Diet Coke, or (M) Mellow Yellow (X) to cancel and return all money. \n"


@Stored Values
  .balign 4
  coinInputPattern:.asciz "%s" @ string format for read- works with character too

  .balign 4
  coinInput: .word 0 @ Location used to store the user input.

  .balign 4
  printTestCharacter: .asciz "You read in: %c \n"

  .balign 4
  inputTotal: .asciz "%d\n"

  .balign 4
  inputTotalDisplay: .asciz "Total is %d cents\n"
