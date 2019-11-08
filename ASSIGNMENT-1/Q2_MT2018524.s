
;ARM__Assignment-1
;SRAVANTI NOMULA : MT2018524
;largest number of 3  numbers

    
 ;output:R1 finally reflected here
 	 THUMB
	 AREA     first, CODE, READONLY
     	 EXPORT __main
     	 ENTRY 
__main  FUNCTION
		;Loading the 3 numbers
		MOV  r1, #5 
		MOV  r2, #4 
		MOV  r3, #8 
		
		;comparing the 1st 2 numbers
		CMP r1, r2	
		BGE hey		;if r1>r2 or r1=r2 branch to hey  
		MOV r1,r2	; if r1 was < r2 then copy r2 into r1 as r1 is supposed to have largest number finally
		
hey		CMP r1,r3	; if r1>r3 or r1=r3  then stop
		BGE stop
		MOV r1,r3
		
	   
stop    B stop ; stop program
     ENDFUNC
     END 
