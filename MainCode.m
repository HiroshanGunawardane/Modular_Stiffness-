%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script Name: MainCode.m
% Data File: OverLap.mat
% Date:  202-07-09
% Authour: P.D.S.H. Gunawardane 
% Manuscript Title: Modular Stiffness Modulation in 3D-Printed Soft 
% Actuators for Adaptive Trajectory Control
%
% Description:
% This script processes experimental trajectory data from a Zig-zag Soft 
% Actuator to analyze deformation patterns, compute curvature (k), and 
% evaluate variability using Root Mean Square Deviation (RMSD). The data 
% includes two types of material configurations:
%   - Dragon Skin Only
%   - Dragon Skin + Ecoflex
%
% The analysis includes:
%   - Loading x-y trajectory data from multiple configurations.
%   - Computing curvature for each trajectory.
%   - Classifying trajectories based on Y-axis side (positive/negative).
%   - Assigning material labels per configuration.
%   - Computing RMSD values within each side group using a reference.
%   - Visualizing:
%       * All trajectories colored by material type.
%       * RMSD per configuration, separated by side and marked by material.
%       * Histogram comparison of curvature distributions by material.
%   - Performing statistical t-tests to evaluate:
%       * RMSD difference between materials.
%       * RMSD difference between Y-sides


clc
clear
close all 

% Load data
data = load('OverLapMat.mat');
config = data.config;
numConfigs = length(config);

% Initialize storage
RMSD = zeros(numConfigs, 1);
sideLabel = strings(numConfigs, 1);
materialLabel = strings(numConfigs, 1);
curvature_all = cell(numConfigs, 1);

% Separate positive and negative Y trajectories
posY_traj = {};
negY_traj = {};

% Collect x, y data and compute curvature per configuration
for i = 1:numConfigs
    xVal = config(i).x(:); % Ensure column vector
    yVal = config(i).y(:);

    % Compute curvature for current trajectory
    curvature_all{i} = compute_curvature(xVal, yVal);

    % Determine side based on mean y-value
    if mean(yVal) >= 0
        posY_traj{end+1} = [xVal, yVal];
        sideLabel(i) = "pos";
    else
        negY_traj{end+1} = [xVal, yVal];
        sideLabel(i) = "neg";
    end

    % Determine material group based on index
    if i <= 26
        materialLabel(i) = "DragonSkinOnly";
    else
        materialLabel(i) = "DragonSkin_Ecoflex";
    end
end

% @@@ Compute RMSD for Positive Side @@@
[pos_rmsd_vals] = get_side_rmsd(posY_traj);
pos_idx = find(sideLabel == "pos");
RMSD(pos_idx) = pos_rmsd_vals;

% @@@ Compute RMSD for Negative Side @@@
[neg_rmsd_vals] = get_side_rmsd(negY_traj);
neg_idx = find(sideLabel == "neg");
RMSD(neg_idx) = neg_rmsd_vals;

% @@@ Plot Trajs @@@
figure(1)
hold on
for i = 1:numConfigs
    xVal = config(i).x;
    yVal = config(i).y;

    if i <= 26
        scatter(xVal, yVal, 'o', 'MarkerEdgeColor', 'k', 'LineWidth', 1.5);
    else
        scatter(xVal, yVal, 'o', 'MarkerEdgeColor', 'r', 'LineWidth', 1.5);
    end
end

% @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
hBlack = scatter(nan, nan, 'o', 'MarkerEdgeColor', 'k', 'LineWidth', 1.5);
hRed = scatter(nan, nan, 'o', 'MarkerEdgeColor', 'r', 'LineWidth', 1.5);

xlabel('X Displacement: mm', 'fontweight', 'bold', 'fontsize', 13, 'FontName', 'Times New Roman');
ylabel('Y Displacement: mm', 'fontweight', 'bold', 'fontsize', 13, 'FontName', 'Times New Roman');
title('Trajectory of the SPA (Experimental)', 'fontweight', 'bold', 'fontsize', 13, 'FontName', 'Times New Roman');
legend([hBlack, hRed], {'Dragon Skin Only', 'Dragon Skin + Ecoflex'}, 'fontsize', 11, 'FontName', 'Times New Roman');

xlim([-85 50])
ylim([-120 120])
hold off

% @@@ Combined RMSD Bar Plot with Symbols on Top @@@
figure(2)
hold on

for i = 1:numConfigs
    % Set face color based on side
    if sideLabel(i) == "pos"
        faceColor = [0 0.5 0.8]; % blue
    else
        faceColor = [0.85 0.33 0.1]; % orange
    end

    % Plot bar without edge color
    bar(i, RMSD(i), 'FaceColor', faceColor, 'EdgeColor', 'none');

    % Add material symbol on top with small gap
    xBar = i;
    yBar = RMSD(i) + 1.8;  % Small gap between symbol and bar top

    if materialLabel(i) == "DragonSkinOnly"
        plot(xBar, yBar, 'ks', 'MarkerFaceColor', 'k', 'MarkerSize', 6); % black square
    else
        plot(xBar, yBar, 'r^', 'MarkerFaceColor', 'r', 'MarkerSize', 6); % red triangle
    end
