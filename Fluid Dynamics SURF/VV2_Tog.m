datasets = {'/Users/josephpieper/SURF Project 2024/aug 08/50(hole)Hz resultsfromcode', '/Users/josephpieper/SURF Project 2024/aug 08/50(membrane)Hz resultsfromcode'};
labels = {'50(hole)Hz', '50(membrane)Hz'};
colors = {'#0072BD', '#D95319', '#77AC30'}; 

vv_square_mean_all = cell(1, 2);
vv_mean_squared_all = cell(1, 2);
y_values_all = cell(1, 2);

for j = 1:2
    
    % Remember / on Mac.
    path_analyzed = datasets{j};
    case_name = labels{j}; 
    dataname = strcat(path_analyzed, '/', case_name, 'phase'); 
    disp(dataname)

    frameR = 1000;

    resultname_U = [dataname ' U.dat'];
    resultname_V = [dataname ' V.dat'];
    resultname_x = [dataname ' X.dat'];
    resultname_y = [dataname ' Y.dat'];

    % Data loading.
    x = load(resultname_x);
    y = load(resultname_y);
    x = fliplr(x);
    y = fliplr(y);
    u = load(resultname_U);
    v = load(resultname_V);

    % shaping Data.
    L = size(v, 1);
    actF = 50;
    vv = reshape(v, [L, size(v, 2)/(floor(frameR/actF)), floor(frameR/actF)]);

    vv_square_mean = mean(vv.^2, 3);                   
    vv_mean_squared = (mean(vv, 3)).^2;

    vv_square_mean_vec = zeros(1, length(y));
    vv_mean_squared_vec = zeros(1, length(y));

    for ypos_i = 1:length(y)
        ypos_i_flipped = length(y) - ypos_i + 1;
        
        vv_square_mean_ypos_i = vv_square_mean(:, ypos_i_flipped);
        vv_square_mean_vec(ypos_i) = max(vv_square_mean_ypos_i);
        
        vv_mean_squared_ypos_i = vv_mean_squared(:, ypos_i_flipped);
        vv_mean_squared_vec(ypos_i) = max(vv_mean_squared_ypos_i);
    end

    vv_square_mean_all{j} = vv_square_mean_vec;
    vv_mean_squared_all{j} = vv_mean_squared_vec;
    y_values_all{j} = y;

end

hold on;

for j = 1:2

    if j == 2
        lineStyle = '--';
    else
        lineStyle = '-';  
    end

    % All
    plot(y_values_all{j}, vv_square_mean_all{j}, lineStyle, 'DisplayName', strcat(labels{j}, ': {VV^2}'), 'LineWidth', 2, 'Color', colors{1});
    % Mean
    plot(y_values_all{j}, vv_mean_squared_all{j}, lineStyle, 'DisplayName', strcat(labels{j}, ': Mean part of {VV^2}'), 'LineWidth', 2, 'Color', colors{2});
    % Oscillation
    plot(y_values_all{j}, vv_square_mean_all{j} - vv_mean_squared_all{j}, lineStyle, 'DisplayName', strcat(labels{j}, ': Oscillatory part of {VV^2}'), 'LineWidth', 2, 'Color', colors{3});
end

set(gcf, 'units', 'centimeters', 'position', [2, 2, 24, 12]);
xlabel('y [mm]');
ylabel('{[mm^2/s^2]}');
title('Mean and Components of VV2 For 50Hz (membrane) and 50Hz (hole)');
legend('show', 'Location', 'northeast', 'Box', 'off');
hold off;