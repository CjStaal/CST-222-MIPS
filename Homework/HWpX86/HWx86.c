#include <stdio.h>
#include "cse222macV4.h"
/*
 * declare the prototype of your assembler program or procedures
 */
// example: short asmreturn();  

//int ASMFormula(int y, int z, int t);
int ASMstrlen(char *str1);
int ASMArySum(int *p, int n);
char str1[] = "The red fox jump over the fence";
char str2[] = "The chicken and duck hide under the rose bushes";
int arynum[] = {40,-70,90};
int arylen = 3;
short tnum[] = {89,9,76};


main(int argc, char *argv[] )
{
	/* 
	 * variable declaration here
	 */

//	int result;
	int y = 8;
	int z = 20;
	int t = 68;


   /*
	* First call INITCST
	* replace Your Name Here with your name
	*/

	INITCST("x86 practice","student name here");

	/*
	 * call your asm procedure here
	 * you can use any variable name you want and make sure the return type
	 * is correct.
	 */
	
	printf(" for str1 <%s>\n",str1);
	printf("          from ASMstrLen : %d  C strlen: %d\n", ASMstrlen(str1), strlen(str1));
	printf("\n------------------------------------------------------------\n\n");
	printf(" for str2 <%s>\n",str2);
	printf("          from ASMstrLen : %d  C strlen: %d\n", ASMstrlen(str2), strlen(str2));
	printf("\n------------------------------------------------------------\n\n");

	printf(" find the sum of array  : %d\n",ASMArySum(&arynum[0], arylen) );
	printf("\n------------------------------------------------------------\n");
	
	printf("\n\nhit any key  .......  quit");
	getchar();

}


int ASMstrlen(char *str1)
{
	int asmlen = -99;

	_asm{
		// use ecx as count
		//     esi - base address of string
		mov esi, str1   // get the base address string
		mov ecx, 0      // use ecx as count


//done:	mov asmlen,ecx  // return the value of count
	}
	
	return(asmlen);
}

int ASMArySum(int *p, int n)
{
	int sum = -99999;
	int i	= n;
	_asm {
		//  use esi base address of array
		//      eax as sum
		mov esi, p    // get the base address
SumIsDone:
		mov	sum,eax   // return the sum accumalated in eax
	}

	return(sum);
}

