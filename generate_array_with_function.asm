org 100h

lea si,array        ; we wrote these first 3 code lines to find the length of array
lea bx,forN         ; when the programmer changed the length of array  
sub bx,si           ; program will calculate the length automatically  
mov si,0            ; so programmer doesn't need to change anything in code section

                    ; bx = length of array                 
cmp bx,14
jle error

cmp bx,26
jge error
 
mov array[0],0
mov array[1],1 

mov cx,0
mov cx,bx
sub cx,2            ; we know 2 elements of array so substract 2 

mov bx,0            ; this is for index of element

mov ax,3            ; this is for which element



store:

push ax
mov dl,2

div dl

cmp ah,0
je  even

  
odd:

mov dl,array[bx+1]
sub dl,array[bx]
mov array[bx+2],dl     

inc bx

jmp endf

even:

mov dl,array[bx+1]
add dl,array[bx]
mov array[bx+2],dl
 
inc bx
 
endf:

pop ax

inc ax

loop store:

jmp exit 


error:

LEA SI, MESSAGE
MOV CX, 38
MOV AH, 0Eh
Go: LODSB
INT 10h
LOOP Go



exit:
 
ret 


MESSAGE DB 'Please enter a value between 14 and 26', 0
  
array db 15 dup(?)     ; The length of array is changeable

forN db 0FFh           ; we will use this to calculate the length of array (FFh is a random number)  