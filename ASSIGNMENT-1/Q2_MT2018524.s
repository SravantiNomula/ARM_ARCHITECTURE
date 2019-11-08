
;ARM__Assignment-1
;SRAVANTI NOMULA : MT2018524
;largest number of 3  numbers

    
 ;output:R1 finally reflected here
 	 THUMB
	 AREA     first, CODE, READONLY
     	 EXPORT __main
     	 ENTRY 
__main  FUNCTION		 		
		MOV  r1, #5 
		MOV  r2, #4 
		MOV  r3, #8 
		
		
		CMP r1, r2	
		BGE hey	
		MOV r1,r2
hey		CMP r1,r3
		BGE stop
		MOV r1,r3
		
	   ;LDR r2,=0x20000040
	   ;LDRB r0,[r2],#0x5
	   ;LSL r1,r0,#1
	   ;LSL r2,r2,#1
	   
stop    B stop ; stop program
     ENDFUNC
     END 
