.386
;??????? ????? ??? ? ??????
RomSize    EQU   4096
ACPPort1=00h
ACPPort4=05h
ACPPort2=01h
ACPPort5=06h
ACPPort3=02h
ACPPort6=07h
ACPStart=07h
RdyPort=03h
KeyPort=04h
OutPort=00h
OutPort1=01h
OutPort2=02h
SvPort1=03h
SvPort2=04h
SvPort3=05h
SvPort4=06h

Nmax=50
Data       SEGMENT use16 AT 0 
;????? ??????????? ???????? ??????????
KeyImage	db ?
SetTemp 	db ?
setTempKey1 	db ?
setTempKey2 	db ?
setTempKey3 	db ?
KeyImageOld     db ?
SelectZ 	db ?
Uvelich		db ?
Umensh		db ?
RedactZ1          db ?
RedactZ2          db ?
RedactZ3          db ?
fredz1          db ?
fredz2        db ?
fredz3         db ?
bc              db ?
setind          db ?
temp            db ?
BCDTemper dw 3 dup (?)
ControlPortImage db ?
DispForm db 9 dup (?)
InTemper dw 3 dup (?)
Zone db ?
DispTemper db 9 dup(?)
ArrModeTemper db 9 dup (?)
coolMove1 db ?
coolMove2 db ?
coolMove3 db ?
Time1 dd ?
EndTimeFlag1 db ?
Time2 dd ?
EndTimeFlag2 db ?
Time3 dd ?
EndTimeFlag3 db ?
Data       ENDS
Stk        SEGMENT use16 AT 600h
           dw    30 dup (?)
StkTop     Label Word
Stk        ENDS

Code       SEGMENT use16
;????? ??????????? ???????? ????????
           ASSUME cs:Code,ds:Data,es:Data
ConvTabl db 3Fh, 0Ch, 76h, 5Eh, 4Dh, 05Bh, 7Bh, 0EH, 7Fh, 5Fh
KeyInput proc
		in al,KeyPort
		and al,0fh
		call VibrDelete
		mov KeyImage,al
		ret
KeyInput endp

VibrDelete proc
VD1: 	     mov ah,al
	     mov bh,0
VD2:	     in al,KeyPort
	     cmp ah,al
             jne VD1 
	     inc bh
	     cmp bh,NMax
		jne VD2
		ret
VibrDelete endp

CommForm proc
		mov SetTemp,0
		mov SelectZ,0
		mov Uvelich,0
		mov Umensh,0
                mov RedactZ1,0
                mov RedactZ2,0
                mov RedactZ3,0
                
                cmp KeyImage,0FFh
                jnz BN0 
                mov KeyImageOld,0
                
                
BN0:		test KeyImage,1h ;≥ö≥-≥-≥ø≥≥≥- ≥£TÅTÇ≥-≥-≥-≥-≥≥≥ø TÇ≥≥≥-≥ø≥≥TÄ≥-TÇTÉTÄTã ≥-≥≥TÇ≥ø≥-≥-≥-
		jnz BN1
                mov al,KeyImage
                mov bl,KeyImage
                xor al,KeyImageOld
                and al,bl
                mov KeyImageOld,bl
                jz BN1
                
                
                
		mov SetTemp, 0FFh
                

                cmp bc,1h
                jnz BT3
                mov coolMove1,2h
                mov setTempKey1, 0FFh
        
BT3:            cmp bc,2h
                jnz BT4
                mov coolMove2,2h
                mov setTempKey2, 0FFh
     
BT4:            cmp bc,4h
                jnz BN1     
                mov coolMove3, 2h
                mov setTempKey3, 0FFh

BN1:	        test KeyImage,2h ;¢Î§•´•≠®• ‰‡Æ≠‚†
		jnz BN2
                mov al,KeyImage
                mov bl,KeyImage
                xor al,KeyImageOld
                and al,bl
                mov KeyImageOld,bl
                jz BN2
		mov SelectZ,0FFh
		mov al,byte ptr[Zone]
		add al, 3h
                mov ah,al
                mov al,bc
                out SvPort4,al
                shl bc,1h
                mov al,ah
		mov byte ptr[Zone],al
		cmp al,09h
		jne BN2
                 mov bc,1h
		mov byte ptr[Zone],0




