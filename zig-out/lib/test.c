#include <stdio.h>

int stringLength(const char* msg);

int main(void)
{
	const char* msg = "foo bars";
	const int len = stringLength(msg);
	printf("The length of \"%s\" is %d\n",msg,len);
	return 0;
}
