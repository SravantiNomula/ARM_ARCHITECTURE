#include "stm32f4xx.h"
#include <string.h>

void printwelcome(const int a)
{
char *pointer_1;
pointer_1="___TRUTH___TABLE__FOR___NN__LOGIC_GATES____";
	
	 while(*pointer_1 != '\0'){
      ITM_SendChar(*pointer_1);
      ++pointer_1;
   }
	 return;
}

void printtitle(const int a)
{
char *pointer_1;
	 
	 if(a==0){ pointer_1 = "\nAND(a1,a2,a3,y):\n"; }
	 if(a==1){ pointer_1 = "\nOR(a1,a2,a3,y):\n"; }
	 if(a==2){ pointer_1 = "\nNOT(a1,a2,a3,y):\n"; }
	 if(a==5){ pointer_1 = "\nNAND(a1,a2,a3,y):\n"; }
	 if(a==6){ pointer_1 = "\nNOR(a1,a2,a3,y):\n"; }
	
	 while(*pointer_1 != '\0'){
      ITM_SendChar(*pointer_1);
      ++pointer_1;
   }
	 return;}


void printMsg(const int a)
{
	 char Msg[100];
	 char *ptr;
	 sprintf(Msg, "%x", a);
	 ptr = Msg ;
   while(*ptr != '\0'){
      ITM_SendChar(*ptr);
      ++ptr;
   }
}

void printMsg4p(const int a, const int b, const int c, const int d, const int e)
{
	 char Msg[100];
	 char *ptr;
	
	 sprintf(Msg, "%x", a);
	 ptr = Msg ;
   while(*ptr != '\0')
	 {
      ITM_SendChar(*ptr);
      ++ptr;
   }
	
	 sprintf(Msg, "%x", b);
	 ptr = Msg ;
   while(*ptr != '\0')
	 {
      ITM_SendChar(*ptr);
      ++ptr;
   }
	 
	 sprintf(Msg, "%x", c);
	 ptr = Msg ;
   while(*ptr != '\0')
	 {
      ITM_SendChar(*ptr);
      ++ptr;
   }
	 
	 sprintf(Msg, "%x\n", d);
	 ptr = Msg ;
   while(*ptr != '\0')
	 {
      ITM_SendChar(*ptr);
      ++ptr;
	 }

	 
}