BN2:	        cmp KeyImage,0efh  
                 jnz BN5
                   mov al,KeyImage
                mov bl,KeyImage
                xor al,KeyImageOld
                and al,bl
                mov KeyImageOld,bl
                jz BN5
                 cmp bc,1h
                 jnz BN3
                 mov RedactZ1,0FFh
                 mov fredz1,0FFh
                 mov setTempKey1, 0h
        
BN3:             cmp bc,2h
                 jnz BN4
                 mov RedactZ2,0FFh 
                 mov fredz2,0FFh
                 mov setTempKey2, 0h
     
BN4:             cmp bc,4h
                 jnz BN5    
                 mov RedactZ3,0FFh
                 mov fredz3,0FFh
                 mov setTempKey3, 0h         
BN5:              mov al,bc
                 out SvPort4,al
                 
                 
BN6:	        cmp fredz1,0ffh
                jz ZR1
                cmp fredz2,0ffh
                jz ZR1
                cmp fredz3,0ffh
                jz ZR1
                jmp exit
                
ZR1:            test KeyImage,4h 
		jnz BN7
                mov al,KeyImage
                mov bl,KeyImage
                xor al,KeyImageOld
                and al,bl
                mov KeyImageOld,bl
                jz exit
		mov Uvelich,0FFh
BN7:	        test KeyImage,8h
		jnz exit
                mov al,KeyImage
                mov bl,KeyImage
                xor al,KeyImageOld
                and al,bl
                mov KeyImageOld,bl
                jz exit
		mov Umensh,0FFh                 
exit:           ret	
CommForm endp

ACPInput	proc
                mov al,0
		out ACPStart,al
		mov al,1h 
		out ACPStart,al
WaitRdy1:       in al,RdyPort
		test al,1
		je WaitRdy1
		in al,ACPPort4
                mov ah,al
                in al,ACPPort1
                mov dx,0
                mov si,128
                div si        
		mov InTemper,ax	

                mov al,0
		out ACPStart,al
		mov al,2h 
		out ACPStart,al
WaitRdy2:       in al,RdyPort
		test al,2
		je WaitRdy2
		in al,ACPPort5
                mov ah,al
                in al,ACPPort2
                mov dx,0
                mov si,128
                div si        
		mov InTemper+2,ax	

                mov al,0
		out ACPStart,al
		mov al,4h 
		out ACPStart,al
WaitRdy3:       in al,RdyPort
		test al,4
		je WaitRdy3
		in al,ACPPort6
                mov ah,al
                in al,ACPPort3
                mov dx,0
                mov si,128
                div si        
		mov InTemper+4,ax	
		ret
ACPInput endp

BCDCodeConv proc
                xor cx,cx
		mov dx,0
		mov cx,[si]
		and cx,3FFh
BCD2:	        jcxz BCD1
		mov al,dl
		add al,1
		daa
		mov dl,al
		mov al,dh
		adc al,0
		daa
		mov dh,al
		dec cx
		jmp BCD2
BCD1:	        mov [di],dx
		ret
BCDCodeConv endp	

DispFor proc
           lea bx,DispTemper
           mov cx,3
           mov ax,BCDTemper
           mov di,ax
DF1:       mov dx,ax
           and al,0Fh
           mov [bx],al
           mov ax,dx
           shr ax,4
           inc bx
           loop DF1
           
           mov cx,3
           mov ax,BCDTemper+2
           mov di,ax
DF2:       mov dx,ax
           and al,0Fh
           mov [bx+3],al
           mov ax,dx
           shr ax,4
           inc bx
           loop DF2
           
           mov cx,3
           mov ax,BCDTemper+4
           mov di,ax
DF3:       mov dx,ax
           and al,0Fh
           mov [bx+6],al
           mov ax,dx
           shr ax,4
           inc bx
           loop DF3
           
           ret
