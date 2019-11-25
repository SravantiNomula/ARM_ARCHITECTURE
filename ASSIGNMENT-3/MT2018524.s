 ;a1,a2,a3 are the 3 inputs, w1,w2,w3 are the 3 outputs
 ; R4---a1
 ;R5----a2
 ;R6----a3
 ;R7-- case select if (0 and) (1 or) (2 not) (3 xor) (4 xnor) (5 nand)  (6 nor)

    THUMB
	PRESERVE8	
	AREA  first, CODE,READONLY
	EXPORT __main
	IMPORT printMsg
	IMPORT printMsginvalid
	IMPORT __exp
		ENTRY

__main FUNCTION
	
	 MOV R4,#0;	a1
	 VMOV.F32 S0,R4;			Move A1 to S0 (floating point register)
     VCVT.F32.S32 S0,S0; 		Convert into signed 32bit number

	 MOV R5,#1;	a2	
	 VMOV.F32 S1,R5;			Move A2 to S1 (floating point register)
     VCVT.F32.S32 S1,S1; 		Convert into signed 32bit number
	 
	 
	 MOV R6,#1;	a3
	 VMOV.F32 S2,R6;			Move A3 to S2 (floating point register)
     VCVT.F32.S32 S2,S2; 		Convert into signed 32bit number
	 
	 
	 MOV R7,#0;	Case select
	 

	 
	
	 
	 ; Switch - Case
	 CMP R7,#0;
	 BNE L1;   If switch case is 0 do AND operation
	 BL __and;					If case = 0, AND 
	 B L8;
	 
L1	 CMP R7,#1;
	 BNE L2;    If switch case is 1 do OR operation
	 BL __or;					If case = 1, OR 
	 B L8;
L2	 CMP R7,#2;
	 BNE L3;	If switch case is 2 do NOT operation
	 BL __not;					If case = 2, NOT
	 B L8;
L3	 CMP R7,#3;
	 BNE L4;     If switch case is 3 do XOR operation
	 BL __xor;					If case = 3, XOR
	 B L8;
L4	 CMP R7,#4;
	 BNE L5;	 If switch case is 4 do XNOR operation
	 BL __xnor;					If case = 4, XNOR
	 B L8;	
L5	 CMP R7,#5;	  
	 BNE L6;	If switch case is 5 do NAND operation
	 BL __nand;					If case = 5, NAND 
	 B L8;
L6	 CMP R7,#6;
	 BNE L7;	If switch case is 6 do NOR operation
	 BL __nor;					If case = 6, NOR 
	 B L8;
L7	 
	 BL printMsginvalid;	 If none of the above cases invalid operation thus print it
	 B stop;	 
	 
L8
	 BL printMsg;
	 B stop;
	 ENDFUNC

;----------------------------------------------------------------------------------------

__sigmoid FUNCTION
	 ;Compute sigmoid function 
	 PUSH {LR};
	 VLDR.F32 S8,= 1;			
	 VADD.F32 S9,S11,S8;		 (e^-x)+1
	 VDIV.F32 S9,S8,S9;			 1 / (e^-x)+1  i.e sigmoid function
	 POP {LR};	
	 BX lr;
	ENDFUNC
;---------------------------------------------------------------------------------------

__val FUNCTION
	 PUSH {LR}
	 BL __exp;					Compute e^-x
	 BL __sigmoid;				Sigmoid function 
	 
	 VLDR.F32 S14,= 0.5;		Store 0.5 in S14
	 VCMP.F32 S9,S14;			Compare current Y and 0.5		
	 VMRS    APSR_nzcv, FPSCR;
	 MOVGT	R0, #1;				If Y > 0.5, output is 1
	 MOVLT	R0, #0;				If Y < 0.5, output is 0
	 POP {LR}
	 BX lr
	 ENDFUNC	 

	
;		logic AND

