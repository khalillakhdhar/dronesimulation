% Initialization steps.  Brute force cleanup of everything currently existing to start with a clean slate.
clc;    % Clear the command window.
fprintf('Beginning to run %s.m ...\n', mfilename);
close all;  % Close all figures (except those of imtool.)
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
fontSize = 20;

numPoints = 15;
% Plot first dataset in red triangles.
x = rand(1, numPoints);
y = rand(1, numPoints);
subplot(2, 1, 1);
plot(x, y, 'rv-', 'LineWidth', 2, 'MarkerSize', 12);
grid on;
hold on;
% Plot second dataset in green triangles.
x = rand(1, numPoints);
y = rand(1, numPoints);
plot(x, y, 'gv-', 'LineWidth', 2, 'MarkerSize', 12);
title('Optimized UAV trajectories without power control.', 'FontSize', fontSize);
xlabel('x(m)', 'FontSize', fontSize);
ylabel('y(m)', 'FontSize', fontSize);
legend('red', 'green', 'Location', 'northwest');

% Plot lines in solid red, solid blue, and dashed green.
subplot(2, 1, 2); % Make another graph below the first one.
% Plot first dataset in solid red.
x = sort(rand(1, numPoints), 'ascend');
y = rand(1, numPoints);
plot(x, y, 'r-', 'LineWidth', 2, 'MarkerSize', 12);
grid on;
hold on;
% Plot second dataset in solid blue.
x = sort(rand(1, numPoints), 'ascend');
y = rand(1, numPoints);
plot(x, y, 'b-', 'LineWidth', 2, 'MarkerSize', 12);
% Plot third dataset in dashed green.
x = sort(rand(1, numPoints), 'ascend');
y = rand(1, numPoints);
darkGreen = [0, 0.5, 0]; % A custom color for example.
plot(x, y, '--', 'Color', darkGreen, 'LineWidth', 2, 'MarkerSize', 12);
legend('red', 'blue', 'green');
title('UAV transmit power versus time for a two-UAV system', 'FontSize', fontSize);
xlabel('Time t (s)', 'FontSize', fontSize);
ylabel('UAV Transmit Power (W)', 'FontSize', fontSize);
% Maximize figure
g = gcf;
g.WindowState = 'maximized';