#include "stm32f4xx.h"
#include <string.h>

void printMsginvalid()
{
	char Msg[100];
	 char *ptr;
	 sprintf(Msg,"Invalid Operation Type\n");
	 ptr = Msg ;
   while(*ptr != '\0'){
      ITM_SendChar(*ptr);
      ++ptr;
   }
}
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

