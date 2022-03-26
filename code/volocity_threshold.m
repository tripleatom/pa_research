clc; clear; close all;

mat_path = 'F:/2020at/pa_research/mat/11.2/delete_still/';
result_path = 'F:/2020at/pa_research/mat/11.2/v_thres/';

surf_or_liquid = 'surf';

file = dir([mat_path surf_or_liquid '*.mat']);

%% determine the threshold for velocity classification
for oo = 1:length(file)
    current_proj = file(oo).name(1:end -4);
    disp(current_proj)
    load([mat_path '/' file(oo).name]);

    % find two peaks
    for i = 1:length(velocity)
        [counts, edges] = histcounts(velocity(i).v, 50);
        [m, p1] = max(counts(1:20));
        [n, p2] = max(counts(21:50));

        peak1 = edges(p1);
        peak2 = edges(p2 + 20);

        velocity(i).threshold = mean([peak1, peak2]);
    end

    save([result_path '/' current_proj], 'tracks', 'movobj', 'velocity', 'FrameRate', 'current_proj')
    clearvars -except file mat_path oo i result_path

end
