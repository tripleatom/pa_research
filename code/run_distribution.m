clc; clear; close all;

mat_path = 'F:/2020at/pa_research/mat/11.2/v_thres/';
result_path = 'F:/2020at/pa_research/result/11.2/distribution/';

surf_or_liquid = 'liq';

file = dir([mat_path surf_or_liquid '*.mat']);

%% run mode during
run = []; % unit is frame

for oo = 1:length(file)
    load([mat_path '/' file(oo).name]);
    disp(current_proj)

    for i = 1:length(velocity)
        left = 0;
        run_marker = false;
        temp_v = velocity(i).v;
        thres = velocity(i).threshold;

        for j = 1:length(temp_v)

            if temp_v(j) > thres && left == 0
                run_marker = true;
                left = j;
            elseif temp_v(j) <= thres && left ~= 0
                run_marker = false;
                temp_time = (j - 1 - left) / FrameRate;
                run = [run, temp_time];
                left = 0;
            elseif j == length(temp_v) && left ~= 0
                temp_time = (j - left) / FrameRate;
                run = [run, temp_time];
            end

        end

    end

end
duration_thres = 5/60;
run = run(run>duration_thres);

%% plt

h = histogram(run, 'Normalization', 'pdf');
% h.BinWidth = .04;
xlabel('run duration (s)')
ylabel('probability density function')

title_text = [surf_or_liquid ' run duration distribution'];
title(title_text)
xlim([0 2])
ylim([0 5.5])
%% save
fname = [result_path 'run_dur_' surf_or_liquid];
saveas(gca, fname, 'png')