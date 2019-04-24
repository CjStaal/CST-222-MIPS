#include <windows.h>
#include <time.h>

#define INFO_BUFFER_SIZE 32767
time_t ptime;
int    bufCharCount = INFO_BUFFER_SIZE;
char   infoBuf[INFO_BUFFER_SIZE];
char   computerName[INFO_BUFFER_SIZE];
char   studentName[INFO_BUFFER_SIZE ];
#define INITCST(x,y) \
	GetComputerName( computerName, &bufCharCount ); \
	strcpy_s(studentName,INFO_BUFFER_SIZE,y); \
	time(&ptime);\
	ctime_s(&infoBuf[0],INFO_BUFFER_SIZE,&ptime);\
	printf("Student name: %s ",studentName);  \
	printf("\n\nCSE222 %s submitted by: %s\n\n",x,y);\
	printf("\n\t\t run on : %s",infoBuf); \
	printf("\n\t\t running on computer <%s> \n\n",computerName); \
	printf("--------------------------------------------------------------\n\n");


/*
typedef struct _SYSTEMTIME {
  WORD wYear;
  WORD wMonth;
  WORD wDayOfWeek;
  WORD wDay;
  WORD wHour;
  WORD wMinute;
  WORD wSecond;
  WORD wMilliseconds;
} SYSTEMTIME, *PSYSTEMTIME;

*/