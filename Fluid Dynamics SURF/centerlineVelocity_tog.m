frequencies = [20, 30, 40, 50, 60];
num_freqs = length(frequencies);

fig_centerline_vel = figure('visible', 'on');
hold on;

% Initializer
dataname = cell(1, num_freqs);
resultname_V = cell(1, num_freqs);
resultname_y = cell(1, num_freqs);
YY = cell(1, num_freqs);
V = cell(1, num_freqs);

for j = 1:num_freqs
    actF = frequencies(j);
    frameR = 20 * actF;

    path_analyzed = fullfile('/Users/josephpieper/SURF Project 2024/aug 30/', [num2str(actF) '(hole)Hz resultsfromcode']);

    case_name = [num2str(actF) '(hole)Hz'];
    dataname{j} = fullfile(path_analyzed, [case_name 'phase']);
    resultname_V{j} = [dataname{j} ' V.dat'];
    resultname_y{j} = [dataname{j} ' Y.dat'];

    % Loader
    y = load(resultname_y{j});
    y = fliplr(y);
    v = load(resultname_V{j});

    % Processer
    YY{j} = y;
    V{j} = v;

    v = cell2mat(V(j));
    y = cell2mat(YY(j));
    L = size(v,1);

    num_frames = floor(frameR / actF);
    vv = reshape(v, [L, size(v,2) / num_frames, num_frames]);
    
    number_grid_points_y = length(y);

    Vcl = zeros(1, number_grid_points_y);


    for ypos_i = 1:number_grid_points_y
        ypos_i_flipped = number_grid_points_y - ypos_i + 1;
        vv_mean_ypos_i = mean(vv(:, ypos_i_flipped, :), 3)';
        Vcl(ypos_i) = max(vv_mean_ypos_i);
    end

    % Plotter increasing size for 50Hz because not visible.
    if j == 4
        plot(y, Vcl, '.-', 'DisplayName', [num2str(actF) ' Hz'], 'LineWidth',5);
    else 
        plot(y, Vcl, '.-', 'DisplayName', [num2str(actF) ' Hz'], 'LineWidth',2);
    end
end

grid on;
xlabel('y [mm]');
ylabel('{V_{cl}} [mm/s]');
title('Centerline Velocity Distribution at Different Frequencies', 'FontSize', 10);
legend('show');
set(gcf, 'units', 'centimeters', 'position', [2, 2, 14, 12]);
