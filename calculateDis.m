function [output1,output2] = calculateDis(inputIns1,inputIns2,option)
%% calculate the distance bewteen pairwise instances
% status: working
% para: plain - without improvement, just stripe the core component
%         L-2   - calculate the L_2 distance
%         div   -divergence calculate the divergence based distance

if nargin < 3
    option = 'div';
end

if ~isstruct(inputIns1) && ~isstruct(inputIns2)
    error('input instance errors');
end

switch option
    case 'plain'
        output1 = inputIns1.clusters;
        output2 = inputIns2.clusters;
    case 'L-2'
        temp = size(inputIns1.clusters,1);
        temp2 = size(inputIns2.clusters,1);
        output1 = zeros(temp,temp);
        for ii = 1:temp
            for jj = 1:temp
                output1(ii,jj) = norm(inputIns1.clusters(ii,:)-inputIns1.clusters(jj,:));
                
            end
        end
        %temp = size(inputIns2.clusters,2);
        output2 = zeros(temp2,temp);
        for ii = 1:temp2
            for jj = 1:temp
                output2(ii,jj) = norm(inputIns2.clusters(ii,:)-inputIns1.clusters(jj,:));
            end
        end
    case 'div'
        clu1 = inputIns1.clusters;
        clu2 = inputIns2.clusters;
        woc1 = inputIns1.conditionalProb;
        woc2 = inputIns2.conditionalProb;
        [clu1,clu2,woc1,woc2] = usrSmooth(clu1,clu2,woc1,woc2);
        clu1 = clu1./repmat(sum(clu1,2),1,size(clu1,2));
        clu2 = clu2./repmat(sum(clu2,2),1,size(clu2,2));
        temp = size(clu1,1);
        output1 = zeros(temp,temp);
        for ii = 1:temp
            for jj = ii+1:temp
                try
                    output1(ii,jj) = sum(clu1(ii,:).*sum(log(woc1(ii,:)./woc1(jj,:))))+sum(clu1(ii,:).*sum(log(clu1(ii,:)./clu1(jj,:))));
                catch
                    keyboard();
                end
                output1(ii,jj) = output1(ii,jj) + sum(clu1(jj,:).*sum(log(woc1(ii,:)./woc1(jj,:))))+sum(clu1(jj,:).*sum(log(clu1(ii,:)./clu1(ii,:))));
            end
        end
        output1 = output1 + transpose(output1);
        temp = size(clu2,1);
        output2 = zeros(temp,temp);
        try
            for ii = 1:temp
                for jj = 1:size(woc1,1)
                    output2(ii,jj) = sum(clu2(ii,:).*sum(log(woc2(ii,:)./woc1(jj,:))))+sum(clu2(ii,:).*log(clu2(ii,:)./clu1(jj,:)));
                    output2(ii,jj) = output2(ii,jj) + sum(clu1(jj,:).*sum(log(woc1(jj,:)./woc2(ii,:))))+sum(clu1(jj,:).*sum(log(clu1(jj,:)./clu2(ii,:))));
                    
                end
            end
        catch errmsg
            disp(errmsg);
            keyboard();
        end
    case 'L-22'
        temp = size(inputIns1.clusters,1);
        temp2 = size(inputIns2.clusters,1);
        output1 = zeros(temp,temp);
        for ii = 1:temp
            for jj = 1:temp
                output1(ii,jj) = norm(inputIns1.conditionalProb(ii,:)-inputIns1.conditionalProb(jj,:));
                
            end
        end
        
        output2 = zeros(temp2,temp);
        for ii = 1:temp2
            for jj = 1:temp
                output2(ii,jj) = norm(inputIns2.conditionalProb(ii,:)-inputIns1.conditionalProb(jj,:));
            end
        end
    case 'Jeffrey'
        temp1 = size(inputIns1.clusters,1);
        temp2 = size(inputIns2.clusters,1);
        output1 = zeros(temp1,temp1);
        output2 = zeros(temp2,temp1);
        for ii = 1:temp1
            for jj = 1:temp2
                output1(ii,jj) = Jeffrey(inputIns1.clusters(ii,:),inputIns2.clusters(jj,:));
            end
        end
        for ii = 1:temp2
            for jj = 1:temp1
                output2(ii,jj) = Jeffrey(inputIns2.clusters(ii,:),inputIns1.clusters(jj,:));
            end
        end
        
end
end

function varargout = usrSmooth(varargin)
%% smooth the input parameters
% try different smoothing methods, no smoothing currently.
% status: deferred
% date: 4/14/2015
assert(nargin == nargout);
for ii = 1:nargin
    varargout{ii} = varargin{ii}+1;
end
end

function output = Jeffrey(varargin)
%% get the L-2 distance between points
varargin{1} = usrSmooth(varargin{1});
varargin{2} = usrSmooth(varargin{2});
assert(length(varargin{1}) == length(varargin{2}));
assert(all(varargin{1} >= 1e-5));
assert(all(varargin{2} >= 1e-5));
if abs(sum(varargin{1})-1)+abs(sum(varargin{2})) > 1e-5
    varargin{1} = varargin{1}./sum(varargin{1});
    varargin{2} = varargin{2}./sum(varargin{2});
end
output = sum(varargin{1}.*log(varargin{1}./varargin{2}) + varargin{2}.*log(varargin{2}./varargin{1}));
end


