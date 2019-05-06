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
void processConfigs(int argc,char *argv[] );
void insertion_sort (int *a, int n, int hpts);
void selection_sort (int *a, int n, int hpts);
void restoreOrigArray(int *origAry,int *wrkAry, int n);
void printList(int *list, int arrayLen);
int letsCheckTheSort();
int compareCheck(int *myLst,int *stuLst, int cntN);
int letsTimeTheSort();


int  numCount = 20;
int  originalNumber[100] = {5, 8, 12, 10, 56, 22, 98, 120, 90, 4, 349, 8, 45, 37, 43, 67, 3, 18, 97, 71};
int  listOfNumber[100]   = {5, 8, 12, 10, 56, 22, 98, 120, 90, 4, 349, 8, 45, 37, 43, 67, 3, 18, 97, 71};
char sortType = 'I';   // 'I' for insert sort otherwise it is selection sort

main(int argc, char *argv[] )
{
	/* 
	 * variable declaration here
	 */

	int tmp1 = 0;
	processConfigs(argc,argv);
    

   /*
	* First call INITCST
	* replace Your Name Here with your name
	*/

	INITCST("Fall 2018 Sort routine using x86: ","Charles Staal");
	sortType = 'I';   // 'I' capital I for insert sort otherwise it is selection sort


	asmSort( listOfNumber, numCount, HALFPOINT);
	
	


	if (letsCheckTheSort() == 0) {
		printf("\n You have pass the sort check.....  now let's time it ......\n\n");
		letsTimeTheSort();
	}
	else printf("\n********* sort fail on the check sort\ncan not continue for timing \n");
	
	printf("\n\n\nhit any key to continue or quit");
	getchar();
}



void restoreOrigArray(int *origAry,int *wrkAry, int n) {
	int i;
	for (i=0; i<n; i++) {
		wrkAry[i] = origAry[i];
	}
}


void printList(int *list, int arrayLen) {
	int i;
	for ( i = 0; i<arrayLen; i++) {
		printf("%5d",*list);
		if ((i+1) % 10 == 0) printf("\n");
		list++;
	}
	printf("\n");
}



void asmSort(int *list, int arrayLen, int halfpoint) {

	/*
	 * list = address of the list of integer array
	 * arraylen = the number of element in the list  just like list.length in java
	 * halfpoint  use as a flag
	 * halpfpoint = 1 when the sort routine reach half point just return,
	 *              otherwise finished the sort and return
	 */
	_asm
	{

		mov ecx, arrayLen
		mov esi, list
		mov ebx, halfpoint
		mov eax, 0

		more:
		cmp ecx, 0				//If Arraylength <= 0
			jle	done				//Exit
			mov edi, eax			//J = I
			push eax                //push eax (i) to free up register for key
			mov eax, [esi + edi]		//Key = Array[i] technically j but j=i atm
			sub edi, 4				//J - 1
			mov edx, arrayLen		//K = Arraylength
			sar edx, 1				//Signed Shift Right K by 1
			add edx, 1				//Correcting the half point checker by 1
			cmp ecx, edx			//IF Arraylength > K
			jg  cont1				//Jump cont1 hey
			cmp halfpoint, 1		//IF halfpoint = 1
			je  done2				//Exit ELSE cont1

			cont1 :
		cmp edi, 0					//If j<= 0 exit loop
			jl cont2
			cmp[esi + edi], eax		//If Array[J] <= key exit loop
			jle cont2
			mov edx, [esi + edi]          //k = Array[j]
			mov[esi + edi + 4], edx		//Array[j+1] = Array j
			sub edi, 4					//J--				
			jmp cont1

			cont2 :
			mov[esi + edi + 4], eax	//Array[j+1] = key				
			pop eax					//Pop eax to get i from before for use above
			add eax, 4				//Increment i
			dec	ecx					//Decrement ArrayLength
			jmp	more

			done2 :				//halfpoint stack reset
		pop eax;
	done:
	}

	return;

}