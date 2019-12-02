;Hyperbola on VGA Question
;parametric equation: x=c1+a*sec(theta)  and y=c2+b*tan(theta)  for horizontal hyperbola
;a=5 is in s29 
;b=3 is in s25
;centre of hyperbola is (c1,c2) i.e (s27,s26)
;MT2018524
;SRAVANTI NOMULA
;sec(theta) in s18 tan(theta) in s19 	
      THUMB
      AREA     first, CODE, READONLY
      IMPORT printMsg1
      IMPORT printMsg2
      EXPORT __main
      ENTRY 
__main  FUNCTION	
 
;_________________________________________________________________________
;Degree to radian conversion
      
       VLDR.F32 s31, =10    ;The angle by which in each iteration theta increases
       VLDR.F32 s30, =180	;Final theta   
       VLDR.F32 s21, =-180	;Initial theta
    
loop1  BL sectan			; Jump to sectan 
       VADD.F32 s21,s21,s31
		
       VLDR.F32 s29, =5 	; a of the hyperbola
	   VLDR.F32 s25, =3 	; b of the hyperbola


       VMUL.F32 s28,s29,s18  ;x=a * sectheta
       VMUL.F32 s29,s25,s19	 ;y = b * tantheta
	   
	   VLDR.F32 s17, =1
;_________________________________________________________________________
;changing the origin from (0,0) to (239,319) for VGA

       VLDR.F32 s27, =239	;c1 i.e x-coordinate of centre
       VLDR.F32 s26, =319	;c2 i.e y-coordinate of centre
;__________________________________________________________________________       
;Generalized hyperbola 
;parametric equation : x= c1+a*sectheta;y=c2+b*tantheta  

      VADD.F32 s28,s28,s27	 ;x=c1+a*sectheta
      VADD.F32 s29,s29,s26	 ;y=c2+b*tantheta
     
;______________________________________________________________________________
;Printing the x and y coordinate values


		  
	  VCVT.U32.F32 s28,s28
      VMOV.F32 R0,S28
	  BL printMsg1			;Printing the x coordinate	
	 
	  VCVT.U32.F32 s29,s29
      VMOV.F32 R0,S29
	  BL printMsg2 			;printing the y coordinate
    
     
       VCMP.F32 s21,s30  
	   vmrs APSR_nzcv,FPSCR
	   BLE loop1


;______________________________________________________________________________

sectan
	;Storing angle in radians
	  ;storing pi value
       VLDR.F32 s22, =3.14159
       VLDR.F32 s23, =180
       VDIV.F32 s24,s22,s23;  (pi/180)
       VMUL.F32 s0,s24,s21	
	
      MOV R0,#0x00000020  ;Store no of iterations
	 
;iterations	count i
      VLDR.F32 s2, =1
	  MOV R5,#0x00000001
;increment i	  
	  VLDR.F32 s3, =1
	  MOV R2,#0x00000001


;Product	 
	  VMOV.F32 s4, s0

;result intermediate	 
	  VMOV.F32 s5, s0
	  
;Product 
	  VLDR.F32 s6, =1

;result intermediate 
	  VLDR.F32 s7, =1	  

;x * x is calculated
   VMUL.F32 s8,s0,s0

;to calculate 2 * i 
	  VLDR.F32 s9, =2

Loop  

;iterate product stored in s13 

      VMUL.F32 s10,s2,s9
      VADD.F32 s11,s10,s3
      VMUL.F32 s12,s10,s11
      VDIV.F32 s13,s8,s12
      
      VSUB.F32 s14,s10,s3
      VMUL.F32 s15,s10,s14 ; 2i * 2i-1
      ;iterate product   stored in s13 
      VDIV.F32 s16,s8,s15
      
      ;Product	
      VNMUL.F32 s4,s4,s13 
      
      ;Product
      VNMUL.F32 s6,s6,s16 
      
      VADD.F32 s5,s5,s4
      	      
      VADD.F32 s7,s7,s6

;sec result_______________stored finally in s18
		VDIV.F32 s18,s17,s7
		
;tan result________________stored finally in s19
		VDIV.F32 s19,s5,s7

      VADD.F32 s2,s2,s3
	  ADD R5,R5,R2
	  CMP R5,R0	
	  BLT Loop
      BX lr

	
stop    B stop ; stop program
      ENDFUNC
      END 