__and FUNCTION
	 PUSH {LR};	 
	 VLDR.F32 S4,= 2;			Weight 1
	 VLDR.F32 S5,= 2;			Weight 2
	 VLDR.F32 S6,= 2;			Weight 3
	 VLDR.F32 S7,= -5;		    Bias
	 
	 VMUL.F32 S0,S0,S4;			a1*w1
	 VMUL.F32 S1,S1,S5;			a2*w2
	 VMUL.F32 S2,S2,S6;			a3*w3
	 VADD.F32 S3,S0,S1;			a1*w1 + a2*w2 
	 VADD.F32 S3,S3,S2;			a1*w1 + a2*w2 + a3*w3 
	 VADD.F32 S3,S3,S7;			a1*w1 + a2*w2 + a3*w3 + b
	 
	 VMOV.F32 S10,S3;			
	 BL __val;
	 
	 POP {LR};	
	 BX lr;
	 ENDFUNC

;		logic OR

__or FUNCTION
	 PUSH {LR};	 
	 VLDR.F32 S4,= 2;			Weight 1
	 VLDR.F32 S5,= 2;			Weight 2
	 VLDR.F32 S6,= 2;			Weight 3
	 VLDR.F32 S7,= -1;			Bias
	 
	 VMUL.F32 S0,S0,S4;			A1*W1
	 VMUL.F32 S1,S1,S5;			A2*W2
	 VMUL.F32 S2,S2,S6;			A3*W3
	 VADD.F32 S3,S0,S1;			A1*W1 + A2*W2 
	 VADD.F32 S3,S3,S2;			A1*W1 + A2*W2 + A3*W3 
	 VADD.F32 S3,S3,S7;			A1*W1 + A2*W2 + A3*W3 + B
	 
	 VMOV.F32 S10,S3;			S10 has the value of x
	 BL __val;
	 POP {LR};	
	 BX lr;
	 ENDFUNC

;		logic NOT	We only consider 1st input (in R4) for NOT 

__not FUNCTION
	 PUSH {LR};	 
	 VLDR.F32 S4,= -2;			Weight 1
	 ;VLDR.F32 S5,= 1;			Weight 2
	 ;VLDR.F32 S6,= 1;			Weight 3
	 VLDR.F32 S7,= 1;			Bias
	 
	 VMUL.F32 S0,S0,S4;			A1*W1
	 ;VMUL.F32 S1,S1,S5;			A2*W2
	 ;VMUL.F32 S2,S2,S6;			A3*W3
	 ;VADD.F32 S3,S0,S1;			A1*W1 + A2*W2 
	 ;VADD.F32 S3,S3,S2;			A1*W1 + A2*W2 + A3*W3 
	 ;VADD.F32 S3,S3,S7;			A1*W1 + A2*W2 + A3*W3 + B
	 VADD.F32 S3,S0,S7;			A1*W1 + B
	 
	 VMOV.F32 S10,S3;			S10 has the value of x
	 BL __val;
	 POP {LR};	
	 BX lr;
	 ENDFUNC

;		logic XOR

__xor FUNCTION
	
	PUSH {LR};
	 ; Store the inputs 
	 VMOV.F32 S19,S0;			S19 has A1
	 VMOV.F32 S20,S1;			S20 has A2
	 VMOV.F32 S21,S2;			S21 has A3
	 
	 BL __not;					Computes not for A
			;					A' stored in R0
	 VMOV.F32 S22,R0;			Move the count in R0 to S22 (floating point register)
     VCVT.F32.S32 S22,S22; 		Convert into signed 32bit number	 
	 
	 VMOV.F32 S0,S20;			Move value of A2 to S0			
	 BL __not;					Computes not for B
			;					B' stored in R1
	 VMOV.F32 S23,R0;			Move the count in R1 to S23 (floating point register)
     VCVT.F32.S32 S23,S23; 		Convert into signed 32bit number
	 
	 VMOV.F32 S0,S21;			Move value of A3 to S0	
	 BL __not;					Computes not for C
			;					C' stored in R2
	 VMOV.F32 S24,R0;			Move the count in R2 to S24 (floating point register)
     VCVT.F32.S32 S24,S24; 		Convert into signed 32bit number
	 
;1)	 A1'*A2*A3'	
	 VMOV.F32 S0,S22;	
	 VMOV.F32 S1,S20;
	 VMOV.F32 S2,S24;
	 BL __and;					compute A1'*A2*A3' 
	 MOV R4,R0;					Store value in R4
	 
;2)	 A1*A2'*A3'	
	 VMOV.F32 S0,S19;	
	 VMOV.F32 S1,S23;
	 VMOV.F32 S2,S24;
	 BL __and;					compute A1*A2'*A3' 
	 MOV R5,R0;					Store value in R5

