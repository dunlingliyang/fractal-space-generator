#include"mex.h"
#include<stdlib.h>
#include<math.h>
#include"matrix.h"
void cbr(point &point,int winLen,int nchar,double *str)
//map an string to a series of points
{
    int i,j,m,temp,k;
    static int L_num=0;
    double contr_coef = 1.0/nchar;
    // count the # of the chars in a string
    for(i=0;(int)str[i]!=-1;i++);
    k = i - winLen + 1;
    //mexPrintf("the value of k is %d \n", k);
    double nn;
    //for(i=0;i<dim;i++)
    //   n[i]=0.5;
    for(i=0;i<k;i++)
    {
        nn = 0.5;
        for(j=i;j<i+winLen;j++)
        {
            temp=int(str[j]);          
            nn=contr_coef*nn+temp*contr_coef;
            //mexPrintf("one value is added into depository \n");
        }
        point.store(nn,L_num);
    }
    L_num++;                    
}

void mexFunction(int nlhs,mxArray* plhs[],int nrhs,const mxArray* prhs[])
{
    //check the parameter of this program
    if(nrhs!=3)
        mexErrMsgTxt("error in using this function");
    if(nlhs!=2)
        mexErrMsgTxt("error in output parameter");
    //create some parameter for the cbr
    int winLen,nchar;
    double contr_coef;    
    //get the para.
    if(!mxIsScalar(prhs[0]))
    {
        mexErrMsgTxt("the first argument is winlenth");
    }
    if(!mxIsScalar(prhs[2]))
    {
        mexErrMsgTxt("the third argument is # of chars");
    }
    winLen=(int)mxGetScalar(prhs[0]);
    nchar=(int)mxGetScalar(prhs[2]);
    if(!mxIsCell(prhs[1]))
    {
        mexErrMsgTxt("the second argument should be cell formate");
    }
    double str[5000];//the line of each string
    //get some control information for the program
    int i;// counter of iteration
    int ninstance = (int)mxGetM(prhs[1]);
    //plhs=mxCreateDoubleMatrix(0,0,mxREAL);
    // p_out=mxGetPr(plhs);
    mexPrintf("Begin transforming symbolic sequences to points \n");
    mexPrintf(" The # of instance is %i \n",ninstance);
    point pp(100);
    
    for(i=0;i<ninstance;i++)
    {
        mxArray *p=mxGetCell(prhs[1],i);//get the content of a cell
        if(p == NULL)
        {
            mexErrMsgTxt(" NULL pointer, error");
        }
        if(!mxIsDouble(p))
        {
            mexErrMsgTxt("wrong formation of input");
        }
        double * pr = mxGetPr(p);// get the point to the double array
        int seqLen = mxGetNumberOfElements(p);
        if (seqLen > 5000)
        {
            mexErrMsgTxt(" the sequence is too long to process, please allocate a larger vector");
        }
        for(int j=0;j<seqLen;j++)
        {
            *(str+j) = *(pr+j);
        }
        str[seqLen] = -1;
        cbr(pp,winLen,nchar,str);
        //mexPrintf("i is %d count number is %d\n",i,point_usr.getlen());
    }
    
    plhs[0]=mxCreateDoubleMatrix(pp.getlen(),1,mxREAL);
    plhs[1]=mxCreateDoubleMatrix(pp.getlen(),1,mxREAL);

    pp.parse(plhs[0],plhs[1]);

    
}