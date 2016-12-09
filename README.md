# README

## USAGE

This is the demonstration of mapping function to fractal space. Under windows x64, an easy way is to run `demo` in the current folder, the results show the constructed fractal space. `demo2` demonstrates how the point moves given a short randomly generated symbolic segment. A preprocessed[^footnote] data set is also included *for demonstration purpose only*. The date set was originally obtained from [UCI machine learning repository](http://archive.ics.uci.edu/ml/datasets/Molecular+Biology+%28Promoter+Gene+Sequences%29).

This folder also contains a copy of Support Vector Machine for usage in the classification under windows x64 [ref](http://www.csie.ntu.edu.tw/~cjlin/libsvm/).

## COMPILE
The main procedure of mapping function is carried out in the mex file `cbr.cpp`. To compile it under different platform, run:

An cbr.wexw64 has been included for platform Window x64. 

## NOTICE
Due to a disk disaster, the original head files for `cbr.cpp` were lost. I implements the `cbr.cpp` in Matlab which does sacrifice the efficiency for readability. The files contained in the `source` folder are obsolete files for `cbr` for anyone who are interested in peering into the details and also for me to deposit them in a safer place. 

##CONTACT
This copy of code comes as it is. Any comments or suggestions are welcome. (csly#mail.ustc.edu.cn, replace # with @).

##LICENSE
This code files are distributed under [GNU General Public License.](https://www.gnu.org/copyleft/gpl.html)
