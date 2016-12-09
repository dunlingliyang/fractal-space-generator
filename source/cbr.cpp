#include "mex.h"
#include "matrix.h"
#include<cstdio>
#include<cstring>
#include "string.h"
#include"head.h"
#define MAXSIZE 1024

//usage:feature = feaGen( training,depth,ndim);
//state:finishing
//version:v1
//notation: maximum size of buffer is 1024
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, mxArray * prhs[])
{
	// check the input parameter
	if (nlhs != 1)
		mexErrMsgTxt(" error in using feaGen, one output is needed");
	if (nrhs != 3)
		mexErrMsgTxt(" error in using feaGen, three input are needed");
	if (!mxIsCell(prhs[0]))
	{
		mexErrMsgTxt(" input type error");
	}

	mxArray * pp, *ptemp;
	mwSize M;
	mwSize depth, ndim;
	int i, j, k, m, n, intTemp;
	double *pointer;

	//get parameter
	depth = mxGetScalar(prhs[1]);
	ndim = mxGetScalar(prhs[2]);
	M = mxGetM(prhs[0]);
	//alloc the space

	char *buf = (char*) mxMalloc((unsigned int) (MAXSIZE) * sizeof(char));

	char ** fea;
	fea = (char**) mxMalloc((unsigned int) ndim * sizeof(char*));
	for (i = 0; i < ndim; i++)
	{
		fea[i] = (char*) mxMalloc((unsigned int) (MAXSIZE) * sizeof(char));
	}

	feature fv(ndim, depth, M);

	for (i = 0; i < M; i++)
	{
		fv.addLine();
		ptemp = mxGetCell(prhs[0], i);
		if (mxGetString(ptemp, buf, (unsigned int) MAXSIZE))
			mexErrMsgTxt("error in the buffer of this function:line53");
#ifdef debug
		mexPrintf("%s",buf);
#endif
		for (j = 0; buf[j] != '\0'; j++)
		{
			intTemp = char2num(buf[j]);
			for (int l = 0; l < ndim; l++)
			{

				fea[l][j] = (int)(intTemp & 0x1) + '0';
				intTemp >>= 1;
			}
		}

		int len = j;
#ifdef debug
		mexPrintf("%s",len);
#endif
		char *temp;
		temp = (char*) mxMalloc((ndim * depth + 1) * sizeof(char));
		for (j = 0; j <= len - depth; j++)
		{
			intTemp = 0;
			int mm, nn;
			for (nn = 0; nn < ndim; nn++)
			{
				for (mm = 0; mm < depth; mm++)
				{
					temp[intTemp++] = fea[nn][mm + j];
				}
			}
			*(temp + ndim * depth) = '\0';
			intTemp = ndim * depth;
			int index = to2num(temp, intTemp);
			if( index < 0 || index > power2(ndim,depth))
			{
				mexErrMsgTxt("error in input format line:90");
			}
			fv.store(index);
		}
		mxFree(temp);

	}

	mxFree(buf);
	for (i = 0; i < ndim; i++)
	{
		mxFree(fea[i]);
	}
	mxFree(fea);

	int lineSize = fv.getLineSize();
	plhs[0] = mxCreateDoubleMatrix(fv.getLen(), lineSize, mxREAL);
	pointer = mxGetPr(plhs[0]);
	fv.transaction(pointer);

}

