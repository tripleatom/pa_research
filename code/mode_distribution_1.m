clc; clear; close all;

mat_path = 'F:/2020at/pa_research/mat/11.2/with_angle/';
result_path = 'F:/2020at/pa_research/result/11.2/distribution/';

surf_or_liquid = 'surf';
mode_choosen = 'pause2';
% pause: pause + worm
% pause2: pause exp2 fit
% worm: just pick worm
% run: run

file = dir([mat_path surf_or_liquid '*.mat']);

%% during of one mode
mode = []; % unit is s

track_num = 0;
worm_track = 0;
worm_thres = .25;

for oo = 1:length(file)
    load([mat_path '/' file(oo).name]);
    disp(current_proj)

    track_num = track_num + length(velocity);

    for i = 1:length(velocity)

        velocity_marker = true;

        temp_v = velocity(i).v;
        thres = velocity(i).threshold;

        if strcmp(mode_choosen, 'run')
            ind = temp_v > thres;
        elseif strcmp(mode_choosen, 'pause') || strcmp(mode_choosen, 'pause2') || strcmp(mode_choosen, 'worm')
            ind = (temp_v <= thres);
        end

        left = 0;
        mode_flag = false;

        for j = 1:length(temp_v)

            if ind(j) == 1 && mode_flag == false
                mode_flag = true;
                left = j;
            elseif ind(j) == 0 && mode_flag == true
                mode_flag = false;
                temp_time = (j - left) / FrameRate;

                if strcmp(mode_choosen, 'pause') || strcmp(mode_choosen, 'run') || strcmp(mode_choosen, 'pause2')
                    mode = [mode, temp_time];

                elseif strcmp(mode_choosen, 'worm')

                    if temp_time > worm_thres
                        mode = [mode, temp_time];
                    end

                    if temp_time > worm_thres && velocity_marker
                        worm_track = worm_track + 1;
                        velocity_marker = false;
                    end

                end

                left = 0;
            end

        end

    end

end

if strcmp(mode_choosen, 'pause')
    proportion = worm_track / track_num;
    disp(proportion)
end

if strcmp(mode_choosen, 'worm')
    worm_mean = mean(mode)
end

%% fit slope and plot
[counts, edges, bin] = histcounts(mode);

indexes = counts < 10 | counts > 1e3; % Remove unwanted data
counts(indexes) = 0; % Set those bins to zero.

[~, index, v] = find(counts); % find non-zero frequence
counts = counts(index);
edges = edges(index);

% fit exponential function
if strcmp(mode_choosen, 'pause2')
    f = fit(edges', counts', 'exp2');
else
    f = fit(edges', counts', 'exp1');
end

plot(f, 'b--')
hold on
set(gca, 'YScale', 'log')
xlim([min(edges) 2.5])
% xlim([min(edges) .25]) % for worm
ylim([10 1e3])

g = gca;

if strcmp(mode_choosen, 'pause2')
    sigma_text = ['\tau_1 = ' num2str(-1 / f.b, '%.3f') 's'; ...
                '\tau_2 = ' num2str(-1 / f.d, '%.3f') 's'];
else
    sigma_text = ['\tau = ' num2str(-1 / f.b, '%.3f') 's'];
end

text(g.XLim(2) * .8, g.YLim(2)^.85, sigma_text)

b = bar(edges, counts, 'EdgeAlpha', .5);
b.FaceColor = 'none';
xlabel('Time (s)')
ylabel('Counts')
legend('fitted curve')

current_time = datestr(now, 'mmdd-HH');
title_text = [surf_or_liquid ' ' mode_choosen ' duration'];
title(title_text)

%% save
fname = [result_path mode_choosen '_dur_' surf_or_liquid '_' current_time];
saveas(gca, fname, 'png')