;3)	 A1'*A2'*A3	
	 VMOV.F32 S0,S22;	
	 VMOV.F32 S1,S23;
	 VMOV.F32 S2,S21;
	 BL __and;					compute A1'*A2'*A3 
	 MOV R6,R0;					Store value in R6
	 
;4)	 A1*A2*A3	
	 VMOV.F32 S0,S19;	
	 VMOV.F32 S1,S20;
	 VMOV.F32 S2,S21;
	 BL __and;					compute A1*A2*A3 
	 MOV R7,R0;					Store value in R7	

;    Compute OR for R4, R5, R6, R7

	 VMOV.F32 S0,R7;			Move the count in R4 to S0 (floating point register)
     VCVT.F32.S32 S0,S0; 		Convert into signed 32bit number
	 VMOV.F32 S1,R6;			Move the count in R5 to S1 (floating point register)
     VCVT.F32.S32 S1,S1; 		Convert into signed 32bit number
	 VMOV.F32 S2,R5;			Move the count in R6 to S2 (floating point register)
     VCVT.F32.S32 S2,S2; 		Convert into signed 32bit number
	 
	 BL __or;					Computes OR for R7+R6+R5
	 MOV R7,R0;					Store value in R7	
	 
	 VMOV.F32 S0,R4;			Move the count in R4 to S0 (floating point register)
     VCVT.F32.S32 S0,S0; 		Convert into signed 32bit number
	 VMOV.F32 S1,R7;			Move the count in R4 to S0 (floating point register)
     VCVT.F32.S32 S1,S1; 		Convert into signed 32bit number
	 VLDR.F32 S2,= 0;			3rd input
	 
	 BL __or;					Computes AND for R7+R6+R5+R4

	 POP {LR};		
	 BX lr;
	 ENDFUNC

;		logic XNOR

__xnor FUNCTION
	 PUSH {LR};		

	 BL __xor;
	 VMOV.F32 S0,R0;			Move the count in R4 to S0 (floating point register)
     VCVT.F32.S32 S0,S0; 		Convert into signed 32bit number
	 BL __not;
	 
	 POP {LR};	
	 BX lr;
	 ENDFUNC

;		logic NAND

__nand FUNCTION
	 PUSH {LR};	 
	 VLDR.F32 S4,= -2;			Weight 1
	 VLDR.F32 S5,= -2;			Weight 2
	 VLDR.F32 S6,= -2;			Weight 3
	 VLDR.F32 S7,= 5;			Bias
	 
	 VMUL.F32 S0,S0,S4;			A1*W1
	 VMUL.F32 S1,S1,S5;			A2*W2
	 VMUL.F32 S2,S2,S6;			A3*W3
	 VADD.F32 S3,S0,S1;			A1*W1 + A2*W2 
	 VADD.F32 S3,S3,S2;			A1*W1 + A2*W2 + A3*W3 
	 VADD.F32 S3,S3,S7;			A1*W1 + A2*W2 + A3*W3 + B
	 
	 VMOV.F32 S10,S3;			S10 has the value of x
	 BL __val;
	 POP {LR};	
	 BX lr;
	 ENDFUNC

;		logic NOR

__nor FUNCTION
	 PUSH {LR};	 
	 VLDR.F32 S4,= -10;			Weight 1
	 VLDR.F32 S5,= -10;			Weight 2
	 VLDR.F32 S6,= -10;			Weight 3
	 VLDR.F32 S7,= 5;			Bias
	 
	 VMUL.F32 S0,S0,S4;			A1*W1
	 VMUL.F32 S1,S1,S5;			A2*W2
	 VMUL.F32 S2,S2,S6;			A3*W3
	 VADD.F32 S3,S0,S1;			A1*W1 + A2*W2 
	 VADD.F32 S3,S3,S2;			A1*W1 + A2*W2 + A3*W3 
	 VADD.F32 S3,S3,S7;			A1*W1 + A2*W2 + A3*W3 + B
	 
	 VMOV.F32 S10,S3;			S10 has the value of x
	 BL __val;
	 POP {LR};	
	 BX lr;
	 ENDFUNC
	  		 
;--------------------------------------------------------------------------------------------------

stop B stop
    END
