/************************************************************************
 *
 *       x86 sort project :
 *
 *		implement sort (either insertion sort)
 *		translated from the Mips sort project
 *
 *
 *************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "cse222macV4.h"
#define HALFPOINT 1
#define NO_HALFPOINT 0
 /*
  * declare the prototype of your assembler program or procedures
  */
  // example: short asmreturn();  

void asmSort(int *list, int arrayLen, int halfpoint);
void processConfigs(int argc, char *argv[]);
void insertion_sort(int *a, int n, int hpts);
void selection_sort(int *a, int n, int hpts);
void restoreOrigArray(int *origAry, int *wrkAry, int n);
void printList(int *list, int arrayLen);
int letsCheckTheSort();
int compareCheck(int *myLst, int *stuLst, int cntN);
int letsTimeTheSort();


int  numCount = 20;
int  originalNumber[100] = { 5, 8, 12, 10, 56, 22, 98, 120, 90, 4, 349, 8, 45, 37, 43, 67, 3, 18, 97, 71 };
int  listOfNumber[100] = { 5, 8, 12, 10, 56, 22, 98, 120, 90, 4, 349, 8, 45, 37, 43, 67, 3, 18, 97, 71 };
char sortType = 'I';   // 'I' for insert sort otherwise it is selection sort

main(int argc, char *argv[])
{
	/*
	 * variable declaration here
	 */

	int tmp1 = 0;
	processConfigs(argc, argv);


	/*
	 * First call INITCST
	 * replace Your Name Here with your name
	 */

	INITCST("Fall 2018 Sort routine using x86: ", "Charles Staal");
	sortType = 'I';   // 'I' capital I for insert sort otherwise it is selection sort


	/*
	 * call your asm procedure here
	 * you can use any variable name you want and make sure the return type
	 * is correct.
	 */




	if (letsCheckTheSort() == 0) {
		printf("\n You have pass the sort check.....  now let's time it ......\n\n");
		letsTimeTheSort();
	}
	else printf("\n********* sort fail on the check sort\ncan not continue for timing \n");

	printf("\n\n\nhit any key to continue or quit");
	getchar();
}



void restoreOrigArray(int *origAry, int *wrkAry, int n) {
	int i;
	for (i = 0; i < n; i++) {
		wrkAry[i] = origAry[i];
	}
}


void printList(int *list, int arrayLen) {
	int i;
	for (i = 0; i < arrayLen; i++) {
		printf("%5d", *list);
		if ((i + 1) % 10 == 0) printf("\n");
		list++;
	}
	printf("\n");
}



void asmSort(int *list, int arrayLen, int halfpoint) {

	/*
	 * list = base address of the list of integer array
	 * arraylen = the number of element in the list  just like list.length in java
	 * halfpoint  use as a flag
	 * halpfpoint = 1 when the sort routine reach half point  return,
	 *              otherwise finished the sort and return
	 */

	 /*
	  *
	  *
	  insertion_sort(list,arrayLen,halfpoint);
	  return;

	  *
	  *
	  */


	  // any variable can be declare here before _asm
	  /*
	  int tmp = 0;
	  int  i = 0;
	  int  j = 0;
	  */
	_asm
	{
		/* the following are just a suggestion of what your code would look like  ****
		   you do not have to follow it                                           ****

				mov ecx,arrayLen
				mov esi,list
				mov ebx,halfpoint
				....



				; .......
		more:		cmp ecx,0
				jle	done
				;.........
				mov edx,arrayLen
				sar edx,1
				cmp ecx,edx
				jg  cont1
				cmp halfpoint,1
				je  partialdone           ; return
		cont1:  	;.....
				;......
				;.......
				;.....
				mov [esi],eax
				add	esi,4
				dec	ecx
				jmp	more
		done:
		partialdone:
		************************************************************************************************/

		/* erase above comment and
		   you can start here */

	}

	return;

}