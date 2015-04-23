# include<stdio.h>
#include<stdlib.h>
int main()
{
char buff[50];
int ret, a=34, b=234;
ret = sprintf(buff, "%d minus %d equals %d",a,b,a-b);
printf("(%s) is the result of our sprintf, which is %d characters long", buff,ret);
return 0;
}
