;ARM ARCHITECTURE--Assignment-1 
; Sravanti Nomula-MT2018524
;GCD
     AREA     first, CODE, READONLY
     EXPORT __main
	 ENTRY 
__main  FUNCTION		 		
		MOV  r0, #60	;input A
		MOV  r1, #40 	;input B
		
loop	CMP r0, r1		; r0 == r1?
		BEQ stop		; YES stop
		
		CMP r0, r1		; r0 > r1
		ITE GT			
		SUBGT r0, r1	; YES r0 -= r1
		SUBLE r1, r0	; NO r1 -= r0
		
		B loop
		
stop B stop 			; stop program
     ENDFUNC
     END
		
