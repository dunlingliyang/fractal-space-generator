//status:finishing
//version:v1
#include"mex.h"
#include"matrix.h"

#ifndef HEAD_H_
#define HEAD_H_

class feature
{
private:

	int ** feaVector;
	int size; //for alloc the memory
	int len; // for alloc the memory
	int ndim;
	int depth;

public:

	feature();
	feature(int, int, int);
	~feature();
	void addLine();
	void store(int);
	int getLen();
	unsigned long int getLineSize();
	void transaction(double*);

};
unsigned long int power2(int ndim, int depth);
int char2num(char ch);
int to2num(char *str, int length);

#endif /* HEAD_H_ */
