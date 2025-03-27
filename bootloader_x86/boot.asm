bits 16
mov ax, 0x7C0   ;This will load the data segment in to the register
mov ds, ax
mov ax, 0x7E0  ;Basically this is for the segment register -- and it starts from after first 512 bytes
mov ss, ax
mov sp, 0x2000  ;as we want our stack to be of 8kb size

call clearscreen

push 0x0000
call movecursor
add sp, 2

push msg
call print
add sp, 2

cli
hlt


clearscreen:
  push bp
  mov bp, sp
  pusha 

  mov ah, 0x07 ;tells the BIOS to scroll the window
  mov al, 0x00 ;this is used to clear the window
  mov bh, 0x07 ;white on black
  mov cx, 0x00 ;specifies the top left as (0,0)
  mov dh, 0x18 ;24 rows of characters
  mov dl, 0x4f ;79 col of characters 
  int 0x10
  
  popa 
  mov sp,bp
  pop bp
  ret

movecursor:
  push bp
  mov bp, sp
  pusha

  mov dx, [bp+4] ;take the parameter 
  mov ah, 0x02 ;set the cursor position 
  mov bh, 0x00 ;to select the page number   
  int 0x10

  popa
  mov sp, bp
  pop bp
  ret
print:
    push bp
    mov bp, sp
    pusha
    mov si, [bp+4]      ; grab the pointer to the data
    mov bh, 0x00        ; page number, 0 again
    mov bl, 0x00        ; foreground color, irrelevant - in text mode
    mov ah, 0x0E        ; print character to TTY
.char:
    mov al, [si]        ; get the current char from our pointer position
    add si, 1       ; keep incrementing si until we see a null char
    or al, 0
    je .return          ; end if the string is done
    int 0x10            ; print the character if we're not done
    jmp .char       ; keep looping
.return:
     popa
     mov sp, bp
     pop bp
     ret






msg:    db "Booting the operating system, Please wait.........", 0 

times 510-($-$$) db 0
dw 0xAA55
