org 100h

#start=Emulation Kit.exe#

call game

ret

key db ?
key1 db ?
key2 db ?
key3 db ?
key4 db ?
key5 db ? 
msgLock1 db 'Lock1 is open'
msgLock2 db 'Lock2 is open'
msgLock3 db 'Lock3 is open'
msgLock4 db 'Lock4 is open'
msgLock5 db 'Lock5 is open   and I am out' ; there are 3 spaces between 'open' and 'and' beacuse of to look good in ascii lcd display
msgSorry db 'Locks are not open' 
msgClear db ' '
msgTryAgain db 'Trying again'
     
NUMBERS	DB 00111111b,00000110b,01011011b,01001111b,01100110b,01101101b,01111101b,00000111b,01111111b,01101111b ; seven segment numbers


 Game proc
     
 mov cx,20
 mov si,1           ; we use si and bx to show the number of tries  
 push si
 mov bx,0
 push bx
   
 Start:     
   
   push cx
   
   PrintTry:
   call Try
   
   RandomGenerator:
  
   mov ah, 00h      ; interrupts to get system time        
   int 1Ah          ; cx:dx now hold number of clock ticks since midnight      

   mov  ax, dx
   xor  dx, dx
   mov  cx, 10       
   div  cx          ; here dx contains the remainder of the division - from 0 to 9
                    ; my random number = dl now
                    
   push dx          
   add  dl, '0'     ; to ascii from '0' to '9'
   mov ah, 2h       ; call interrupt to display a value in DL
   int 21h          ; this instruction is to control what the random number is    
   
   openLock:
   
   pop dx 
     
   push dx          ; this is for key = ***
   and dl,5        
   mov key,dl 
   pop dx
   
   mov ax,0         ; here is key1 = *** 
   mov al,key
   mul dl
   add al,5
   mov bl,5
   div bl
   mov key1,ah
   
   cmp key1,0
   jne exit 
    
   lea bx,msgLock1                           
   mov cx, 13
   call Print
   
   mov al,key
   or al,dl         ; here key2 = ***
   mov key2,al
   
   cmp key2,0
   je exit
   
   lea bx,msgLock2
   mov cx, 13      
   call Print 
    
    mov al,key      ; here key3 = ***
    add al,dl
    sar al,2
    mov key3,al
    
    cmp key3,0
    je  exit
    
    lea bx,msgLock3
    mov cx, 13
    call Print
     
    mov al,key      ; here key4 = ***
    xor al,dl
    mov key4,al
    
    cmp key4,0
    je  exit 
     
    lea bx,msgLock4
    mov cx, 13
    call Print
    
    mov al,key      ; here key5 = ***
    mul dl
    mov key5,al
    
    cmp key5,0
    jne exit
     
    lea bx,msgLock5
    mov cx, 28
    call Print 
    
    pop cx          ; here we clear stack for return adress 
       
    jmp theEnd
    
    
 exit:
       
 pop cx    
 
 cmp cx,1  
 jle exit2:         ; to print "Trying Again" message if the trial fails
 
 push cx   
 lea bx,msgTryAgain
 mov cx,12
 call Print 
 pop cx
 
 exit2:  
 loop start 
   
 didntOpen:
 
 lea bx,msgSorry 
 mov cx, 18
 call Print    
 
 theEnd:
  
 pop bx              ; we clear stack for return adress
 pop si   

 ret
 
 Game endp   
 
  
 
 Print proc
    
    push dx         ; for remember dx value 
    push cx         ; we need msg's cx for Printing
    
  	mov dx, 2040h	   
	mov cx, 28      ; Clear's cx is 28 beause our longest message (key 5) have 28 character
	                ; if we want to start again the program, it will clear last message too
	                
    Clear:          ; to prevent overlapping texts
       
	mov al,msgClear
	out dx,al
	inc dx

	loop Clear
	 
    pop cx          ; here we get the msg's cx from stack
     
  	mov dx, 2040h	
	mov si, 0
	

    Printing:

	mov al, [bx+si]
	out dx,al
	inc si
	inc dx

	loop Printing 
	
	pop dx          ; to get back the old value of dx
	
  ret
  
  Print endp  	 
	
Try proc
    pop di          ; first one for return adress
    pop cx          ; we push cx after bx & si (in the line 38) it means cx is in the stack too 
                    ; so to get correct value of bx & si we should pop the cx here
    pop bx
    pop si
    
    mov dx, 2030h	
	
	mov al,NUMBERS[bx]
	out dx,al

	mov dx, 2031h	
	
	mov al,NUMBERS[si]
	out dx,al
    
    inc si
    cmp si,9
    jle  last
    
    mov si,0
    inc bx
    
    
    last:
    push si
    push bx
    push cx
    push di         ; for return adress
ret
        
Try endp  


   
