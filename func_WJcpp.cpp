
/******************************************************
 * The original Eigen Library have not the function
 * A.sortAscending() and A.sortDescending(). 
 * Equivalent to use A = sort(A,'ascend') and A = sort(A,'descend'),
 * respectively, from MATLAB.
 *
 * Original Eigen Lib (default and working)
 * mex -I/usr/include/eigen3 func_WJcpp.cpp
 *
 * 
 * EigenDoBetter Lib (http://eigendobetter.com/)
 * mex -I/home/israel/Documents/EigenDoBetter func_WJcpp.cpp
 *
 * To acticve OpenMP (parallel processing)  ("Eigen::initParallel();")
 * mex -v CFLAGS='$CFLAGS -fopenmp' -I/usr/include/eigen3 func_WJcpp.cpp
 *
 * For some reason, I have a problem with svd and trabspose.
 *
 * So, I try use std::sort
 *
 *
 ******************************************************/

#include <iostream>
#include <cmath>
#include <algorithm>
#include <vector>
#include <utility>
#include <Eigen/Dense>
#include "mex.h"


using namespace Eigen;
using namespace std;

void pixel2ij(const uint n, const uint dim, uint *i, uint *j)
{
    uint m = n%dim;
    if (m==0)
    {
        *j = n/dim;
        *i = dim;
    }
    else
    {
        *j = n/dim +1;
        *i = m;
    }
}

bool myComparison(const pair<int,double> &a,const pair<int,double> &b)
{
       return a.second<b.second;
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{

//     Eigen::initParallel();
//     Eigen::setNbThreads(8);
//     cout << Eigen::nbThreads( )<<endl;
    //[W,J] = func_WJcpp(z2,zc,K,delta,Bloc_size) 

    //Load step:
    
    const mwSize *dim_z2, *dim_zc;
    dim_z2 = mxGetDimensions(prhs[0]);
    dim_zc = mxGetDimensions(prhs[1]);

    double *z2ptr, *zcptr;
    z2ptr = mxGetPr(prhs[0]);
    zcptr = mxGetPr(prhs[1]);
    
    const int K         = mxGetScalar(prhs[2]);
    const double delta  = mxGetScalar(prhs[3]);
    const int Bloc_size = mxGetScalar(prhs[4]);

    MatrixXd z2, zc;
    z2.resize(dim_z2[0],dim_z2[1]);
    z2 << Map<MatrixXd>(z2ptr, dim_z2[0], dim_z2[1]);
    zc.resize(dim_zc[0],dim_zc[1]);
    zc << Map<MatrixXd>(zcptr, dim_zc[0], dim_zc[1]);
    
    const int r = Bloc_size/2;
    
    MatrixXd pc, pz;
    pc.resize(2*r+1,2*r+1);
    pz.resize(2*r+1,2*r+1);
    
    const uint Nz = dim_z2[0]*dim_z2[1];
    const uint N = dim_zc[0]*dim_zc[1];    
    MatrixXd W(N,K);
    MatrixXi J(N,K);
   
       
    int ii, jj;
    uint i, n, si, sj, ic, jc, jk; 
                
    vector< pair<int,double> > D(Nz);
    for (i=0; i<N; i++){
        pixel2ij(i+1,dim_zc[0],&ic,&jc);
        si = 0;
        for (ii=ic-r; ii<=ic+r; ii++){
            sj=0;
            for (jj=jc-r; jj<=jc+r; jj++){
                if (((ii<=0)||(jj<=0))||((ii>dim_zc[0])||(jj>dim_zc[1])))
                    pc(si,sj) = 0;
                else
                    pc(si,sj) = zc(ii-1,jj-1);
                sj=sj+1;
            }
            si=si+1;
        }


        for (n=0; n<Nz; n++){
            pixel2ij(n+1,dim_z2[0],&ic,&jc);
            si = 0;
            for (ii=ic-r; ii<=ic+r; ii++){
                sj=0;
                for (jj=jc-r; jj<=jc+r; jj++){
                    if (((ii<=0)||(jj<=0))||((ii>dim_z2[0])||(jj>dim_z2[1])))
                        pz(si,sj) = 0;
                    else
                        pz(si,sj) = z2(ii-1,jj-1);
                    sj=sj+1;
                }
                si=si+1;
            }
            D[n].first = n+1;     
            D[n].second = (pc-pz).norm();
        } 
        
         sort(D.begin(), D.end(), myComparison);

         for (jk=0; jk<K; jk++){
             J(i,jk) = D[jk].first;
             
            pixel2ij(J(i,jk),dim_z2[0],&ic,&jc);
            si = 0;
            for (ii=ic-r; ii<=ic+r; ii++){
                sj=0;
                for (jj=jc-r; jj<=jc+r; jj++){
                    if (((ii<=0)||(jj<=0))||((ii>dim_z2[0])||(jj>dim_z2[1])))
                        pc(si,sj) = 0;
                    else
                        pc(si,sj) = z2(ii-1,jj-1);
                    sj=sj+1;
                }
                si=si+1;
            }

            pixel2ij(jk+1,dim_z2[0],&ic,&jc);
            si = 0;
            for (ii=ic-r; ii<=ic+r; ii++){
                sj=0;
                for (jj=jc-r; jj<=jc+r; jj++){
                    if (((ii<=0)||(jj<=0))||((ii>dim_z2[0])||(jj>dim_z2[1])))
                        pz(si,sj) = 0;
                    else
                        pz(si,sj) = z2(ii-1,jj-1);
                    sj=sj+1;
                }
                si=si+1;
            }               
            

             W(i,jk) = exp(-delta*(pc-pz).squaredNorm());
         }
        
    }
    
  plhs[0] = mxCreateNumericMatrix(N, K, mxDOUBLE_CLASS, mxREAL);
  double *Out0 = mxGetPr(plhs[0]);
  MatrixXd::Map(Out0, N, K) = W;

  MatrixXd Jd(N,K);
  Jd = J.cast<double>();
  plhs[1] = mxCreateNumericMatrix(N, K, mxDOUBLE_CLASS, mxREAL);
  double *Out1 = mxGetPr(plhs[1]);
  MatrixXd::Map(Out1, N, K) = Jd;
  
}



//EOF