DispFor endp


TemperOut proc  
           xor dx,dx               
           mov dl, 0fbh
           xor bx,bx  
           xor ax,ax
           
TO1:      mov bl, [si]
           mov al,ConvTabl[bx]
           cmp dl,0fdh
           jnz tod1
           or al,80h
tod1:      out OutPort, al
           mov al,dl 
           out OutPort1, al
           mov al, 0ffh
           out OutPort1, al
           inc si
           ror dl,1
           jc TO1
           
           
           
           mov dl, 0dfh
           xor bx,bx
           xor ax,ax  
           mov cl,3
TO2:      mov bl, [si+3]
           mov al,ConvTabl[bx]
           cmp dl,0efh
           jnz tod2
           or al,80h
tod2:      out OutPort, al
           mov al,dl 
           out OutPort1, al
           mov al, 0ffh
           out OutPort1, al
           inc si
           ror dl,1
           loop TO2
           
           mov dl, 0feh
           xor bx,bx
           xor ax,ax  
           mov bl, [si+6]
           mov al,ConvTabl[bx]
           out OutPort, al
           mov al,dl 
           out OutPort2, al
           mov al, 0ffh
           out OutPort2, al
           
           mov dl, 7fh
           xor bx,bx
           xor ax,ax  
           mov cl,2
TO3:       mov bl, [si+7]
           mov al,ConvTabl[bx]
           cmp cl,2
           jnz tod3
           or al,80h
tod3:      out OutPort, al
           mov al,dl 
           out OutPort1, al
           mov al, 0ffh
           out OutPort1, al
           inc si
           ror dl,1
           loop TO3
           ret
TemperOut endp		


ConTemer proc
           lea   bx,DispTemper
           cmp bc,1
           jnz CT1
           cmp fredz1,0FFh
           jnz RZ1
           lea   bx,ArrModeTemper
RZ1:           xor si,si
           jmp exit
           
CT1:       cmp bc,2
           jnz CT2
           cmp fredz2,0FFh
           jnz RZ2
           lea   bx,ArrModeTemper
RZ2:           mov si,6
           jmp exit
CT2:       cmp fredz3,0FFh
           jnz RZ3
           lea   bx,ArrModeTemper
RZ3:       mov si,0ch 
           jmp exit        
exit:      

            mov dl, 0f7h
           xor ax,ax  
           mov cl,3
CT3:       mov al,byte ptr [bx+si]
           mov di,ax
           xor ax,ax 
           mov al,ConvTabl[di]
           cmp dl,0fbh
           jnz tod
           or al,80h
tod:      out OutPort, al
           mov al,dl 
           out OutPort2, al
           mov al, 0ffh
           out OutPort2, al
           inc bx
           ror dl,1
           loop CT3      
ret
ConTemer endp

ModeTemper proc
    lea si,DispTemper
    lea di,ArrModeTemper
    xor ax,ax
    xor cx,cx    

    cmp RedactZ1,0FFh
    jnz MT1
    mov cl,3
    ;mov dl,0f7h
    RZ1: mov al,[si]
    mov [di],al
           ;mov bl,[di]
           ;mov al,ConvTabl[bx]
           ;cmp dl,0fbh
           ;jnz tochka
           ;or al,80h
;tochka:      out OutPort, al
          ; mov al,dl 
          ; out OutPort2, al
          ; mov al, 0ffh
           ;out OutPort2, al
          ; ror dl,1   
    inc si
    inc di
       
    loop RZ1    
    

MT1:    cmp RedactZ2,0FFh
jnz MT2
    mov cl,3
RZ2:    mov al,[si+6h]
    mov [di+6],al
    inc si
    inc di
    loop RZ2  
    
MT2:   cmp RedactZ3,0FFh
    jnz MT3
    mov cl,3
RZ3:    mov al,[si+0ch]
    mov [di+0ch],al
    inc si
    inc di
    loop RZ3  
        
MT3:
ret
ModeTemper endp


