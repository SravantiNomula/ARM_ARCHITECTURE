
 ;a1,a2,a3 are the 3 inputs, w1,w2,w3 are the 3 outputs
 ;case select if (0 and) (1 or) (2 not) (3 xor) (4 xnor) (5 nand)  (6 nor)
	;To print the resukts in python code format we use (0 and) (1 or) (2 not)(5 nand)  (6 nor)

	THUMB
	PRESERVE8	
	AREA  first, CODE,READONLY
	EXPORT __main
	IMPORT printMsg
	IMPORT printMsg4p		
	IMPORT printtitle
	IMPORT printwelcome
		ENTRY

__main FUNCTION
	
	 BL printwelcome;
	 
	 ;AND FUNCTION
	 MOV R0,#0;					
	 BL printtitle;	
	 BL __inp_and;
	 
	 ;OR FUNCTION
	 MOV R0,#1;					
	 BL printtitle;
	 BL __inp_or;	
	 
	  ;NOT FUNCTION
	 MOV R0,#2;					
	 BL printtitle;	
	 BL __inp_not;
	 
	 ;NAND FUNCTION
	 MOV R0,#5;					
	 BL printtitle;	
	 BL __inp_nand;
	 
	 
	  ;NOR FUNCTION
	 MOV R0,#6;					 
	 BL printtitle;	
	 BL __inp_nor;
	 
	 B stop;
	 ENDFUNC	
		
;-------------------------------------------------------------------------------------	 
__inputset FUNCTION
	 PUSH {LR};
	 VMOV.F32 S0,R4;			Move A1 to S0 (floating point register)
     VCVT.F32.S32 S0,S0; 		Convert into signed 32bit number
	 VMOV.F32 S1,R5;			Move A2 to S1 (floating point register)
     VCVT.F32.S32 S1,S1; 		Convert into signed 32bit number
	 VMOV.F32 S2,R6;			Move A3 to S2 (floating point register)
     VCVT.F32.S32 S2,S2; 		Convert into signed 32bit number
	 POP {LR};
	 BX lr;
	 ENDFUNC
;_____________________________________________________________________________
;____________EXPONENTIAL IMPLEMENTATION_______________________________________
__exp FUNCTION
	 PUSH {LR};
	 ;Compute e^-x for value in S10 and store in S11	

	 
	 VNEG.F32 S10,S10;			register has -x
	 
	 MOV R11,#100;				100 terms in series
     MOV R12,#1;	    		
	 
     VLDR.F32 S11,=1;			Store value of e^x
     VLDR.F32 S12,=1;			Temporary variable    
	 
L1 
	 CMP R12,R11;					Compare count and no of term
     BLE L2;				If count is < no og terms enter L1
	 POP {LR};	
     BX lr;						else STOP
	 
L2  
	 VMUL.F32 S12,S12,S10; 		Temp_var = temp_var * x
     VMOV.F32 S13,R12;			Move the count in R9 to S13 (floating point register)
     VCVT.F32.S32 S13,S13; 		Convert into signed 32bit number
     VDIV.F32 S12,S12,S13;		Divide temp_var by count (Now the term is finished)
     VADD.F32 S11,S11,S12;		Add temp_var to the sum
     ADD R12,R12,#1;				Increment the count
     B L1;
	 
	ENDFUNC		 

;____________________________________________________________________________
;__________________________SIGMOID IMPLEMENTATION______________________________
__sigmoid FUNCTION
	 ; Sigmoid function
	 PUSH {LR};
	 VLDR.F32 S8,= 1;			
	 VADD.F32 S9,S11,S8;		 (e^-x)+1
	 VDIV.F32 S9,S8,S9;			 1 / (e^-x)+1		-> 	Value of Y - sigmoid function
	 POP {LR};	
	 BX lr;
	ENDFUNC
	
;--------------------------------------------------------------------------------------------------

;		 AND Logic implemenation in a Neuron

