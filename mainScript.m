
clear; close all;
load ./datasets/promoters.mat;
addpath('./svm');
data_len = size(data,1);
rng(5);
cs_perm = 5;
ntimes = 50;
saveAcc = zeros(5*ntimes,3);
[training_id,testing_id] = dividerand(data_len,0.8,0.2);
data1 = {data_label(training_id),data(training_id,:)};
data2 = {data_label(testing_id),data(testing_id,:)};
% set the global parameters
contr_coef = 0.5;
ndim = 2;
nsymbols = 4;
nclusters = 16;
winLength = 20;
distanceType = 'plain'; %Jeffrey, L-2, L-22, plain, div
maximum_accuracy = -inf;

output = comp(data1,data2,winLength, contr_coef,ndim,nclusters,distanceType);
maxAcc = output.maxAcc;
if isempty(maxAcc) || output.maxAcc >= maxAcc
    maxAcc = output.maxAcc;
    c1 = output.parameters{:}(1);
    kp = output.parameters{:}(2);
end

if ~isempty(maxAcc) && maxAcc > maximum_accuracy
    maximum_accuracy = maxAcc(1);
end

fprintf('The maxacc is %f, and the parameters is %f and %f\n', maximum_accuracy,c1,kp);
disp('++++++++++++++++++++++++++++++++++++++++');



