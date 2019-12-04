 ;a1,a2,a3 are the 3 inputs, w1,w2,w3 are the 3 outputs
 ; R0---a1
 ;R1----a2
 ;R2----a3
 ;R7-- case select if (0 and) (1 or) (2 not) (3 xor) (4 xnor) (5 nand)  (6 nor)

    THUMB
	PRESERVE8	
	AREA  first, CODE,READONLY
	EXPORT __main
	IMPORT printMsg4p
	IMPORT printMsginvalid
	
	ENTRY

__main FUNCTION

	 MOV R0,#1;	a1
	 VMOV.F32 S0,R0;			Move A1 tofloating point register
     VCVT.F32.S32 S0,S0; 		      Convert into signed 32bit number

	 MOV R1,#1;	a2	
	 VMOV.F32 S1,R1;			Move A2 to floating point register
     VCVT.F32.S32 S1,S1; 		       Convert into signed 32bit number


	 MOV R2,#1;	a3
	 VMOV.F32 S2,R2;			Move A3 to floating point register
     VCVT.F32.S32 S2,S2; 		       Convert into signed 32bit number


	 MOV R7,#0;	Case selected

	 ; Switch - Case
	 CMP R7,#0;
	 BNE Loop1;   If switch case is 0 do AND operation
	 BL __and;					If case = 0, AND 
	 B Loop8;

Loop1	 CMP R7,#1;
	 BNE Loop2;    If switch case is 1 do OR operation
	 BL __or;					If case = 1, OR 
	 B Loop8;
Loop2	 CMP R7,#2;
	 BNE Loop3;	If switch case is 2 do NOT operation
	 BL __not;					If case = 2, NOT
	 B Loop8;
Loop3	 CMP R7,#3;
	 BNE Loop4;     If switch case is 3 do XOR operation
	 BL __xor;					If case = 3, XOR
	 B Loop8;
Loop4	 CMP R7,#4;
	 BNE Loop5;	 If switch case is 4 do XNOR operation
	 BL __xnor;					If case = 4, XNOR
	 B Loop8;	
Loop5	 CMP R7,#5;	  
	 BNE Loop6;	If switch case is 5 do NAND operation
	 BL __nand;					If case = 5, NAND 
	 B Loop8;
Loop6	 CMP R7,#6;
	 BNE Loop7;	If switch case is 6 do NOR operation
	 BL __nor;					If case = 6, NOR 
	 B Loop8;
Loop7	 
	 BL printMsginvalid;	 If none of the above cases invalid operation thus print it
	 B stop;	 

Loop8
	 BL printMsg4p;
	 B stop;
	 ENDFUNC

;----------------------------------------------------------------------------------------

__sigmoid FUNCTION
	 ;Compute sigmoid function 
	 PUSH {LR};
	 VLDR.F32 S8,= 1;			
	 VADD.F32 S9,S11,S8;		        (e^-x)+1
	 VDIV.F32 S9,S8,S9;			 1 / (e^-x)+1  i.e sigmoid function
	 POP {LR};	
	 BX lr;
	ENDFUNC
;---------------------------------------------------------------------------------------

__eval FUNCTION
	 PUSH {LR}
	 BL __exp;					Compute e^-x
	 BL __sigmoid;				Sigmoid function 

	 VLDR.F32 S14,= 0.5;		        Store 0.5 for threshold
	 VCMP.F32 S9,S14;			Compare current Y and 0.5		
	 VMRS    APSR_nzcv, FPSCR;
	 MOVGT	R3, #1;				If Y > 0.5, output is 1
	 MOVLT	R3, #0;				If Y < 0.5, output is 0
	 POP {LR}
	 BX lr
	 ENDFUNC	 


;		logic AND

__and FUNCTION
	 PUSH {LR};	 
	 VLDR.F32 S4,= -0.1;			W1
	 VLDR.F32 S5,= 0.2;			W2
	 VLDR.F32 S6,= 0.2;			W3
	 VLDR.F32 S7,= -0.2;		    Bias

	 VMUL.F32 S0,S0,S4;			a1*w1
	 VMUL.F32 S1,S1,S5;			a2*w2
	 VMUL.F32 S2,S2,S6;			a3*w3
	 VADD.F32 S3,S0,S1;			a1*w1 + a2*w2 
	 VADD.F32 S3,S3,S2;			a1*w1 + a2*w2 + a3*w3 
	 VADD.F32 S3,S3,S7;			a1*w1 + a2*w2 + a3*w3 + b

	 VMOV.F32 S10,S3;			
	 BL __eval;

	 POP {LR};	
	 BX lr;
	 ENDFUNC

