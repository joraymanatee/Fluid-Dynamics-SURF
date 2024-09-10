frequencies = [20, 30, 40, 50, 60]; 

% Diameter.
D0 = 8;

% y grid position above bubble.
y_pos_beginning = 4;

pos_vv_discharge = 1:20;

results_y_D0 = cell(length(frequencies), 1);
results_Vcl_V0_max = cell(length(frequencies), 1);

% Looper.
for freq_idx = 1:length(frequencies)
    % Current frequency.
    actF = frequencies(freq_idx);
    frameR = actF * 20;

    % Names of files.
    case_name = sprintf('%d(hole)Hz', actF);
    path_analyzed = fullfile('/Users/josephpieper/SURF Project 2024/aug 30/', [num2str(actF) '(hole)Hz resultsfromcode']);
    dataname = strcat(path_analyzed, '/', case_name, 'phase');
    
   
    resultname_U = [dataname ' U.dat'];
    resultname_V = [dataname ' V.dat'];
    resultname_x = [dataname ' X.dat'];
    resultname_y = [dataname ' Y.dat'];
    
    x = load(resultname_x);
    y = load(resultname_y);
    x = fliplr(x);
    y = fliplr(y);

    u = load(resultname_U);
    v = load(resultname_V);

    L = size(v, 1);
    vv = reshape(v, [L, size(v, 2) / (floor(frameR / actF)), floor(frameR / actF)]);

    number_grid_points_x = length(x);
    number_grid_points_y = length(y);
    number_phases = size(vv, 3);

    y_pos_beginning_flipped = number_grid_points_y - y_pos_beginning + 1;

    vv_discharge = zeros(number_phases, number_grid_points_x);
    for i = 1:number_phases
        index = pos_vv_discharge(i);
        vv_discharge(i, :) = vv(:, y_pos_beginning_flipped, index);
    end

    max_values = max(vv_discharge, [], 2);  
    [~, sorted_indices] = sort(max_values, 'descend');  

    top_indices = sorted_indices(1:min(5, end));
    vv_top = vv_discharge(top_indices, :); 

    v0 = mean(vv_top, 1);  

    v0_max = max(v0);

    Vcl = zeros(1, number_grid_points_y);

    for ypos_i = 1:number_grid_points_y
        ypos_i_flipped = number_grid_points_y - ypos_i + 1;

        vv_mean_ypos_i = mean(vv(:, ypos_i_flipped, :), 3)';

        [Vcl_max_ypos_i, ~] = max(vv_mean_ypos_i);

        Vcl(ypos_i) = Vcl_max_ypos_i;
    end

    ratio_y_D0 = y / D0; 
    ratio_Vcl_V0_max = Vcl / v0_max;

    results_y_D0{freq_idx} = ratio_y_D0(y_pos_beginning:end);
    results_Vcl_V0_max{freq_idx} = ratio_Vcl_V0_max(y_pos_beginning:end);
end

figure('visible', 'on');
hold on;

colors = lines(length(frequencies));
for freq_idx = 1:length(frequencies)
    plot(results_y_D0{freq_idx}, results_Vcl_V0_max{freq_idx}, 'DisplayName', sprintf('%d Hz', frequencies(freq_idx)), 'LineWidth', 1.5);
end

ylabel('{V_{cl}/V_0} [-]');
xlabel('{y/D_0} [-]');
title('Non Dimensionalized {V_{cl}} at Different Frequencies');
legend show;
grid on;
set(gcf, 'units', 'centimeters', 'position', [2, 2, 14, 12]);
hold off;