frequencies = [20, 30, 40, 50, 60]; %actF

% y grid position above bubble.
y_pos_beginning = 4;

% All phases.
phases = 1:20;

results_y_L0 = cell(length(frequencies), 1);
results_Vcl_V0_max = cell(length(frequencies), 1);

for freq_idx = 1:length(frequencies)
    
    actF = frequencies(freq_idx);
    frameR = actF * 20;

    % File finder.
    case_name = sprintf('%d(hole)Hz', actF); 
    path_analyzed = fullfile('/Users/josephpieper/SURF Project 2024/aug 30', [num2str(actF) '(hole)Hz resultsfromcode']);
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

    % Reshaper.
    L = size(v, 1);
    num_frames = floor(frameR / actF);
    vv = reshape(v, [L, size(v, 2) / num_frames, num_frames]);

    number_grid_points_x = length(x);
    number_grid_points_y = length(y);
    number_phases = size(vv, 3);

    y_pos_beginning_flipped = number_grid_points_y - y_pos_beginning + 1;

    vv_discharge = zeros(number_phases, number_grid_points_x);

    for i = 1:number_phases
        index = phases(i);
        vv_discharge(i, :) = vv(:, y_pos_beginning_flipped, index);
    end

    max_values = max(vv_discharge, [], 2);  
    [~, sorted_indices] = sort(max_values, 'descend');  

    % Top 5 curves.
    top_indices = sorted_indices(1:min(5, end)); 
    vv_top = vv_discharge(top_indices, :);  

    % Average of top curves.
    v0 = mean(vv_top, 1);

    v0_max = max(v0);

    L0 = v0_max / actuationf;

    Vcl = zeros(1, number_grid_points_y);

    for ypos_i = 1:number_grid_points_y
        ypos_i_flipped = number_grid_points_y - ypos_i + 1;

        vv_mean_ypos_i = mean(vv(:, ypos_i_flipped, :), 3)';

        [Vcl_max_ypos_i, ~] = max(vv_mean_ypos_i);

        Vcl(ypos_i) = Vcl_max_ypos_i;
    end

    ratio_y_L0 = y / L0; 
    ratio_Vcl_V0_max = Vcl / v0_max; 

    results_y_L0{freq_idx} = ratio_y_L0(y_pos_beginning:end);
    results_Vcl_V0_max{freq_idx} = ratio_Vcl_V0_max(y_pos_beginning:end);

end
figure('visible', 'on');
hold on;

colors = lines(length(frequencies));
for freq_idx = 1:length(frequencies)
        plot(results_y_L0{freq_idx}, results_Vcl_V0_max{freq_idx}, 'DisplayName', sprintf('%d(hole)', frequencies(freq_idx)), 'LineWidth', 1.5);
end

ylabel('{V_{cl}/V_0} [-]');
xlabel('{y/L_0} [-]');
title('Non Dimensionalized {V_{cl}} at Different Frequencies');
legend show;
grid on;
set(gcf, 'units', 'centimeters', 'position', [2, 2, 14, 12]);
hold off;