;		logic OR

__or FUNCTION
	  PUSH {LR};	 
	 VLDR.F32 S4,= -0.1;			W1
	 VLDR.F32 S5,= 0.7;			W2
	 VLDR.F32 S6,= 0.7;			W3
	 VLDR.F32 S7,= -0.1;			Bias
	 
	 VMUL.F32 S0,S0,S4;			A1*W1
	 VMUL.F32 S1,S1,S5;			A2*W2
	 VMUL.F32 S2,S2,S6;			A3*W3
	 VADD.F32 S3,S0,S1;			A1*W1 + A2*W2 
	 VADD.F32 S3,S3,S2;			A1*W1 + A2*W2 + A3*W3 
	 VADD.F32 S3,S3,S7;			A1*W1 + A2*W2 + A3*W3 + B

	 VMOV.F32 S10,S3;			S10 has the value of x
	 BL __eval;
	 POP {LR};	
	 BX lr;
	 ENDFUNC

;		logic NOT	

__not FUNCTION
	  PUSH {LR};	 
	 VLDR.F32 S4,= 0.5;			W1
	 VLDR.F32 S5,= -0.7;			W2
	
	 VLDR.F32 S7,= 0.1;			Bias
;Only 2 weights were given in Python function

	 VMUL.F32 S0,S0,S4;			A1*W1
	 VMUL.F32 S1,S1,S5;			A2*W2
	
	 VADD.F32 S3,S0,S1;			A1*W1 + A2*W2 
	 
	 VADD.F32 S3,S3,S7;			A1*W1 + A2*W2  + B
	
	 
	 VMOV.F32 S10,S3;			
	 BL __eval;
	 POP {LR};	
	 BX lr;
	 ENDFUNC

;same weights and bias were given for xor and xnor gate

;		logic XOR

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
	 BL __eval;
	 POP {LR};	
	 BX lr;
	 ENDFUNC

	

;		logic XNOR

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
	 BL __eval;
	 POP {LR};	
	 BX lr;
	 ENDFUNC

;		logic NAND

__nand FUNCTION
	  PUSH {LR};	 
	 VLDR.F32 S4,= 0.6;			W1
	 VLDR.F32 S5,= -0.8;			W2
	 VLDR.F32 S6,= -0.8;			W3
	 VLDR.F32 S7,= 0.3;			Bias
	 

	 VMUL.F32 S0,S0,S4;			A1*W1
	 VMUL.F32 S1,S1,S5;			A2*W2
	 VMUL.F32 S2,S2,S6;			A3*W3
	 VADD.F32 S3,S0,S1;			A1*W1 + A2*W2 
	 VADD.F32 S3,S3,S2;			A1*W1 + A2*W2 + A3*W3 
	 VADD.F32 S3,S3,S7;			A1*W1 + A2*W2 + A3*W3 + B

	 VMOV.F32 S10,S3;			
	 BL __eval;
	 POP {LR};	
	 BX lr;
	 ENDFUNC

;		logic NOR

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

	 VMOV.F32 S10,S3;			
	 BL __eval;
	 POP {LR};	
	 BX lr;
	 ENDFUNC

__exp FUNCTION
	 ; S10 has value of x
	 VNEG.F32 S10,S10;			S10 has -x
	 
	 MOV R8,#200;				No of terms in the series
     MOV R9,#1;	    			Count
	 
     VLDR.F32 S11,=1;			Store value of e^x
     VLDR.F32 S12,=1;			Temp variable to hold the previous term     
	 
LOOP9 
	 CMP R9,R8;					Compare count and no of term
     BLE LOOP10;				If count is < no og terms enter LOOP1	
     BX LR;						else STOP
	 
LOOP10  
	 VMUL.F32 S12,S12,S10; 		Temp_var = temp_var * x
     VMOV.F32 S13,R9;			Move the count in R9 to S13 (floating point register)
     VCVT.F32.S32 S13,S13; 		Convert into signed 32bit number
     VDIV.F32 S12,S12,S13;		Divide temp_var by count (Now the term is finished)
     VADD.F32 S11,S11,S12;		Add temp_var to the sum
     ADD R9,R9,#1;				Increment the count
     B LOOP9;
	 
	 ENDFUNC
	


;--------------------------------------------------------------------------------------------------

stop B stop
    END
