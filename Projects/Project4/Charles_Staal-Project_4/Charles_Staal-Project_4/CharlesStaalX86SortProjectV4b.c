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


	//asmSort( listOfNumber, numCount, HALFPOINT);
	
	


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
	void as1mSort(int *list, int arrayLen, int halfpoint)
	{
	int i = 1, j, k;

	if (halfpoint)
	arrayLen = arrayLen / 2;
	do
	{
	k = list[i];
	j = i - 1;
	while ((j >= 0) && (k < list[j]))
	{
	list[j + 1] = list[j];
	--j;
	}
	list[j + 1] = k;
	i++;
	arrayLen--
	} while (arrayLen > 0);
	}*/
	_asm
	{
		mov ecx, arrayLen				// n
		mov esi, list
		mov ebx, halfpoint				// First halfpoint, then j
		mov eax, 0						// i = 0

		cmp ebx, 0						// if(!halfpoint)
		je main_loop					// go to main loop
		shr ecx, 1						// n/2

		main_loop :
		mov edx, [esi + eax]			// key = arr[i]
			lea ebx, [esi + eax - 4]	// j = i - 1
			inner_loop :				// while ( j >= 0 && arr[j] > key )
			cmp [ebx], edx				// (if arr[j] <= key, leave )
				jle end_inner
				mov edi, [ebx]			// edi = arr[j]
				mov[ebx + 4], edi		// arr[j + 1] = edi;
				sub ebx, 4				// j = j - 1;
				jnz inner_loop
			end_inner :
		mov[ebx + 4], edx				// arr[j + 1] = key;
			add eax, 4					// i++
			dec ecx
				jnz main_loop
	}
	return;
}