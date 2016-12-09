function [] = plot_figure(point, ind)
%% plot the figure according to the current point
% INPUT
% point -- current point
% ind -- the iteration index

if ind == 0
    close all;
    figure;
    scatter(point,'s',Marksize, 3);
    axis([0,1,0,1]);
    axis square
    grid_rectangular ( 0.0, 1.0, 3, 0.0, 1.0, 3 )
else
    clf;
    axis([0,1,0,1]);
    axis square
    grid_rectangular ( 0.0, 1.0, 3, 0.0, 1.0, 3 );
    
end