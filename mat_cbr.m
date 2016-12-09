function [outputmat, veclabel] = mat_cbr(winLength,contr_coef,ndim, strmat)
%% matlab script to simulate the cbr behavior 
% author Yang
% date 12/9/2016
% INPUT 
%   winLength -- window length
%   contr_coef -- contract coefficient
%   strmat -- the matrix of string

%% allocate output matrix
strmat = cellfun(@strip,strmat,'UniformOutput',false);
len_vec = length(strmat{1});
vecsize = size(strmat,1)*(max(len_vec) - winLength + 1);
outputmat = ones(vecsize,ndim);
outputmat = outputmat./ndim;
veclabel = zeros(vecsize,1);
ind = 1;
for ii = 1:size(strmat,1)
    str = strmat{ii};
    for jj = 1:length(str) - winLength
        for kk = jj:jj+winLength
        	outputmat(ind,:) = outputmat(ind,:)*contr_coef + (1 - contr_coef) * char2num(str(kk));
        end
        veclabel(ind) = ii;
        ind = ind+1;      
    end
end
outputmat(veclabel == 0,:) = [];
end
function nn = char2num(chr)
	if (chr >= 'A' && chr <= 'Z') || (chr >= 'a' && chr <= 'z')
		switch upper(chr)
			case 'A'
                nn = [0,0];
				return;
			case 'T'
                nn = [0,1];
				return;
			case 'C'
                nn = [1,0];
				return;
			case 'G'
                nn = [1,1];
				return;		
			otherwise
				warning('Input format error')
		end
	end
end


