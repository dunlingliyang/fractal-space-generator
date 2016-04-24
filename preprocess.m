function [output1,output2] = preprocess(idx,label1,label2,positions1,positions2,nsymbols)
%% preprocess the data and give estimation for the points
% status: finished
% date: 4/14/2014
% input para: idx is the id allocated to each point.
%           : label1 and label2 are both for the points.
%           : positions1 and positions2 are the real computed positions for
%           points.
% output para: clusters is the cluster info. it contains the # clusters for
% each string
%            : conditionalProb is the conditional probabilities. it
%            contains the # symbols for each clusters

if nargin < 6
    nsymbols = 4;
end
nclusters = max(idx);

output1.clusters = zeros(max(label1),nclusters);
output2.clusters = zeros(max(label2),nclusters);
idx1 = idx(1:length(label1));
idx2 = idx(end - length(label2) + 1:end);
for kk = 1:max(label1)
    temp = idx1(label1 == kk);
    output1.clusters(kk,:) = histc(temp,1:nclusters);
end

for kk = 1:max(label2)
    temp = idx2(label2 == kk);
    output2.clusters(kk,:) = histc(temp,1:nclusters);
end
%% get estimation for the conditional probabilities based on strings
% output1.words = zeros(max(label1),nsymbols);
% output2.words = zeros(max(label2),nsymbols);
% for ii = 1:max(label1)
%     pos1 = positions1(label1 == ii,:);
%     output1.words(ii,:) = calWords(pos1,nsymbols);
% end
% for ii = 1:max(label2)
%     pos2 = positions2(label2 == ii,:);
%     output2.words(ii,:) = calWords(pos2,nsymbols);
% end
%% get estimation for the conditional probabilities based on clusters
for ii = 1:max(label1)
    pos1 = positions1(label1 == ii,:);
    output1.conditionalProb(:,ii) = calWords(pos1,nsymbols);
end

for ii = 1:max(label2)
    pos2 = positions2(label2 == ii,:);
    output2.conditionalProb(:,ii) = calWords(pos2,nsymbols);
end

output1.conditionalProb = output1.conditionalProb./repmat(sum(output1.conditionalProb),size(output1.conditionalProb,1),1);
output2.conditionalProb = output2.conditionalProb./repmat(sum(output2.conditionalProb),size(output2.conditionalProb,1),1);
output1.conditionalProb = transpose(output1.conditionalProb);
output2.conditionalProb = transpose(output2.conditionalProb);
end

function output = calWords(positions,nsymbols)
%% get each word counts for each cluster
if nargin < 2
    nsymbols = 4;
end
centerP = (max(positions) + min(positions))./2;
output = zeros(1,nsymbols);
output(1) = sum(positions(:,1) > centerP(:,1) & positions(:,2) > centerP(:,2));
output(2) = sum(positions(:,1) > centerP(:,1) & positions(:,2) < centerP(:,2));
output(3) = sum(positions(:,1) < centerP(:,1) & positions(:,2) > centerP(:,2));
output(4) = sum(positions(:,1) < centerP(:,1) & positions(:,2) < centerP(:,2));
end

