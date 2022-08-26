org 100h 

    cmp number,1        ; 1 is not a prime number
    je  exit 
     
    cmp number,2        ; 2 is prime number
    je  prime
    
    mov cl,number
    sub cl,2            ; substract 2 because we will not divide number by 1 and itself
    
    mov bl,2            ; we will divide number with bl, start 2 
    


control:
   mov al,number
   mov ah,0
   
   div bl               ; al= ax/bl , ah= remainder
   
  
   cmp ah,0
   je  exit
     
   add bl,1
     
   loop control
 
prime: 
  
   mov ax,0   
   mov isPrime,1
   mov al,isPrime       ; we can control al for number is prime or not, 1 means prime
   
   ret
   
exit: 
    
   mov ax,0
   mov al,isPrime       ; we can control al for number is prime or not, 0 means not prime   
           
ret

    number  Db 127

    isPrime Db 0