__and FUNCTION
	 PUSH {LR};	 
	  VLDR.F32 S4,= -0.1;		W1
	 VLDR.F32 S5,= 0.2;			W2
	 VLDR.F32 S6,= 0.2;			W3
	 VLDR.F32 S7,= -0.2;	  Bias
	 
	 VMUL.F32 S0,S0,S4;			A1*W1
	 VMUL.F32 S1,S1,S5;			A2*W2
	 VMUL.F32 S2,S2,S6;			A3*W3
	 VADD.F32 S3,S0,S1;			A1*W1 + A2*W2 
	 VADD.F32 S3,S3,S2;			A1*W1 + A2*W2 + A3*W3 
	 VADD.F32 S3,S3,S7;			A1*W1 + A2*W2 + A3*W3 + B
	 
	 VMOV.F32 S10,S3;			S10 has the value of x
	 BL __output;
	 
	 POP {LR};	
	 BX lr;
	 ENDFUNC

;----------------------------------------------------------------------------------------
;		 OR Logic implemenation in a Neuron

__or FUNCTION
	 PUSH {LR};	 
	 VLDR.F32 S4,= -0.1;		W1
	 VLDR.F32 S5,= 0.7;			W2
	 VLDR.F32 S6,= 0.7;			W3
	 VLDR.F32 S7,= -0.1;		Bias
	 
	 VMUL.F32 S0,S0,S4;			A1*W1
	 VMUL.F32 S1,S1,S5;			A2*W2
	 VMUL.F32 S2,S2,S6;			A3*W3
	 VADD.F32 S3,S0,S1;			A1*W1 + A2*W2 
	 VADD.F32 S3,S3,S2;			A1*W1 + A2*W2 + A3*W3 
	 VADD.F32 S3,S3,S7;			A1*W1 + A2*W2 + A3*W3 + B
	 
	 VMOV.F32 S10,S3;			S10 has the value of x
	 BL __output;
	 POP {LR};	
	 BX lr;
	 ENDFUNC

;----------------------------------------------------------------------------------------
;		NOT Logic implemenation in a Neuron	

__not FUNCTION
	 PUSH {LR};	 
	
	; As we have only 2 weights for not gate in python program
	
	 VLDR.F32 S4,= 0.5;			
	 VLDR.F32 S5,= 0;		
	 VLDR.F32 S6,=-0.7;			 
	 VLDR.F32 S7,= 0.1;			Bias
	 	 
	 VMUL.F32 S0,S0,S4;			A1*W1
	 VMUL.F32 S1,S1,S5;			A2*W2
	 VMUL.F32 S2,S2,S6;			A3*W3
	 VADD.F32 S3,S0,S1;			A1*W1 + A2*W2 
	 VADD.F32 S3,S3,S2;			A1*W1 + A2*W2 + A3*W3 
	 VADD.F32 S3,S3,S7;			A1*W1 + A2*W2 + A3*W3 + B
	 
	 VMOV.F32 S10,S3;			S10 has the value of x
	 BL __output;
	 POP {LR};	
	 BX lr;
	 ENDFUNC


;----------------------------------------------------------------------------------------
;		XOR Logic implemenation in a Neuron

__xor FUNCTION
	
	PUSH {LR};
	  VLDR.F32 S4,= -5;			W1
	 VLDR.F32 S5,= 20;			W2
	 VLDR.F32 S6,= 10;			W3
	 VLDR.F32 S7,= 1;			Bias
	 
	 VMUL.F32 S0,S0,S4;			A1*W1
	 VMUL.F32 S1,S1,S5;			A2*W2
	 VMUL.F32 S2,S2,S6;			A3*W3
	 VADD.F32 S3,S0,S1;			A1*W1 + A2*W2 
	 VADD.F32 S3,S3,S2;			A1*W1 + A2*W2 + A3*W3 
	 VADD.F32 S3,S3,S7;			A1*W1 + A2*W2 + A3*W3 + B

	 VMOV.F32 S10,S3;			
	 BL __output;
	
	 POP {LR};		
	 BX lr;
	 ENDFUNC

;----------------------------------------------------------------------------------------
;	 XNOR Logic implemenation in a Neuron

