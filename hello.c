#include<stdlib.h>
#include<stdio.h>

int main()
{
int i;

long int id = 903422;
char buff[10];

sprintf(buff,"%ld",id);
printf("Hello! I'm a student");
for(i=0;i<3;++i)
printf("%c",buff[i]);
return 0;
}
