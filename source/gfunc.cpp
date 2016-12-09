
#include"head.h"
// global function
unsigned long int power2(int ndim,int depth)
{
	unsigned long int output = 1;
	int k = ndim*depth;
	while(k > 0)
	{
		output = output*2;
		k--;
	}
	return output;

}
int char2num(char ch)
{
	return ch -'0';
}
int to2num(char *str,int length)
{
	char *p = str + length - 1;
	int i =length;
	int output = 0;
	while(i> 0)
	{
		if(*p == '1')
			output = output*2 +1;
		else if(*p == '0')
			output = output*2;
		else
			return -1;
		i--;
		p--;

	}
	return output;
}

