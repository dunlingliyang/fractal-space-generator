function output = comp(inputStr1,inputStr2,winLength,contr_coef,ndim,nclusters,distanceType)
%% compute the distance matrix
% the first two input para are cells
% winLength is the scale para


if nargin < 3
    help comp;
    error('error in the input parameters');
end

if nargin >= 3
    str = union(inputStr1{2}{1},inputStr2{2}{1});
    str = strtrim(str);
    if ceil(log2(length(unique(str)))) > ndim;
        error('error in dimensiona set by user');
    end
end
if nargin < 4
    distanceType = 'plain';
end
% get cbr points in fractal space
% if in linux, change cbr to mat_cbr
[trai_data1,label1] = cbr(winLength,contr_coef,ndim, inputStr1{2});
[trai_data2,label2] = cbr(winLength,contr_coef,ndim, inputStr2{2});

% get tailored labels
label1 = label1-min(label1)+1;
label2 = label2-min(label2)+1;
% plot the fractal space
figure;
plot(trai_data1(:,1),trai_data1(:,2),'*');
title('The fractal space for training sequences');
figure;

plot(trai_data2(:,1),trai_data2(:,2),'g*');
hold on;
for ii = 1:20;
   text(trai_data2(ii,1),trai_data2(ii,2),inputStr1{2}{label1(ii)}(ii:ii+winLength),'FontSize',10,'Color','red');
end
% smoothing for training data samples
[idx,~] = litekmeans(vertcat(trai_data1,trai_data2),nclusters);
[trainData,testData] = preprocess(idx,label1,label2,trai_data1,trai_data2);
[trainData,testData] = calculateDis(trainData,testData,distanceType);
clear trai_data1 trai_data2
%prelocate the matrix
preMat = zeros(100,100);
params = cell(100,100,2);
ii = 1;
for c1 = 10
    jj = 0;
    for kp = [0.000001,0.0001,0.001,01,0.05,0.1,0.5,1,2,5,10];
        jj = jj+1;
        option = ['-s 0 -c ', num2str(c1),'-gamma', num2str(kp), ' -t 2 -q'];
        if strcmp(distanceType,'plain') ~= 1
            temp = size(trainData,1);
            trainData = [transpose(1:temp),trainData];
            temp = size(testData,1);
            testData = [transpose(1:temp),testData];
            option = ['-c ', num2str(c1), '-t 2 -q'];
        end
        % unitary
        trainData = zscore(trainData,0,2);
        testData = zscore(testData,0,2);
        % predict with svm
        model = svmtrain(double(inputStr1{1})+1,trainData,option);
        [~,acc,~] = svmpredict(double(inputStr2{1})+1,testData,model);
        preMat(ii,jj) = acc(1);
        params(ii,jj) = {[c1,kp]};
    end
    ii=ii+1;
end
[maxRow,rowInd] = max(preMat);
[maxAcc,lineInd] = max(maxRow);
rowInd = rowInd(lineInd);
output.maxAcc = maxAcc;
fprintf('the max acc is %f\n',maxAcc);
output.parameters = params(rowInd,lineInd);
end

