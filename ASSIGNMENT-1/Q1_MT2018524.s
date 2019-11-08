;ARM__Assignment-1
;SRAVANTI NOMULA : MT2018524
;FIBONACCI SERIES

	    
	 ;output:R2
	 ;fib(0) to fib(N) of fibonacci series
	 THUMB
	 AREA     first, CODE, READONLY
    	 EXPORT __main
     	 ENTRY 
__main  FUNCTION		 		
		MOV  r0, #7 ;input r0 = N
		MOV  r1, #0 ;fib(0)
		MOV  r2, #1 ;fib(1)
		SUB  r0, #1	;r0--	
		
loop	CMP r0, #0	;r0 == 0? to stop the iterations
		BLE stop	;YES stop branch only when comparision result
		
		ADD r1, r2	;r1 = r2+r1
		EOR r1, r2	;swap r1 and r2
		EOR r2, r1
		EOR r1, r2
		SUB r0, #1	;r0--
		B loop		;goto LOOP

	   
stop    B stop ; stop program
     ENDFUNC
     END 