TemperRedact proc
           lea si,ArrModeTemper
           cmp bc,1
           jnz CT1
           cmp Uvelich,0ffh
           jnz U1
           mov al,byte ptr[si]
           adc al,2h
           aaa
           mov byte ptr[si],al
           mov al,byte ptr[si+1]
           adc al,0
           aaa
           mov byte ptr[si+1],al
           mov al,byte ptr[si+2]
           adc al,0
           aaa
           mov byte ptr[si+2],al     
          
U1:       cmp Umensh,0ffh
           jnz CT1
           mov al,byte ptr[si]
           sbb al,2h
           aas
           mov byte ptr[si],al
           mov al,byte ptr[si+1]
           sbb al,0
           aas
           mov byte ptr[si+1],al
           mov al,byte ptr[si+2]
           sbb al,0
           aas
           mov byte ptr[si+2],al   
          
CT1:       cmp bc,2
           jnz CT2
           cmp Uvelich,0ffh
           jnz U2
           mov al,byte ptr[si+6]
           adc al,2h
           aaa
           mov byte ptr[si+6],al
           mov al,byte ptr[si+7]
           adc al,0
           aaa
           mov byte ptr[si+7],al
           mov al,byte ptr[si+8]
           adc al,0
           aaa
           mov byte ptr[si+8],al     
          
U2:       cmp Umensh,0ffh
           jnz CT2
           mov al,byte ptr[si+6]
           sbb al,2h
           aas
           mov byte ptr[si+6],al
           mov al,byte ptr[si+7]
           sbb al,0
           aas
           mov byte ptr[si+7],al
           mov al,byte ptr[si+8]
           sbb al,0
           aas
           mov byte ptr[si+8],al   
CT2:       cmp bc,4  
           jnz exit           
          cmp Uvelich,0ffh
           jnz met
           mov al,byte ptr[si+0ch]
           adc al,2h
           aaa
           mov byte ptr[si+0ch],al
           mov al,byte ptr[si+0dh]
           adc al,0
           aaa
           mov byte ptr[si+0dh],al
           mov al,byte ptr[si+0eh]
           adc al,0
           aaa
           mov byte ptr[si+0eh],al     
          
met:       cmp Umensh,0ffh
           jnz exit
           mov al,byte ptr[si+0ch]
           sbb al,2h
           aas
           mov byte ptr[si+0ch],al
           mov al,byte ptr[si+0dh]
           sbb al,0
           aas
           mov byte ptr[si+0dh],al
           mov al,byte ptr[si+0eh]
           sbb al,0
           aas
           mov byte ptr[si+0eh],al                   
exit:      ret
TemperRedact endp
 
setTemper proc
           lea si,DispTemper
           lea di,ArrModeTemper 
           cmp setTempKey1,0ffh
           mov ax,0FFBh
           ;mov word ptr Time1,ax
           ;mov word ptr Time1+2,0h
           ;mov word ptr Time2,ax
           ;mov word ptr Time2+2,0h
           ;mov word ptr Time3,ax
           ;mov word ptr Time3+2,0h
           mov bx,ax
           mov dx,0h
           jnz ST1
           mov al,[si+2]
           cmp al,[di+2]
           ja coolZ1
           jnae lampZ1
           mov al,[si+1]
           cmp al,[di+1]
           ja coolZ1
           jnae lampZ1
           mov al,[si]
           cmp al,[di] 
           ja coolZ1
           jnae lampZ1
           xor ax,ax
           out SvPort2, al
           jmp ST1
coolZ1:   mov al,coolMove1
           out SvPort2, al
           push ax
n1:        ;sub word ptr Time1,1
           ;sbb word ptr Time1+2,0
           ;mov ax,word ptr Time1
           ;or ax,word ptr Time1+2
           sub bx,1
           sbb dx,0
           mov ax,bx
           or ax,dx
           mov EndTimeFlag1,0
           jnz m1
           mov EndTimeFlag1,0FFh
m1:           mov al,0ffh
           cmp EndTimeFlag1,al
           jne n1
       xor ax,ax
           pop ax
           shl al,1
           mov coolMove1,al
           cmp al,80h
           jnz ST1
           mov al,2
           mov coolMove1,al
           jmp ST1
