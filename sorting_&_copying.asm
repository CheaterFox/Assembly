
org 100h
 
call Sort         

call Copy

call Print

ret

length dw 15        ;this is our array's length

arr db 'L','E','A','R','N','I','N','G','E','M','U','8','0','8','6'   

Swap proc           ;this procedure being called by Sort procedure

mov dx,0
mov dl,arr[bx]
xchg dl,arr[bx+1]
mov arr[bx],dl

ret
Swap endp

Sort proc

mov cx,length
mov ax,0

first:

    push cx 
    
    mov cx,length
    dec cx
    sub cx,ax      
    cmp cx,0         ; we wrote this control because, when we substract cx,ax sometimes cx being equal 0 
    je  exit:        ; when cx was 0 at the beginning, loop decrement cx to -1 and loop cycling infinitely
    mov bx,0
    
        second:
        
            mov dx,0
            mov dl,arr[bx]
            
            cmp dl,arr[bx+1]
            jle exit2
            
            call swap
            
            exit2:
        
            inc bx
            
        loop second  
        
    exit:  
    
    pop cx  
    inc ax 
    
loop first   
   
ret
Sort endp   

Copy proc

mov di,2000h
lea si,arr
mov cx,length
rep
movsb

ret
Copy endp


Print proc

lea si,arr
mov cx,length
mov ah,0Eh  

printing:
lodsb
int 10h
loop printing

ret
Print endp