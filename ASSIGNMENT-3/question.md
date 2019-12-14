Step -1

Go through the following Videos about Machine Learning ( I had already shared this through Whatsapp)

1. https://youtu.be/h2j7J08eSv8
2.https://youtu.be/ZLIQuopOjz4
3.https://youtu.be/p-06Z6zO4Po

Based on the discussion in Video you are expected to implement the following LOGIC OPERATIONS using Neural Network in Cortex M4 process using Floating point processor. Please NOTE: YOU NEED TO USE FPU (not the regular processor).


logic_and
logic_or
logic_not
logic_xor
logic_xnor
logic_nand
logic_nor

All the gate implementation take THREE INPUT.

Hint:  we had already completed the Infinite series e to power x. Take the same code Implement the sigmoid fucntion which cane used for implementing the Neural Network

Complete code in python is given in following URL. Study this code and implement the same using CORTEXM$ Assembly instructions for FPU

https://github.com/fjcamillo/Neural-Representation-of-Logic-Functions/blob/master/Logic.py

Once you compute the output value of NN it will be in FPU register in IEEE FP format.

This has to be converted to TRUE value and printed.

As there is printf() in assembly, I had create a frame work for you generate equivalent of printf() messages on KEIL.

Remember the method we used for generating core Dumps in C the same method. This routine is written in C and we call that from assembly language. How do you call  C routine from Assembly, I had attached project below FP_WITH_C_FUNCTION.zip use this project and do all your assignment. To print any value move that to R0 and call the print routine. Once you go through this code you will understand.

So this project as a template and implement the feed forward function. We use using Texas Instruments Tiva series board here (I mean the simulation model of this board) for the assignment. I had done all the configuration for you the project. So no need to worry about those details. Just take this project and start writing your code in ARM Cortex M4 assembly Lanaguage.  Do not use C for any thing except the routine I had provided.
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

Please remember : You had already implement the exponent Series in Assignment -4. You need to build on top of this.

Follow the steps given below:
1. Take the code from assignment-4 and make it into a sub-routine.
2. Implement Sigmoid function as another routine and test it completely.
3. To test your  implementation of  sigmoid funcion, generate the output for  input values ranging from -5 to +5 and make sure you are getting the curve as expected (refer to video)  Use the print function I had provided and copy paste the output to a spread sheet and plot it.
4. By now the basic component to build the neural network is ready
5. Go through the python code and implement the neural network step by step  (consider python code as pseudo code of what you need to do)
6. During this process  of implementation  you will get to learn how to implement switch-case equivalent in cortex M4. Floating point instructions. Convertion of TRUE Value of a  number to IEEE FP standards and back to TRUE value.
7. You will learn how to call a C routine from assembly
8. How to pass parameter between a C routine and assembly. (APCS what we discussed in class)
9. If you have time, compile this code for one of h/w board available in lab (In that case you will have to remove he print function) and make LED blink using neural network. You can provide inputs through GPIO pins. ( You will be give extra points for testing it on h/w).Remember you need to create a new project for the board you are using (STMF32 or freescale) and copy this code.
