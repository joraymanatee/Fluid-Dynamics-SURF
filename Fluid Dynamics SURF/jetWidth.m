frequencies = [20, 30, 40, 50, 60];
num_frequencies = length(frequencies); 

colors = {'#0072BD', '#D95319', '#77AC30', '#7E2F8E', '#A21441'};
labels = {'20(hole)', '30(hole)', '40(hole)' '50(hole)', '60(hole)'}; 

jet_widths = cell(num_frequencies, 1);
y_positions = cell(num_frequencies, 1);

for freq_idx = 1:num_frequencies
    actF = frequencies(freq_idx); 
    frameR = 20 * actF;
    path_analyzed = sprintf('/Users/josephpieper/SURF Project 2024/aug 30/%d(hole)Hz resultsfromcode', actF);
    case_name = sprintf('%d(hole)Hz', actF); 
    dataname = strcat(path_analyzed, '/', case_name, 'phase'); 

    resultname_U = [dataname ' U.dat'];
    resultname_V = [dataname ' V.dat'];
    resultname_x = [dataname ' X.dat'];
    resultname_y = [dataname ' Y.dat'];

    % Data is being loaded from our files.
    x = load(resultname_x);
    y = load(resultname_y);
    x = fliplr(x);
    y = fliplr(y);
    u = load(resultname_U);
    v = load(resultname_V);

    % shaping Data.
    L = size(v, 1);
    vv = reshape(v, [L, size(v, 2)/(floor(frameR/actF)), floor(frameR/actF)]);

    p1_mm = zeros(1, length(y));
    p2_mm = zeros(1, length(y));

    for ypos_i = 1:length(y)
        ypos_i_flipped = length(y) - ypos_i + 1;

        vv_mean_ypos_i = mean(vv(:, ypos_i_flipped, :), 3)';
        
        [Vcl_max_ypos_i, ~] = max(vv_mean_ypos_i);
        
        p1_ypos_i = find(abs(vv_mean_ypos_i) > 0.5 * Vcl_max_ypos_i, 1, 'first');
        p2_ypos_i = find(abs(vv_mean_ypos_i) > 0.5 * Vcl_max_ypos_i, 1, 'last');

        p1_mm(ypos_i) = x(p1_ypos_i);
        p2_mm(ypos_i) = x(p2_ypos_i);
    end

    % Calculation.
    jet_widths{freq_idx} = p2_mm - p1_mm; 
    y_positions{freq_idx} = y;         
end

%%% Plotter

figure('visible', 'on');
hold on;

for freq_idx = 1:num_frequencies
    plot(y_positions{freq_idx}, jet_widths{freq_idx}, '-', 'DisplayName', strcat(labels{freq_idx}), 'Color', colors{freq_idx}, 'LineWidth', 3);
end

set(gcf, 'units', 'centimeters', 'position', [2, 2, 14, 8]);
xlabel('y [mm]');
ylabel('Jet Width [mm]');
title('Jet Width for Different Frequencies');
legend('show', 'Location', 'northeast', 'Box', 'off');