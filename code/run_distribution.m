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

%% fit slope and plot
[counts, edges, bin] = histcounts(run);

indexes = counts < 10 | counts > 1e3; % Remove unwanted data
counts(indexes) = 0; % Set those bins to zero.

[~, index, v] = find(counts); % find non-zero frequence
counts = counts(index);
edges = edges(index);

f = fit(edges', counts', 'exp1'); % fit exponential function
plot(f, 'b--')
hold on
set(gca, 'YScale', 'log')

g = gca;
sigma_text = ['slope = ' num2str(f.b, '%.3f')];
text(g.XLim(2) * .7, g.YLim(2)^.85, sigma_text)

b = bar(edges, counts, 'EdgeAlpha', .2);
b.FaceColor = 'none';
xlabel('Time (s)')
ylabel('Counts')
legend('fitted curve')

current_time = datestr(now, 'mmdd-HH');
title_text = [surf_or_liquid ' run duration'];
title(title_text)

%% save
fname = [result_path 'run_dur_' surf_or_liquid '_' current_time];
saveas(gca, fname, 'png')
