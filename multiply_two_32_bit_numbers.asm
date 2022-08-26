org 100h

call store
call multiply 
call print 

ret
  
store proc
                    
mov si,2000h        

mov [si],3344h      ;1st number low 4 bits    
mov [si+2],1122h    ;1st number high 4 bits  
 
mov [si+4],7788h    ;2nd number low 4 bits   
mov [si+6],5566h    ;2nd number high 4 bits  
          
ret    
store endp



multiply proc

mov si,2000h
mov ax, [si]
mul word ptr [si+4]       ;1st number low x 2nd number low
mov [si+8], ax
mov cx, dx
mov ax, [si+2]
mul word ptr [si+4]       ;1st number high x 2nd number low
add cx, ax
mov bx, dx
jnc move
add bx,0001h
 
move: mov ax,[si]
mul word ptr [si+6]       ;1st number low x 2nd number high
add cx, ax
mov [si+10], cx
mov cx,dx
jnc move2
add bx, 0001h 

move2: mov ax,[si+2]
mul word ptr [si+6]       ;1st number high x 2nd number high
add cx, ax
jnc move3
add dx, 0001h

move3: add cx, bx
mov [si+12], cx
jnc move4
add dx, 0001h

move4: mov [si+14], dx


ret
multiply endp 


print proc
          
mov si,200Fh               ;we're starting from 100Fh because we want to print high bits first
mov cx,8
std                        ;set d flag (when program did lodsb instruction, si will decrease)
mov ah,0Eh  

GO:
lodsb                      ;program will load data into al from ds:si (si will decrease)
push ax

highNum:
shr al,4                   ;shift right 4 bits (leaving alone left nibble)

cmp al,9
jg ifNumLetter

add al,48                  ;in ascii code 48 equals 0 in decimal,49=1,50=2 ...

int 10h

lowNum:
pop ax

and al,00001111b           ;and al,5    (leaving alone right nibble)  
cmp al,9
jg ifNumLetter2

add al,48

int 10h  
jmp exit

ifNumLetter:

add al,55                  ;in ascii code 65 equals A, if numbers are A,B,C,D,E,F (hexadecimal) we will add 55 
int 10h

jmp lowNum

ifNumLetter2:

add al,55
int 10h

exit:
loop GO
          
ret    
print endp