end

% Dummy graphics for legend
hPos = bar(nan, nan, 'FaceColor', [0 0.5 0.8], 'DisplayName', 'Positive Y Side');
hNeg = bar(nan, nan, 'FaceColor', [0.85 0.33 0.1], 'DisplayName', 'Negative Y Side');
hDS = plot(nan, nan, 'ks', 'MarkerFaceColor', 'k', 'DisplayName', 'Dragon Skin Only');
hDSEF = plot(nan, nan, 'r^', 'MarkerFaceColor', 'r', 'DisplayName', 'Dragon Skin + Ecoflex');

xlabel('Configuration Index', 'FontWeight', 'bold', 'FontSize', 12, 'FontName', 'Times New Roman')
ylabel('RMSD (mm)', 'FontWeight', 'bold', 'FontSize', 12, 'FontName', 'Times New Roman')
title('RMSD of All Configurations by Side and Material (Experimental)', 'FontWeight', 'bold', 'FontSize', 13, 'FontName', 'Times New Roman')
legend([hPos, hNeg, hDS, hDSEF], 'Location', 'northwest', 'FontSize', 11)
grid off
hold off

% === Compare Curvature Distributions ===
curv_DS = vertcat(curvature_all{1:26});      % Dragon Skin Only
curv_DS_EF = vertcat(curvature_all{27:end}); % Dragon Skin + Ecoflex

figure(3)
hold on
histogram(curv_DS, 'Normalization', 'probability', 'FaceColor', 'k', 'FaceAlpha', 0.5, 'DisplayName', 'Dragon Skin Only');
histogram(curv_DS_EF, 'Normalization', 'probability', 'FaceColor', 'r', 'FaceAlpha', 0.5, 'DisplayName', 'Dragon Skin + Ecoflex');

xlabel('Curvature (1/mm)', 'FontWeight', 'bold', 'FontSize', 13, 'FontName', 'Times New Roman');
ylabel('Probability', 'FontWeight', 'bold', 'FontSize', 13, 'FontName', 'Times New Roman');
title('Curvature Distribution Comparison (Experimental)', 'FontWeight', 'bold', 'FontSize', 14, 'FontName', 'Times New Roman');
legend('Location', 'northeast', 'FontSize', 11);
grid off
hold off

% @@@ Statistical Tests @@@

% Compare RMSD between materials
rmsd_DSOnly = RMSD(materialLabel == "DragonSkinOnly");
rmsd_DS_EF = RMSD(materialLabel == "DragonSkin_Ecoflex");
[h_mat, p_mat] = ttest2(rmsd_DSOnly, rmsd_DS_EF);

% Compare RMSD between sides
rmsd_pos = RMSD(sideLabel == "pos");
rmsd_neg = RMSD(sideLabel == "neg");
[h_side, p_side] = ttest2(rmsd_pos, rmsd_neg);

% t-test results
fprintf('\nT-test Results:\n');
fprintf('---------------------------\n');
fprintf('Material groups (Dragon Skin Only vs Dragon Skin + Ecoflex): p = %.4f\n', p_mat);
if h_mat == 1
    fprintf('-> Significant difference in RMSD between materials.\n');
else
    fprintf('-> No significant difference in RMSD between materials.\n');
end
fprintf('\n');
fprintf('Sides (Positive Y vs Negative Y): p = %.4f\n', p_side);
if h_side == 1
    fprintf('-> Significant difference in RMSD between sides.\n');
else
    fprintf('-> No significant difference in RMSD between sides.\n');
end

% @@@ Compute curvature @@@
function curvature = compute_curvature(x, y)
    dx = gradient(x);
    dy = gradient(y);
    ddx = gradient(dx);
    ddy = gradient(dy);
    curvature = abs(dx .* ddy - dy .* ddx) ./ (dx.^2 + dy.^2).^(3/2);
    curvature(~isfinite(curvature)) = 0;
end

% @@@ Compute RMSD for one side @@@
function rmsd_vals = get_side_rmsd(traj_list)
    num = length(traj_list);
    lengths = cellfun(@(t) size(t, 1), traj_list);
    [~, minIdx] = min(lengths);
    refTraj = traj_list{minIdx};

    rmsd_vals = zeros(num, 1);
    for j = 1:num
        currTraj = traj_list{j};
        minLen = min(size(refTraj,1), size(currTraj,1));
        rmsd_vals(j) = sqrt(mean(sum((currTraj(1:minLen,:) - refTraj(1:minLen,:)).^2, 2)));
    end
end