__xnor FUNCTION
	 PUSH {LR};		
	 VLDR.F32 S4,= -5;			W1
	 VLDR.F32 S5,= 20;			W2
	 VLDR.F32 S6,= 10;			W3
	 VLDR.F32 S7,= 1;			Bias
	 
	 VMUL.F32 S0,S0,S4;			A1*W1
	 VMUL.F32 S1,S1,S5;			A2*W2
	 VMUL.F32 S2,S2,S6;			A3*W3
	 VADD.F32 S3,S0,S1;			A1*W1 + A2*W2 
	 VADD.F32 S3,S3,S2;			A1*W1 + A2*W2 + A3*W3 
	 VADD.F32 S3,S3,S7;			A1*W1 + A2*W2 + A3*W3 + B

	 VMOV.F32 S10,S3;			
	 BL __output;
	 
	 POP {LR};	
	 BX lr;
	 ENDFUNC

;----------------------------------------------------------------------------------------
;		 NAND Logic implemenation in a Neuron

__nand FUNCTION
	 PUSH {LR};	 
	 VLDR.F32 S4,= 0.6;				W1
	 VLDR.F32 S5,= -0.8;			W2
	 VLDR.F32 S6,= -0.8;			W3
	 VLDR.F32 S7,= 0.3;			Bias
	 
	 
	 VMUL.F32 S0,S0,S4;			A1*W1
	 VMUL.F32 S1,S1,S5;			A2*W2
	 VMUL.F32 S2,S2,S6;			A3*W3
	 VADD.F32 S3,S0,S1;			A1*W1 + A2*W2 
	 VADD.F32 S3,S3,S2;			A1*W1 + A2*W2 + A3*W3 
	 VADD.F32 S3,S3,S7;			A1*W1 + A2*W2 + A3*W3 + B
	 
	 VMOV.F32 S10,S3;			S10 has the value of x
	 BL __output;
	 POP {LR};	
	 BX lr;
	 ENDFUNC

;----------------------------------------------------------------------------------------
;		 NOR Logic implemenation in a Neuron

__nor FUNCTION
	 PUSH {LR};	 
	  VLDR.F32 S4,= 0.5;			W1
	 VLDR.F32 S5,= -0.7;			W2
	 VLDR.F32 S6,= -0.7;			W3
	 VLDR.F32 S7,= 0.1;			Bias
	 
	 VMUL.F32 S0,S0,S4;			A1*W1
	 VMUL.F32 S1,S1,S5;			A2*W2
	 VMUL.F32 S2,S2,S6;			A3*W3
	 VADD.F32 S3,S0,S1;			A1*W1 + A2*W2 
	 VADD.F32 S3,S3,S2;			A1*W1 + A2*W2 + A3*W3 
	 VADD.F32 S3,S3,S7;			A1*W1 + A2*W2 + A3*W3 + B
	 
	 VMOV.F32 S10,S3;			S10 has the value of x
	 BL __output;
	 POP {LR};	
	 BX lr;
	 ENDFUNC
;__________________________________________________________________________________________________
;____________________We call the logic functions by giving the test cases in python code________________
;Test cases:________(1,0,0),(1,0,1),(1,1,0),(1,1,1)______________________________________________
  
__inp_and FUNCTION	
	
	 PUSH {LR}; 
	 	 
	 MOV R4,#1;					
	 MOV R5,#0;					
	 MOV R6,#0;					
	 BL __inputset;
	 BL __and;
	 BL printMsg4p
	 
	 MOV R4,#1;					
	 MOV R5,#0;					
	 MOV R6,#1;					
	 BL __inputset;
	 BL __and;
	 BL printMsg4p
	 
	 MOV R4,#1;					
	 MOV R5,#1;					
	 MOV R6,#0;					
	 BL __inputset;
	 BL __and;
	 BL printMsg4p
	 
	 MOV R4,#1;					
	 MOV R5,#1;					
	 MOV R6,#1;					
	 BL __inputset;
	 BL __and;
	 BL printMsg4p
	 
	 POP {LR};	
     BX lr;						
	 					
	 ENDFUNC 
		 
