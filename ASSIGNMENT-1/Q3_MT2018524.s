AREA     first, CODE, READONLY
     export __main	 
	 ENTRY 
__main function
		  MOV R0,#0x53	; 
		  AND R1,R0,#0x01 ; To have only the 1st bit from lsb side of the required number  
		  CMP R1,#0x0 	; checking if this is 0 or 1(1=odd; 0=even)
		  ITE EQ 					
		  MOVEQ R2,#0x0	; if R1 = 0, move 0 to R2 which shows that the number is EVEN
		  MOVNE R2,#0x1	; if R1 = 1, move 1 to R2 which shows that the number is ODD
STOP		      B STOP       ; stop program 
        endfunc
end 
