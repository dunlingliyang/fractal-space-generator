//status:finishing
//version:v1
#include"head.h"
#include"mex.h"
#include"matrix.h"
#include<cstdio>
feature::feature()
{
	feaVector = NULL;
	size = len = 0;
	ndim = depth = 0;
}
feature::feature(int inputDim, int inputDepth, int initialSize)
{
	feaVector = (int **) mxMalloc((unsigned int) initialSize * sizeof(int*));
	size = initialSize;
	len = -1;
	ndim = inputDim;
	depth = inputDepth;

}
void feature::store(int index)
{
	if (size == 0)
	{
		mexErrMsgTxt("error in using the initial function");
	}

	feaVector[len][index]++;
}
void feature::addLine()
{
	unsigned long int temp;
	temp = power2(ndim, depth);
	len ++;
	if (len >= size)
	{
		feaVector = (int**) mxMalloc(2 * size * sizeof(int*));
		size = size * 2;
		feaVector[len] = (int*) mxMalloc(temp * sizeof(int));
		for (int i = 0; i < temp; i++)
		{
			feaVector[len][i] = 0;
		}

	}
	else
	{
		feaVector[len] = (int*) mxMalloc(temp * sizeof(int));
		for (int i = 0; i < temp; i++)
		{
			feaVector[len][i] = 0;
		}
	}
}
feature::~feature(void)
{
	if (size == 0)
	{
		return;

	}
	else
	{
		if (len == -1)
		{
			mxFree(feaVector);
		}
		else
		{
			for (int i = 0; i <= len; i++)
			{
				mxFree(feaVector[i]);
			}
			mxFree(feaVector);
		}
	}
}
unsigned long int feature::getLineSize()
{
	return power2(ndim, depth);
}
void feature::transaction(double*pp)
{
	int i, j, k;
	k = power2(ndim, depth);
	for (i = 0; i <= len; i++)
		for (j = 0; j < k; j++)
		{
			*(pp + k*i + j) = feaVector[i][j];
		}
}
int feature::getLen()
{
	return len + 1;
}