__inp_or FUNCTION	
	
	 PUSH {LR}; 
	 
	 MOV R4,#1;					
	 MOV R5,#0;					
	 MOV R6,#0;					
	 BL __inputset;
	 BL __or;
	 BL printMsg4p
	 
	 MOV R4,#1;					
	 MOV R5,#0;					
	 MOV R6,#1;					
	 BL __inputset;
	 BL __or;
	 BL printMsg4p
	 
	 MOV R4,#1;					
	 MOV R5,#1;					
	 MOV R6,#0;					
	 BL __inputset;
	 BL __or;
	 BL printMsg4p
	 
	 MOV R4,#1;					
	 MOV R5,#1;					
	 MOV R6,#1;					
	 BL __inputset;
	 BL __or;
	 BL printMsg4p
	 
	 POP {LR};	
     BX lr;						
	 					
	 ENDFUNC 
	 
__inp_not FUNCTION	
	
	 PUSH {LR}; 
	 	 
	 MOV R4,#1;					
	 MOV R5,#0;					
	 MOV R6,#0;					
	 BL __inputset; 
	 BL __not; 
	 BL printMsg4p;
	 
	 MOV R4,#1;					
	 MOV R5,#0;					
	 MOV R6,#1;					
	 BL __inputset; 
	 BL __not; 
	 BL printMsg4p;
	 	 
	 POP {LR};	
     BX lr;				
	 					
	 ENDFUNC  
		 
__inp_nand FUNCTION	
	
	 PUSH {LR}; 
	 	 
	 MOV R4,#1;					
	 MOV R5,#0;					
	 MOV R6,#0;					
	 BL __inputset; 
	 BL __nand; 
	 BL printMsg4p;
	 
	 MOV R4,#1;					
	 MOV R5,#0;					
	 MOV R6,#1;					
	 BL __inputset; 
	 BL __nand; 
	 BL printMsg4p;
	 
	 MOV R4,#1;					
	 MOV R5,#1;					
	 MOV R6,#0;					
	 BL __inputset; 
	 BL __nand; 
	 BL printMsg4p;
	 
	 MOV R4,#1;					
	 MOV R5,#1;					
	 MOV R6,#1;					
	 BL __inputset; 
	 BL __nand; 
	 BL printMsg4p;
	 
	 POP {LR};	
     BX lr;						
	 					
	 ENDFUNC 
	 
__inp_nor FUNCTION	
	
	 PUSH {LR}; 
		 
	 MOV R4,#1;				
	 MOV R5,#0;					
	 MOV R6,#0;					
	 BL __inputset; 
	 BL __nor; 
	 BL printMsg4p;
	 
	 MOV R4,#1;					
	 MOV R5,#0;					
	 MOV R6,#1;					
	 BL __inputset; 
	 BL __nor; 
	 BL printMsg4p;
	 
	 MOV R4,#1;					
	 MOV R5,#1;					
	 MOV R6,#0;					
	 BL __inputset; 
	 BL __nor; 
	 BL printMsg4p;
	 
	 MOV R4,#1;					
	 MOV R5,#1;					
	 MOV R6,#1;					
	 BL __inputset; 
	 BL __nor; 
	 BL printMsg4p;
	 
	 POP {LR};	
     BX lr;						
	 					
	 ENDFUNC 

;______________________________________________________________________________________
;________________________OBTAINING THE OUTPUT________________________________________

__output FUNCTION
	 PUSH {LR};
	 BL __exp;					Compute e^-x
	 BL __sigmoid;				Sigmoid function output in S9
	 
	 VLDR.F32 S14,= 0.5;		Store 0.5 in S14
	 VCMP.F32 S9,S14;			Compare current Y and 0.5		
	 VMRS    APSR_nzcv, FPSCR;	 
	 MOV R0, R4;
	 MOV R1, R5;
	 MOV R2, R6;				Move inputs to R0, R1 and R2 to print
	 MOVGT	R3, #1;				If Y > 0.5, output is 1
	 MOVLT	R3, #0;				If Y < 0.5, output is 0
	 POP {LR};
	 BX lr;
	 ENDFUNC		 
;_____________________________________________________________________ 
stop B stop
    END
