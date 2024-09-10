cases = {'20(hole)Hz', '30(hole)Hz', '40(hole)Hz', '50(hole)Hz', '60(hole)Hz'};

%% This is the mac path for the data in my folder.
%paths = {
%    '/Users/josephpieper/SURF Project 2024/aug 08/20Hz resultsfromcode';
%    '/Users/josephpieper/SURF Project 2024/aug 08/30Hz resultsfromcode';
%    '/Users/josephpieper/SURF Project 2024/aug 08/50Hz resultsfromcode'
%};
paths = {
    '/Users/josephpieper/SURF Project 2024/aug 30/20(hole)Hz resultsfromcode';
    '/Users/josephpieper/SURF Project 2024/aug 30/30(hole)Hz resultsfromcode';
    '/Users/josephpieper/SURF Project 2024/aug 30/40(hole)Hz resultsfromcode';
    '/Users/josephpieper/SURF Project 2024/aug 30/50(hole)Hz resultsfromcode';
    '/Users/josephpieper/SURF Project 2024/aug 30/60(hole)Hz resultsfromcode';
};

frameRs = [400, 600, 800, 1000, 1200];
actFs = [20, 30, 40, 50, 60];

colors = {[0 0 1], [0 1 0], [1 0 0], [1 1 0], [0 1 1]}; 


fig_end = figure('visible', 'on');
hold on;


legend_entries = cell(length(cases), 1);

for i = 1:length(cases)
   
    path_analyzed = paths{i};
    case_name = cases{i};
    
    % Remember / on Mac.
    dataname = strcat(path_analyzed, '/', case_name, 'phase'); 
    frameR = frameRs(i);
    actF = actFs(i);

    % Phase Average
    resultname_V = [dataname ' V.dat'];
    resultname_x = [dataname ' X.dat'];
    resultname_y = [dataname ' Y.dat'];

    x = load(resultname_x);
    y = load(resultname_y);
    x = fliplr(x);
    y = fliplr(y);

    v = load(resultname_V);
   
    L = size(v,1);
    vv = reshape(v, [L, size(v,2)/(floor(frameR/actF)), floor(frameR/actF)]);
    
    number_grid_points_x = length(x);
    number_grid_points_y = length(y);
    number_phases = size(vv, 3);

    y_pos_end = number_grid_points_y;
    y_pos_end_flipped = number_grid_points_y - y_pos_end + 1;
    y_pos_middle = floor(number_grid_points_y/2);
    y_pos_middle_flipped = number_grid_points_y - y_pos_middle + 1;
    y_pos_beginning = 4;
    y_pos_beginning_flipped = number_grid_points_y - y_pos_beginning + 1;

    % This can be changed based on where we want to measure.
    plot(x, vv(:,  y_pos_beginning_flipped, 1), 'Color', colors{i}, 'DisplayName', strcat(case_name, ': \phi = ', num2str(1/number_phases * 1), 'T'));
   
    for j = 2:number_phases
        plot(x, vv(:,  y_pos_beginning_flipped, j), 'Color', colors{i}, 'HandleVisibility', 'off');
    end


    legend_entries{i} = strcat(case_name);
end


grid on
set(gcf, 'units', 'centimeters', 'position', [2, 2, 14, 12]);

legend(legend_entries, 'Location', 'Best');

xlabel('x [mm]')
ylabel('V [mm/s]')
ylim([-10 15])
title_str = sprintf('Cross-stream distribution of V at y = %d mm for 20, 30, 40, 50, 60 Hz', y_pos_beginning); %Change based on positioning.
title(title_str, 'FontSize', 9); 
ax = gca;