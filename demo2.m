%% demonstrate the procedure of CGR
% author: Yang Li
% date: 12/8/2016

%% initialize the point
string = randsample('ACGT',5,true);
fprintf('\n The random string array is %s\n', string);
start_point = [0.5,0.5]; % fixed starting point
map = zeros(4,2);
map(2:3,:) = eye(2);
map(4,:) = 1;
t = 0.5; % contraction coefficient
drawArrow = @(x1,x2) quiver( x1(1),x1(2),x2(1)-x1(1),x2(2)-x1(2),0 );
point = ones(2,length(string));
point(:,1) = start_point;
for ii = 1:length(string)
    switch string(ii)
        case 'A'
            point(:,ii+1) = point(:,ii)*t + (1-t)*map(1,:)';
        case 'T'
            point(:,ii+1) = point(:,ii)*t + (1-t)*map(2,:)';
        case 'C'
            point(:,ii+1) = point(:,ii)*t + (1-t)*map(3,:)';
        case 'G'
            point(:,ii+1) = point(:,ii)*t + (1-t)*map(4,:)';
    end
    
    clf;axis([0,1,0,1]); axis square; hold on;
    boundary = t^(ii-1);
    for jj = 1:ii;
        pnt = point(:,ii-jj+1);    
        grid_rectangular (pnt(1) - boundary/2, pnt(1) +boundary/2, 3, ...
        pnt(2) - boundary/2, pnt(2)+boundary/2, 3 );
        new_boundary = boundary; 
        boundary = boundary/t;
    end
    fp = scatter(point(1,ii),point(2,ii));
    fp1 = scatter(point(1,ii+1),point(2,ii+1));
    fp2 = drawArrow(point(:,ii)',point(:,ii+1)');
    drawnow;
    pause(1);
    delete(fp);delete(fp1);delete(fp2);
end
scatter(point(1,:),point(2,:),'filled');
fprintf('\n point = (%d, %d) \n', point(:,end));