lampZ1:    mov al,1h
           out SvPort2, al       
           
           
           
ST1:       cmp setTempKey2,0ffh
           jnz ST2
           
           
           mov al,[si+8]
           cmp al,[di+8]
           ja coolZ2
           jnae lampZ2
           mov al,[si+7]
           cmp al,[di+7]
           ja coolZ2
           jnae lampZ2
           mov al,[si+6]
           cmp al,[di+6] 
           ja coolZ2
           jnae lampZ2
           xor ax,ax
           out SvPort3, al
           jmp ST2
coolZ2:   mov al,coolMove2
           out SvPort3, al
           push ax
           mov bx,0ffbh
           mov dx,0h
n2:        ;sub word ptr Time2,1
           ;sbb word ptr Time2+2,0
           ;mov ax,word ptr Time2
           ;or ax,word ptr Time2+2
           sub bx,1
           sbb dx,0
           mov ax,bx
           or ax,dx
        
           mov EndTimeFlag2,0
           jnz m2
           mov EndTimeFlag2,0FFh
m2:           mov al,0ffh
           cmp EndTimeFlag2,al
           jne n2
       xor ax,ax
           pop ax
           shl al,1
           mov coolMove2,al
           cmp al,80h
           jnz ST2
           mov al,2
           mov coolMove2,al
           jmp ST2
lampZ2:    mov al,1h
           out SvPort3, al       
           
               
           
           
ST2:        cmp setTempKey3,0ffh
           jnz exit
           
           
           mov al,[si+0eh]
           cmp al,[di+0eh]
           ja coolZ3
           jnae lampZ3
           mov al,[si+0dh]
           cmp al,[di+0dh]
           ja coolZ3
           jnae lampZ3
           mov al,[si+0ch]
           cmp al,[di+0ch] 
           ja coolZ3
           jnae lampZ3
           xor ax,ax
           out SvPort1, al
           jmp exit
coolZ3:   mov al,coolMove3
           out SvPort1, al
           push ax
           mov bx,0ffbh
           mov dx,0h
n3:        ;   sub word ptr Time3,1
          ; sbb word ptr Time3+2,0
           ;mov ax,word ptr Time3
           ;or ax,word ptr Time3+2
           sub bx,1
           sbb dx,0
           mov ax,bx
           or ax,dx
           mov EndTimeFlag3,0
           jnz m3
           mov EndTimeFlag3,0FFh
m3:           mov al,0ffh
           cmp EndTimeFlag3,al
           jne n3
       xor ax,ax
           pop ax
           shl al,1
           mov coolMove3,al
           cmp al,80h
           jnz exit
           mov al,2
           mov coolMove3,al
           jmp exit
lampZ3:    mov al,1h
           out SvPort1, al       
                     
           
           
           
           
exit:       
ret
setTemper endp



      
Start:
           mov   ax,Data
           mov   ds,ax
           mov   es,ax
           mov   ax,Stk
           mov   ss,ax
           lea   sp,StkTop
           mov Zone,0
           mov KeyImageOld,0
           mov bc,1h
           mov fredz1,0h
           mov fredz2,0h
           mov fredz3,0h
         
        
           
BEGIN:     
           
           call KeyInput
           call CommForm
           call ACPInput
           
           lea si,InTemper
           lea di,BCDTemper
           call BCDCodeConv
           lea si,InTemper+2
           lea di,BCDTemper+2
           call BCDCodeConv
           lea si,InTemper+4
           lea di,BCDTemper+4
           call BCDCodeConv
           
           call DispFor
           lea si, DispTemper
           call TemperOut 
           call ModeTemper
           call ConTemer
           call TemperRedact
           call setTemper
          
           ;????? ??????????? ??? ?????????
           jmp BEGIN
;? ????????? ?????? ?????????? ??????? ???????? ????????? ?????
           org   RomSize-16
           ASSUME cs:NOTHING
           jmp   Far Ptr Start
Code       ENDS
END